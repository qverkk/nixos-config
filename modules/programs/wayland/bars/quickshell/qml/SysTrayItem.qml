// Adapted from dots-hyprland SysTrayItem.qml
// Removed: Qt5Compat.GraphicalEffects, monochrome icon support
// Removed: Config.options.* references
// PopupToolTip -> inline PopupWindow tooltip
// TrayService.getTooltipForItem -> still used (our simplified singleton)
// Anchor: hardcoded for top horizontal bar

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

MouseArea {
    id: root
    required property SystemTrayItem item

    signal menuOpened(qsWindow: var)
    signal menuClosed()

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 20
    implicitHeight: 20

    onPressed: event => {
        switch (event.button) {
        case Qt.LeftButton:
            root.item.activate();
            break;
        case Qt.RightButton:
            if (root.item.hasMenu) menu.open();
            break;
        }
        event.accepted = true;
    }

    // Hover highlight
    Rectangle {
        anchors.fill: parent
        radius: 6
        color: root.containsMouse
            ? Qt.rgba(Colors.base05.r, Colors.base05.g, Colors.base05.b, 0.15)
            : "transparent"
    }

    IconImage {
        id: trayIcon
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    // Menu (lazy-loaded PopupWindow via SysTrayMenu)
    Loader {
        id: menu
        function open() {
            menu.active = true;
        }
        active: false
        sourceComponent: SysTrayMenu {
            Component.onCompleted: this.open();
            trayItemMenuHandle: root.item.menu
            // Top horizontal bar: anchor popup below the tray icon
            anchor {
                window: root.QsWindow.window
                item: root
                edges: Edges.Bottom | Edges.Left
                gravity: Edges.Bottom | Edges.Left
            }
            onMenuOpened: window => root.menuOpened(window);
            onMenuClosed: {
                root.menuClosed();
                menu.active = false;
            }
        }
    }

    // Tooltip: separate PassivePopupWindow so it's not clipped by the bar window
    Loader {
        id: tooltipLoader
        active: root.containsMouse
        sourceComponent: PopupWindow {
            visible: true
            color: "transparent"
            // Input-transparent so it doesn't block clicks
            mask: Region { item: null }
            anchor {
                window: root.QsWindow.window
                item: root
                edges: Edges.Bottom | Edges.Left
                gravity: Edges.Bottom | Edges.Left
            }
            implicitWidth: tooltipRect.implicitWidth
            implicitHeight: tooltipRect.implicitHeight

            Rectangle {
                id: tooltipRect
                readonly property string tooltipText: TrayService.getTooltipForItem(root.item)
                implicitWidth: tooltipLabel.implicitWidth + 16
                implicitHeight: tooltipLabel.implicitHeight + 8
                color: Colors.base01
                radius: 6
                border.width: 1
                border.color: Colors.base02

                Text {
                    id: tooltipLabel
                    anchors.centerIn: parent
                    text: tooltipRect.tooltipText
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 12
                    color: Colors.base05
                }
            }
        }
    }
}
