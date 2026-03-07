// Adapted from dots-hyprland SysTrayMenu.qml
// StackView (QtQuick.Controls) -> custom Item-based stack to avoid Kirigami dependency
// StyledRectangularShadow -> removed
// Appearance.* -> Colors.* / hardcoded values
// Config.options.bar.* -> hardcoded for top horizontal bar

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

PopupWindow {
    id: root
    required property QsMenuHandle trayItemMenuHandle

    signal menuClosed
    signal menuOpened(qsWindow: var)

    color: "transparent"
    property real padding: 4

    implicitWidth: popupBackground.implicitWidth + padding * 2
    implicitHeight: popupBackground.implicitHeight + padding * 2

    function open() {
        root.visible = true;
        root.menuOpened(root);
    }

    function close() {
        root.visible = false;
        menuStack.popAll();
        root.menuClosed();
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.RightButton
        onPressed: event => {
            if ((event.button === Qt.BackButton || event.button === Qt.RightButton) && menuStack.depth > 1)
                menuStack.pop();
        }

        Rectangle {
            id: popupBackground
            readonly property real innerPadding: 4

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: root.padding
            }

            color: Colors.base01
            radius: 10
            border.width: 1
            border.color: Colors.base02
            clip: true

            implicitWidth: menuStack.implicitWidth + innerPadding * 2
            implicitHeight: menuStack.implicitHeight + innerPadding * 2

            // Custom stack replacing QtQuick.Controls.StackView (avoids Kirigami dependency)
            Item {
                id: menuStack
                anchors {
                    fill: parent
                    margins: popupBackground.innerPadding
                }

                property var _items: []
                property int depth: 0
                readonly property var currentItem: _items.length > 0 ? _items[_items.length - 1] : null

                implicitWidth: currentItem ? currentItem.implicitWidth : 0
                implicitHeight: currentItem ? currentItem.implicitHeight : 0

                Component.onCompleted: {
                    var initial = subMenuComponent.createObject(menuStack, {
                        handle: root.trayItemMenuHandle,
                        isSubMenu: false
                    });
                    _items = [initial];
                    depth = 1;
                }

                function push(component, props) {
                    if (_items.length > 0)
                        _items[_items.length - 1].visible = false;
                    var item = component.createObject(menuStack, props || {});
                    _items.push(item);
                    _items = _items;
                    depth = _items.length;
                }

                function pop() {
                    if (_items.length <= 1) return;
                    var item = _items[_items.length - 1];
                    _items.pop();
                    _items = _items;
                    depth = _items.length;
                    item.destroy();
                    if (_items.length > 0)
                        _items[_items.length - 1].visible = true;
                }

                function popAll() {
                    while (_items.length > 1) {
                        var item = _items.pop();
                        item.destroy();
                    }
                    _items = _items;
                    depth = _items.length;
                    if (_items.length > 0)
                        _items[0].visible = true;
                }
            }
        }
    }

    component SubMenu: ColumnLayout {
        id: submenu
        required property QsMenuHandle handle
        property bool isSubMenu: false

        QsMenuOpener {
            id: menuOpener
            menu: submenu.handle
        }

        spacing: 0

        // Back button (only shown in submenus)
        Loader {
            Layout.fillWidth: true
            visible: submenu.isSubMenu
            active: visible
            sourceComponent: Item {
                implicitWidth: backRow.implicitWidth + 24
                implicitHeight: 36

                Rectangle {
                    anchors.fill: parent
                    radius: popupBackground.radius - popupBackground.innerPadding
                    color: backMouse.containsMouse
                        ? Qt.rgba(Colors.base05.r, Colors.base05.g, Colors.base05.b, 0.12)
                        : "transparent"
                }

                RowLayout {
                    id: backRow
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 12 }
                    spacing: 6
                    Text {
                        text: "\uf053" // nf-fa-chevron-left
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 11
                        color: Colors.base05
                    }
                    Text {
                        text: "Back"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 12
                        color: Colors.base05
                    }
                }

                MouseArea {
                    id: backMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: menuStack.pop()
                }
            }
        }

        Repeater {
            id: menuEntriesRepeater
            property bool iconColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].icon.length > 0)
                        return true;
                }
                return false;
            }
            property bool specialInteractionColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].buttonType !== QsMenuButtonType.None)
                        return true;
                }
                return false;
            }
            model: menuOpener.children

            delegate: SysTrayMenuEntry {
                required property QsMenuEntry modelData
                menuEntry: modelData
                forceIconColumn: menuEntriesRepeater.iconColumnNeeded
                forceSpecialInteractionColumn: menuEntriesRepeater.specialInteractionColumnNeeded
                buttonRadius: popupBackground.radius - popupBackground.innerPadding

                onDismiss: root.close()
                onOpenSubmenu: handle => {
                    menuStack.push(subMenuComponent, {
                        handle: handle,
                        isSubMenu: true
                    });
                }
            }
        }
    }

    Component {
        id: subMenuComponent
        SubMenu {}
    }
}
