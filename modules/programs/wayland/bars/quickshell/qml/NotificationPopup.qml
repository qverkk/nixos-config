import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: root

    visible: NotificationService.popupList.length > 0
    screen: Quickshell.screens.find(candidate => candidate.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
    color: "transparent"
    WlrLayershell.namespace: "quickshell-notification-popup"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    anchors.top: true
    anchors.right: true
    implicitWidth: 360
    implicitHeight: popupColumn.implicitHeight + 12
    mask: Region {
        item: popupColumn
    }

    Column {
        id: popupColumn
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        Repeater {
            model: NotificationService.popupList.slice().reverse()
            delegate: Rectangle {
                required property var modelData
                width: 340
                radius: 12
                color: Colors.base01
                border.width: 1
                border.color: Colors.base02
                implicitHeight: popupContent.implicitHeight + 16

                ColumnLayout {
                    id: popupContent
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            Layout.fillWidth: true
                            text: (modelData.appName || "Shell") + " • " + (modelData.summary || "Notification")
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            font.bold: true
                            color: Colors.base05
                            elide: Text.ElideRight
                        }

                        Text {
                            text: "\uf00d"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            color: Colors.base08

                            MouseArea {
                                anchors.fill: parent
                                onClicked: NotificationService.dismissNotification(modelData.notificationId)
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        visible: (modelData.body || "").length > 0
                        text: modelData.body
                        wrapMode: Text.Wrap
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 11
                        color: Colors.base04
                    }
                }
            }
        }
    }
}
