pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Hyprland._GlobalShortcuts
import QtQuick

// One full-screen transparent overlay per monitor.
// Tracks mouse position and shows DashboardPanel when the cursor
// enters the top-edge hover zone (top ~58 px = bar height).
// Also respects DashboardState.pinnedOpen for keyboard/click toggles.
Variants {
    model: Quickshell.screens

    PanelWindow {
        id: overlayWindow

        required property ShellScreen modelData
        screen: modelData

        // Span the whole screen but don't reserve any space for other windows
        anchors.top: true
        anchors.left: true
        anchors.right: true
        anchors.bottom: true
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-dashboard"
        color: "transparent"

        readonly property int hoverStripHeight: 58
        readonly property int hoverTolerance: 12

        function withinPanelWidth(x: real): bool {
            const minX = dashPanel.x - hoverTolerance;
            const maxX = dashPanel.x + dashPanel.width + hoverTolerance;
            return x >= minX && x <= maxX;
        }

        function inTopHoverZone(x: real, y: real): bool {
            return y <= hoverStripHeight && withinPanelWidth(x);
        }

        function inPanelBounds(x: real, y: real): bool {
            return x >= dashPanel.x - hoverTolerance
                && x <= dashPanel.x + dashPanel.width + hoverTolerance
                && y >= 0
                && y <= dashPanel.animatedHeight + hoverTolerance;
        }

        // Keep both the dashboard panel area and a thin top-edge hover strip
        // interactive. Everything else remains click-through.
        mask: Region {
            x: 0
            y: 0
            width: overlayWindow.width
            height: overlayWindow.height
            intersection: Intersection.Xor

            Region {
                item: dashPanel
                intersection: Intersection.Subtract
            }

            Region {
                readonly property int stripX: Math.max(0, dashPanel.x - overlayWindow.hoverTolerance)

                x: stripX
                y: 0
                width: Math.min(
                    overlayWindow.width - stripX,
                    dashPanel.width + overlayWindow.hoverTolerance * 2
                )
                height: overlayWindow.hoverStripHeight
                intersection: Intersection.Subtract
            }
        }

        // Whether the dashboard is currently shown
        property bool dashVisible: DashboardState.pinnedOpen

        // ── Hover zone tracking ──────────────────────────────────────────────
        // A MouseArea that fills the entire screen.  hoverEnabled: true so we
        // receive position events even without a button press.
        MouseArea {
            id: screenTracker
            anchors.fill: parent
            hoverEnabled: true
            // Don't swallow clicks — let them through to underlying windows
            // (the mask already handles this, but propagateComposedEvents is
            // belt-and-suspenders for the transparent areas)
            propagateComposedEvents: true
            acceptedButtons: Qt.NoButton

            onPositionChanged: mouse => {
                const inTopZone = overlayWindow.inTopHoverZone(mouse.x, mouse.y);
                const inPanel = overlayWindow.inPanelBounds(mouse.x, mouse.y);

                if (!DashboardState.pinnedOpen) {
                    overlayWindow.dashVisible = inTopZone || inPanel;
                }
            }

            onExited: {
                if (!DashboardState.pinnedOpen) {
                    overlayWindow.dashVisible = false;
                }
            }
        }

        // ── Sync with pinned state ───────────────────────────────────────────
        Connections {
            target: DashboardState
            function onPinnedOpenChanged() {
                overlayWindow.dashVisible = DashboardState.pinnedOpen;
            }
        }

        // ── Dashboard panel ──────────────────────────────────────────────────
        DashboardPanel {
            id: dashPanel
            // Horizontally centred, anchored to the top of the screen
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            dashVisible: overlayWindow.dashVisible
        }

        // ── Keyboard shortcut ────────────────────────────────────────────────
        // SUPER + D  toggles pinned-open state.
        // (Register the binding in your Hyprland config:
        //   bind = SUPER, D, global, quickshell:toggleDashboard)
        GlobalShortcut {
            name: "toggleDashboard"
            onPressed: {
                DashboardState.pinnedOpen = !DashboardState.pinnedOpen;
            }
        }
    }
}
