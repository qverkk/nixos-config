import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    property string sourceLanguage: "auto"
    property string targetLanguage: "en"
    property string translatedText: ""
    property bool busy: false

    function shellQuote(value) {
        return "'" + String(value).replace(/'/g, "'\"'\"'") + "'";
    }

    function translate() {
        if (root.busy)
            return;
        if (inputArea.text.trim().length === 0) {
            root.translatedText = "";
            return;
        }
        root.busy = true;
        translateProcess.buffer = "";
        translateProcess.running = true;
    }

    Process {
        id: translateProcess
        property string buffer: ""
        command: [
            "bash", "-lc",
            "trans -brief -source " + root.shellQuote(root.sourceLanguage)
                + " -target " + root.shellQuote(root.targetLanguage)
                + " " + root.shellQuote(inputArea.text.trim())
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                translateProcess.buffer = text;
            }
        }
        onExited: {
            root.busy = false;
            root.translatedText = translateProcess.buffer.trim();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            TextField {
                id: sourceField
                Layout.fillWidth: true
                text: root.sourceLanguage
                placeholderText: "Source"
                color: Colors.base05
                selectedTextColor: Colors.base00
                selectionColor: Colors.base0D
                onEditingFinished: root.sourceLanguage = text.trim().length > 0 ? text.trim() : "auto"
                background: Rectangle {
                    radius: 8
                    color: Colors.base02
                    border.width: 1
                    border.color: Colors.base03
                }
            }

            TextField {
                id: targetField
                Layout.fillWidth: true
                text: root.targetLanguage
                placeholderText: "Target"
                color: Colors.base05
                selectedTextColor: Colors.base00
                selectionColor: Colors.base0D
                onEditingFinished: root.targetLanguage = text.trim().length > 0 ? text.trim() : "en"
                background: Rectangle {
                    radius: 8
                    color: Colors.base02
                    border.width: 1
                    border.color: Colors.base03
                }
            }
        }

        TextArea {
            id: inputArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            placeholderText: "Enter text to translate"
            wrapMode: TextEdit.Wrap
            color: Colors.base05
            selectedTextColor: Colors.base00
            selectionColor: Colors.base0D
            background: Rectangle {
                radius: 10
                color: Colors.base02
                border.width: 1
                border.color: Colors.base03
            }
        }

        TextArea {
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            readOnly: true
            text: root.translatedText.length > 0 ? root.translatedText : (root.busy ? "Translating..." : "Translation output")
            wrapMode: TextEdit.Wrap
            color: Colors.base05
            selectedTextColor: Colors.base00
            selectionColor: Colors.base0D
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
                    text: "Clipboard"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 11
                    color: Colors.base05
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: inputArea.text = Quickshell.clipboardText
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: Qt.rgba(Colors.base0D.r, Colors.base0D.g, Colors.base0D.b, 0.2)

                Text {
                    anchors.centerIn: parent
                    text: root.busy ? "Working..." : "Translate"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 11
                    color: Colors.base0D
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.translate()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
