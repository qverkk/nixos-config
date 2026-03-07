pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// Capsule container with a sliding accent indicator behind the active workspace
Rectangle {
    id: root

    readonly property int wsCount: 10
    readonly property int itemW: 28
    readonly property int itemH: 24
    readonly property int itemSpacing: 3
    readonly property int hPad: 6

    readonly property int activeWsId: Hyprland.focusedWorkspace?.id ?? -1

    color: Colors.base01
    radius: 1000
    implicitHeight: itemH + 8
    implicitWidth: wsCount * itemW + (wsCount - 1) * itemSpacing + hPad * 2

    // Sliding accent indicator
    Rectangle {
        id: indicator
        width: itemW
        height: itemH
        radius: 1000
        y: (root.implicitHeight - itemH) / 2
        x: {
            const idx = Math.max(0, Math.min(root.wsCount - 1, root.activeWsId - 1));
            return root.hPad + idx * (root.itemW + root.itemSpacing);
        }
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Colors.base0D }
            GradientStop { position: 1.0; color: Colors.base0E }
        }

    }

    // Workspace buttons row
    Row {
        id: wsRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.hPad
        spacing: root.itemSpacing

        Repeater {
            model: root.wsCount

            Item {
                id: wsItem
                required property int index
                readonly property int wsId: index + 1
                readonly property bool active: root.activeWsId === wsId

                width: root.itemW
                height: root.itemH

                Text {
                    anchors.centerIn: parent
                    text: wsItem.wsId
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 11
                    font.bold: wsItem.active
                    color: wsItem.active ? Colors.base00 : Colors.base05
                    opacity: wsItem.active ? 1.0 : 0.55

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + wsItem.wsId)
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            if (event.angleDelta.y > 0)
                Hyprland.dispatch("workspace e-1");
            else
                Hyprland.dispatch("workspace e+1");
        }
    }
}
