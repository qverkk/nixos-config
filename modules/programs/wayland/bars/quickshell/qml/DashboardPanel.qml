pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

// The visible dashboard panel that slides down from the top of the screen.
// It is hosted inside Dashboard.qml's full-screen overlay window.
// Width is constrained to a reasonable panel width, centred horizontally.
Item {
    id: root

    // Whether the panel should be visible (driven by Dashboard.qml)
    property bool dashVisible: false

    // Panel dimensions
    readonly property int panelW: 760
    readonly property int panelH: 160

    // Horizontal centre on whatever screen width the parent has
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    width: panelW
    // implicitHeight drives the slide-in animation; clip keeps content tidy
    height: animatedHeight
    clip: true

    property real animatedHeight: 0


    // React to dashVisible changes
    onDashVisibleChanged: {
        animatedHeight = dashVisible ? (panelH + 12) : 0;
    }

    // ── Background card ──────────────────────────────────────────────────────
    Rectangle {
        id: card
        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            right: parent.right
        }
        height: root.panelH
        radius: 16
        color: Qt.rgba(Colors.base00.r, Colors.base00.g, Colors.base00.b, 0.96)

        // Subtle border
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Qt.rgba(Colors.base03.r, Colors.base03.g, Colors.base03.b, 0.5)
            border.width: 1
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 20

            // ── LEFT: Workspaces ────────────────────────────────────────────
            Rectangle {
                Layout.preferredWidth: 260
                Layout.fillHeight: true
                radius: 12
                color: Qt.rgba(Colors.base01.r, Colors.base01.g, Colors.base01.b, 0.7)

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    // Section label
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "WORKSPACES"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 9
                        font.letterSpacing: 2
                        color: Colors.base04
                    }

                    // Workspace grid — 5 × 2
                    Item {
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: wsGrid.implicitWidth
                        implicitHeight: wsGrid.implicitHeight

                        Grid {
                            id: wsGrid
                            columns: 5
                            rowSpacing: 6
                            columnSpacing: 6

                            readonly property int activeWsId: Hyprland.focusedWorkspace?.id ?? -1

                            Repeater {
                                model: 10
                                delegate: Rectangle {
                                    id: wsBtn
                                    required property int index
                                    readonly property int wsId: index + 1
                                    readonly property bool active: wsGrid.activeWsId === wsId
                                    // A workspace only exists in Hyprland.workspaces when it has open windows.
                                    // Binding directly to .values makes QML track the ObjectModel reactively.
                                    readonly property bool occupied: {
                                        const ws = Hyprland.workspaces.values;
                                        for (let i = 0; i < ws.length; i++) {
                                            if (ws[i].id === wsId)
                                                return true;
                                        }
                                        return false;
                                    }

                                    width: 40
                                    height: 32
                                    radius: 8

                                    gradient: wsBtn.active ? activeGrad : null
                                    color: wsBtn.active ? "transparent"
                                         : Qt.rgba(Colors.base02.r, Colors.base02.g, Colors.base02.b, 0.8)

                                    Gradient {
                                        id: activeGrad
                                        orientation: Gradient.Horizontal
                                        GradientStop { position: 0.0; color: Colors.base0D }
                                        GradientStop { position: 1.0; color: Colors.base0E }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        anchors.verticalCenterOffset: wsBtn.occupied && !wsBtn.active ? -3 : 0
                                        text: wsBtn.wsId
                                        font.family: "CaskaydiaCove Nerd Font Mono"
                                        font.pixelSize: 13
                                        font.bold: wsBtn.active
                                        color: wsBtn.active ? Colors.base00 : Colors.base05
                                        opacity: wsBtn.active ? 1.0 : 0.6
                                    }

                                    // Occupied dot — shown below the number when a window is open
                                    Rectangle {
                                        visible: wsBtn.occupied && !wsBtn.active
                                        width: 5
                                        height: 5
                                        radius: 3
                                        color: Colors.base05
                                        opacity: 0.8
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.bottom: parent.bottom
                                        anchors.bottomMargin: 3
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: Hyprland.dispatch("workspace " + wsBtn.wsId)
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── DIVIDER ──────────────────────────────────────────────────────
            Rectangle {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
                Layout.topMargin: 8
                Layout.bottomMargin: 8
                color: Qt.rgba(Colors.base03.r, Colors.base03.g, Colors.base03.b, 0.4)
            }

            // ── RIGHT: Media player ──────────────────────────────────────────
            Item {
                id: mediaSection
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Single player reference used by all children
                readonly property var player: Mpris.players.values.length > 0
                    ? Mpris.players.values[0] : null
                readonly property bool playing: player?.isPlaying ?? false

                // "No media" placeholder
                Text {
                    anchors.centerIn: parent
                    visible: mediaSection.player === null
                    text: "\uf001  No media playing"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 13
                    color: Colors.base04
                }

                // Full media controls (shown when a player is active)
                RowLayout {
                    id: mediaRow
                    anchors.fill: parent
                    visible: mediaSection.player !== null
                    spacing: 16

                    // Album art placeholder circle
                    Rectangle {
                        id: albumArt
                        Layout.preferredWidth: 88
                        Layout.preferredHeight: 88
                        Layout.alignment: Qt.AlignVCenter
                        radius: 44
                        color: Qt.rgba(Colors.base01.r, Colors.base01.g, Colors.base01.b, 0.9)
                        clip: true

                        AnimatedImage {
                            anchors.fill: parent
                            anchors.margins: 6
                            visible: mediaSection.playing
                            playing: visible
                            fillMode: Image.PreserveAspectFit
                            source: Qt.resolvedUrl("assets/bongocat.gif")
                        }

                        Text {
                            anchors.centerIn: parent
                            visible: !mediaSection.playing
                            text: "\uf001"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 28
                            color: Colors.base0D
                            opacity: mediaSection.player !== null ? 0.8 : 0.4
                        }

                    }

                    // Track info + controls
                    ColumnLayout {
                        id: trackInfo
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 6

                        // Track title
                        Text {
                            Layout.fillWidth: true
                            text: {
                                const t = mediaSection.player?.trackTitle ?? "";
                                return t.length > 36 ? t.substring(0, 36) + "…" : (t || "Unknown Track");
                            }
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 15
                            font.bold: true
                            color: Colors.base05
                            elide: Text.ElideRight
                        }

                        // Artist
                        Text {
                            Layout.fillWidth: true
                            text: {
                                const artists = mediaSection.player?.trackArtists ?? [];
                                const a = Array.isArray(artists) ? artists.join(", ") : String(artists);
                                return a.length > 40 ? a.substring(0, 40) + "…" : (a || "Unknown Artist");
                            }
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            color: Colors.base04
                            elide: Text.ElideRight
                        }

                        // Album (if available)
                        Text {
                            Layout.fillWidth: true
                            text: {
                                const al = mediaSection.player?.trackAlbum ?? "";
                                return al.length > 40 ? al.substring(0, 40) + "…" : al;
                            }
                            visible: (mediaSection.player?.trackAlbum ?? "") !== ""
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base03
                            elide: Text.ElideRight
                        }

                        // Transport controls
                        RowLayout {
                            id: controls
                            spacing: 12
                            Layout.topMargin: 4

                            // Previous
                            Rectangle {
                                width: 32; height: 32; radius: 16
                                color: prevArea.containsMouse
                                    ? Qt.rgba(Colors.base02.r, Colors.base02.g, Colors.base02.b, 0.8)
                                    : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uf048"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 14
                                    color: Colors.base05
                                    opacity: 0.75
                                }
                                MouseArea {
                                    id: prevArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: mediaSection.player?.previous()
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }

                            // Play / Pause
                            Rectangle {
                                width: 40; height: 40; radius: 20
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: Colors.base0D }
                                    GradientStop { position: 1.0; color: Colors.base0E }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: mediaSection.player?.isPlaying ? "\uf04c" : "\uf04b"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 15
                                    color: Colors.base00
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: mediaSection.player?.togglePlaying()
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }

                            // Next
                            Rectangle {
                                width: 32; height: 32; radius: 16
                                color: nextArea.containsMouse
                                    ? Qt.rgba(Colors.base02.r, Colors.base02.g, Colors.base02.b, 0.8)
                                    : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uf051"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 14
                                    color: Colors.base05
                                    opacity: 0.75
                                }
                                MouseArea {
                                    id: nextArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: mediaSection.player?.next()
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }
                    }
                }
            }
        } // RowLayout (card contents)
    } // card Rectangle
} // root Item
