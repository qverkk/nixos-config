import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PopupWindow {
    id: root

    required property Item anchorItem

    property string pendingMode: ""

    function runAction(mode) {
        root.pendingMode = mode;
        ShellState.closePopups();
        if (mode === "logout")
            logoutProcess.running = true;
        else if (mode === "reboot")
            rebootProcess.running = true;
        else if (mode === "shutdown")
            shutdownProcess.running = true;
    }

    visible: true
    color: "transparent"
    implicitWidth: popupRect.implicitWidth
    implicitHeight: popupRect.implicitHeight
    anchor {
        window: anchorItem.QsWindow.window
        item: anchorItem
        edges: Edges.Bottom | Edges.Right
        gravity: Edges.Bottom | Edges.Right
    }
    mask: Region {
        item: popupRect
    }

    Process {
        id: logoutProcess
        command: ["hyprctl", "dispatch", "exit"]
    }

    Process {
        id: rebootProcess
        command: ["kitty", "-e", "bash", "-lc", "sudo reboot now"]
    }

    Process {
        id: shutdownProcess
        command: ["kitty", "-e", "bash", "-lc", "sudo shutdown now"]
    }

    Rectangle {
        id: popupRect
        implicitWidth: 180
        implicitHeight: contentColumn.implicitHeight + 20
        radius: 12
        color: Colors.base01
        border.width: 1
        border.color: Colors.base02

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: "Power"
                font.family: "CaskaydiaCove Nerd Font Mono"
                font.pixelSize: 13
                font.bold: true
                color: Colors.base05
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                radius: 10
                color: Qt.rgba(Colors.base08.r, Colors.base08.g, Colors.base08.b, 0.18)

                Text {
                    anchors.centerIn: parent
                    text: "Logout"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 12
                    color: Colors.base08
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.runAction("logout")
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                radius: 10
                color: Qt.rgba(Colors.base0A.r, Colors.base0A.g, Colors.base0A.b, 0.18)

                Text {
                    anchors.centerIn: parent
                    text: "Reboot"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 12
                    color: Colors.base0A
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.runAction("reboot")
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                radius: 10
                color: Qt.rgba(Colors.base08.r, Colors.base08.g, Colors.base08.b, 0.18)

                Text {
                    anchors.centerIn: parent
                    text: "Shutdown"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 12
                    color: Colors.base08
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.runAction("shutdown")
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
