import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland._GlobalShortcuts

Scope {
    PanelWindow {
        id: root

        visible: ShellState.sidebarLeftOpen
        screen: Quickshell.screens.find(candidate => candidate.name === ShellState.sidebarLeftScreenName) ?? Quickshell.screens[0]
        color: "transparent"
        WlrLayershell.namespace: "quickshell-left-sidebar"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        anchors.top: true
        anchors.left: true
        anchors.bottom: true
        implicitWidth: 392
        mask: Region {
            item: sidebarRect
        }

        Rectangle {
            id: sidebarRect
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 8
            width: 376
            radius: 14
            color: Qt.rgba(Colors.base00.r, Colors.base00.g, Colors.base00.b, 0.97)
            border.width: 1
            border.color: Colors.base02
            focus: true
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    ShellState.closeSidebar();
                    event.accepted = true;
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Sidebar"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 14
                        font.bold: true
                        color: Colors.base05
                    }

                    Text {
                        text: "\uf00d"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 12
                        color: Colors.base08

                        MouseArea {
                            anchors.fill: parent
                            onClicked: ShellState.closeSidebar()
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 32
                        radius: 8
                        color: ShellState.sidebarLeftTab === 0
                            ? Qt.rgba(Colors.base0E.r, Colors.base0E.g, Colors.base0E.b, 0.2)
                            : Colors.base02

                        Text {
                            anchors.centerIn: parent
                            text: "Claude"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: ShellState.sidebarLeftTab === 0 ? Colors.base0E : Colors.base05
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: ShellState.sidebarLeftTab = 0
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 32
                        radius: 8
                        color: ShellState.sidebarLeftTab === 1
                            ? Qt.rgba(Colors.base0D.r, Colors.base0D.g, Colors.base0D.b, 0.2)
                            : Colors.base02

                        Text {
                            anchors.centerIn: parent
                            text: "Translate"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: ShellState.sidebarLeftTab === 1 ? Colors.base0D : Colors.base05
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: ShellState.sidebarLeftTab = 1
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Loader {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    sourceComponent: ShellState.sidebarLeftTab === 1 ? translatorComponent : aiComponent
                }
            }
        }
    }

    Component {
        id: aiComponent
        AiChatPanel {}
    }

    Component {
        id: translatorComponent
        TranslatorPanel {}
    }

    GlobalShortcut {
        name: "toggleSidebarLeft"
        onPressed: {
            const screenName = Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "";
            ShellState.toggleSidebar(screenName, ShellState.sidebarLeftTab);
        }
    }
}
