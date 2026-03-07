pragma Singleton

import Quickshell
import QtQuick

// Shared state for the hover dashboard.
// Bar.qml reads isPlaying / trackTitle for the indicator pill.
// Dashboard.qml reads/writes pinnedOpen to honour keyboard toggle + bar-click.
Singleton {
    // Set true by keyboard shortcut or bar indicator click to keep dashboard
    // visible even when the mouse is not in the top-edge hover zone.
    property bool pinnedOpen: false
}
