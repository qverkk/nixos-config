import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    property list<var> messages: []
    property bool busy: false
    property string modelName: "claude-3-5-sonnet-latest"

    function shellQuote(value) {
        return "'" + String(value).replace(/'/g, "'\"'\"'") + "'";
    }

    function payload() {
        return JSON.stringify({
            model: root.modelName,
            max_tokens: 1024,
            messages: root.messages.map(message => ({
                role: message.role,
                content: message.content
            }))
        });
    }

    function appendMessage(role, content) {
        root.messages = [...root.messages, { role: role, content: content }];
    }

    function sendMessage() {
        const prompt = inputArea.text.trim();
        if (root.busy || prompt.length === 0)
            return;
        appendMessage("user", prompt);
        inputArea.text = "";
        root.busy = true;
        anthropicProcess.buffer = "";
        anthropicProcess.running = true;
    }

    function clearConversation() {
        root.messages = [];
    }

    Process {
        id: anthropicProcess
        property string buffer: ""
        command: [
            "bash", "-lc",
            "if [ -z \"$ANTHROPIC_API_KEY\" ]; then printf '{\"error\":{\"message\":\"ANTHROPIC_API_KEY is not set\"}}'; exit 0; fi; "
                + "curl -s https://api.anthropic.com/v1/messages "
                + "-H 'content-type: application/json' "
                + "-H 'anthropic-version: 2023-06-01' "
                + "-H \"x-api-key: $ANTHROPIC_API_KEY\" "
                + "--data-raw " + root.shellQuote(root.payload())
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                anthropicProcess.buffer = text;
            }
        }
        onExited: {
            root.busy = false;
            let responseText = "";
            try {
                const response = JSON.parse(anthropicProcess.buffer);
                if (response.error)
                    responseText = response.error.message || "Anthropic request failed";
                else
                    responseText = (response.content || [])
                        .filter(block => block.type === "text")
                        .map(block => block.text)
                        .join("\n\n");
            } catch (error) {
                responseText = anthropicProcess.buffer.trim().length > 0
                    ? anthropicProcess.buffer.trim()
                    : "Failed to parse Anthropic response";
            }

            if (responseText.length === 0)
                responseText = "No response returned.";

            appendMessage("assistant", responseText);
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            Text {
                Layout.fillWidth: true
                text: "Claude"
                font.family: "CaskaydiaCove Nerd Font Mono"
                font.pixelSize: 13
                font.bold: true
                color: Colors.base05
            }

            Rectangle {
                radius: 8
                color: Colors.base02
                implicitWidth: modelLabel.implicitWidth + 12
                implicitHeight: modelLabel.implicitHeight + 6

                Text {
                    id: modelLabel
                    anchors.centerIn: parent
                    text: root.modelName
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 10
                    color: Colors.base04
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: width
            contentHeight: messageColumn.implicitHeight

            Column {
                id: messageColumn
                width: parent.width
                spacing: 8

                Repeater {
                    model: root.messages
                    delegate: Rectangle {
                        required property var modelData
                        width: messageColumn.width
                        radius: 10
                        color: modelData.role === "user"
                            ? Qt.rgba(Colors.base0D.r, Colors.base0D.g, Colors.base0D.b, 0.18)
                            : Colors.base02
                        border.width: 1
                        border.color: modelData.role === "user" ? Colors.base0D : Colors.base03
                        implicitHeight: messageText.implicitHeight + 18

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 6

                            Text {
                                text: modelData.role === "user" ? "You" : "Claude"
                                font.family: "CaskaydiaCove Nerd Font Mono"
                                font.pixelSize: 10
                                font.bold: true
                                color: modelData.role === "user" ? Colors.base0D : Colors.base0E
                            }

                            Text {
                                id: messageText
                                Layout.fillWidth: true
                                text: modelData.content
                                wrapMode: Text.Wrap
                                font.family: "CaskaydiaCove Nerd Font Mono"
                                font.pixelSize: 11
                                color: Colors.base05
                            }
                        }
                    }
                }

                Text {
                    visible: root.messages.length === 0
                    width: messageColumn.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "Set ANTHROPIC_API_KEY in your environment to use Claude here."
                    wrapMode: Text.Wrap
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 11
                    color: Colors.base04
                }
            }
        }

        TextArea {
            id: inputArea
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            placeholderText: "Ask Claude anything"
            wrapMode: TextEdit.Wrap
            color: Colors.base05
            selectedTextColor: Colors.base00
            selectionColor: Colors.base0D
            Keys.onPressed: event => {
                if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && (event.modifiers & Qt.ControlModifier)) {
                    root.sendMessage();
                    event.accepted = true;
                }
            }
            background: Rectangle {
                radius: 10
                color: Colors.base02
                border.width: 1
                border.color: Colors.base03
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: Colors.base02

                Text {
                    anchors.centerIn: parent
                    text: "Clear"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 11
                    color: Colors.base05
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.clearConversation()
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: Qt.rgba(Colors.base0E.r, Colors.base0E.g, Colors.base0E.b, 0.2)

                Text {
                    anchors.centerIn: parent
                    text: root.busy ? "Thinking..." : "Send"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 11
                    color: Colors.base0E
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.sendMessage()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
