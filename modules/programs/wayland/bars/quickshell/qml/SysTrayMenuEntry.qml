pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// Adapted from dots-hyprland SysTrayMenuEntry.qml
// RippleButton -> Item + Rectangle + MouseArea
// MaterialSymbol -> Text (Nerd Font)
// StyledText -> Text
// StyledRadioButton -> inline Rectangle
// Appearance.* -> Colors.*
Item {
    id: root
    required property QsMenuEntry menuEntry
    property bool forceIconColumn: false
    property bool forceSpecialInteractionColumn: false
    property real buttonRadius: 8
    property real horizontalPadding: 12

    readonly property bool hasIcon: menuEntry.icon.length > 0
    readonly property bool hasSpecialInteraction: menuEntry.buttonType !== QsMenuButtonType.None

    signal dismiss()
    signal openSubmenu(handle: QsMenuHandle)

    implicitWidth: contentRow.implicitWidth + horizontalPadding * 2
    implicitHeight: menuEntry.isSeparator ? 1 : 36
    Layout.topMargin: menuEntry.isSeparator ? 4 : 0
    Layout.bottomMargin: menuEntry.isSeparator ? 4 : 0
    Layout.fillWidth: true

    // Background: separator line or hover highlight
    Rectangle {
        anchors.fill: parent
        radius: root.buttonRadius
        color: root.menuEntry.isSeparator
            ? Colors.base02
            : (hoverArea.containsMouse
                ? Qt.rgba(Colors.base05.r, Colors.base05.g, Colors.base05.b, 0.12)
                : "transparent")
    }

    RowLayout {
        id: contentRow
        visible: !root.menuEntry.isSeparator
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 8

        // Checkbox / radio button column
        Item {
            visible: root.hasSpecialInteraction || root.forceSpecialInteractionColumn
            implicitWidth: 16
            implicitHeight: 16

            // Radio button
            Loader {
                anchors.fill: parent
                active: root.menuEntry.buttonType === QsMenuButtonType.RadioButton
                sourceComponent: Rectangle {
                    color: "transparent"
                    radius: width / 2
                    border.width: 2
                    border.color: Colors.base05
                    Rectangle {
                        anchors.centerIn: parent
                        visible: root.menuEntry.checkState === Qt.Checked
                        width: 6; height: 6; radius: 3
                        color: Colors.base05
                    }
                }
            }

            // Checkmark (nf-fa-check / nf-fa-minus)
            Loader {
                anchors.fill: parent
                active: root.menuEntry.buttonType === QsMenuButtonType.CheckBox
                    && root.menuEntry.checkState !== Qt.Unchecked
                sourceComponent: Text {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: root.menuEntry.checkState === Qt.PartiallyChecked ? "\uf068" : "\uf00c"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 12
                    color: Colors.base05
                }
            }
        }

        // Icon column
        Item {
            visible: root.hasIcon || root.forceIconColumn
            implicitWidth: 16
            implicitHeight: 16
            Loader {
                anchors.centerIn: parent
                active: root.menuEntry.icon.length > 0
                sourceComponent: IconImage {
                    asynchronous: true
                    source: root.menuEntry.icon
                    implicitSize: 16
                    mipmap: true
                }
            }
        }

        // Label
        Text {
            text: root.menuEntry.text
            font.family: "CaskaydiaCove Nerd Font Mono"
            font.pixelSize: 12
            color: Colors.base05
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        // Submenu arrow (nf-fa-chevron-right)
        Loader {
            active: root.menuEntry.hasChildren
            sourceComponent: Text {
                text: "\uf054"
                font.family: "CaskaydiaCove Nerd Font Mono"
                font.pixelSize: 11
                color: Colors.base04
            }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: !root.menuEntry.isSeparator
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onReleased: event => {
            if (event.button === Qt.RightButton) {
                event.accepted = false;
                return;
            }
            if (root.menuEntry.hasChildren) {
                root.openSubmenu(root.menuEntry);
                return;
            }
            root.menuEntry.triggered();
            root.dismiss();
        }
    }
}
