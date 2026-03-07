pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

RowLayout {
    id: root
    spacing: 8

    property var activeMenu: null

    function setActiveMenu(window) {
        root.activeMenu = window;
        focusGrab.active = true;
    }

    function clearActiveMenu() {
        focusGrab.active = false;
        root.activeMenu = null;
    }

    HyprlandFocusGrab {
        id: focusGrab
        active: false
        windows: root.activeMenu ? [root.activeMenu] : []
        onCleared: {
            if (root.activeMenu) {
                root.activeMenu.close();
                root.activeMenu = null;
            }
        }
    }

    Repeater {
        id: trayRepeater
        model: SystemTray.items

        delegate: SysTrayItem {
            required property SystemTrayItem modelData
            item: modelData
            Layout.preferredWidth: 22
            Layout.preferredHeight: 22
            Layout.alignment: Qt.AlignVCenter
            onMenuOpened: window => root.setActiveMenu(window)
            onMenuClosed: root.clearActiveMenu()
        }
    }
}
