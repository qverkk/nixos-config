import QtQuick
import QtQuick.Layouts
import Quickshell

PopupWindow {
    id: root

    required property Item anchorItem

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

    Component.onCompleted: NotificationService.markAllRead()

    Rectangle {
        id: popupRect
        implicitWidth: 360
        implicitHeight: Math.min(520, contentColumn.implicitHeight + 20)
        radius: 12
        color: Colors.base01
        border.width: 1
        border.color: Colors.base02

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "\uf0f3"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 14
                    color: Colors.base0E
                }

                Text {
                    Layout.fillWidth: true
                    text: "Notifications"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 13
                    font.bold: true
                    color: Colors.base05
                }

                Rectangle {
                    visible: NotificationService.list.length > 0
                    radius: 8
                    color: Colors.base02
                    implicitWidth: unreadLabel.implicitWidth + 10
                    implicitHeight: unreadLabel.implicitHeight + 4

                    Text {
                        id: unreadLabel
                        anchors.centerIn: parent
                        text: NotificationService.list.length
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 11
                        color: Colors.base05
                    }
                }
            }

            Flickable {
                Layout.fillWidth: true
                Layout.preferredHeight: 400
                clip: true
                contentWidth: width
                contentHeight: listColumn.implicitHeight

                Column {
                    id: listColumn
                    width: parent.width
                    spacing: 8

                    Repeater {
                        model: NotificationService.list.slice().reverse()
                        delegate: Rectangle {
                            id: notificationCard
                            required property var modelData
                            width: listColumn.width
                            radius: 10
                            color: Colors.base02
                            border.width: 1
                            border.color: Qt.rgba(Colors.base03.r, Colors.base03.g, Colors.base03.b, 0.6)
                            implicitHeight: entryColumn.implicitHeight + 16

                            ColumnLayout {
                                id: entryColumn
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

                                RowLayout {
                                    Layout.fillWidth: true
                                    visible: modelData.actions.length > 0
                                    spacing: 6

                                    Repeater {
                                        model: modelData.actions
                                        delegate: Rectangle {
                                            required property var modelData
                                            radius: 8
                                            color: Qt.rgba(Colors.base0D.r, Colors.base0D.g, Colors.base0D.b, 0.2)
                                            implicitWidth: actionLabel.implicitWidth + 12
                                            implicitHeight: actionLabel.implicitHeight + 6

                                            Text {
                                                id: actionLabel
                                                anchors.centerIn: parent
                                                text: modelData.text
                                                font.family: "CaskaydiaCove Nerd Font Mono"
                                                font.pixelSize: 11
                                                color: Colors.base0D
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: NotificationService.invokeAction(notificationCard.modelData.notificationId, modelData.identifier)
                                                cursorShape: Qt.PointingHandCursor
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        visible: NotificationService.list.length === 0
                        width: listColumn.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "No notifications"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 12
                        color: Colors.base04
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 30
                    radius: 8
                    color: Colors.base02

                    Text {
                        anchors.centerIn: parent
                        text: NotificationService.silent ? "Popups off" : "Popups on"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 11
                        color: Colors.base05
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.silent = !NotificationService.silent
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 30
                    radius: 8
                    color: Colors.base02

                    Text {
                        anchors.centerIn: parent
                        text: "Clear all"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 11
                        color: Colors.base08
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.clearAll()
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
