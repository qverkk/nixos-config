pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property bool calendarOpen: false
    property string calendarScreenName: ""
    property bool batteryOpen: false
    property string batteryScreenName: ""
    property bool powerOpen: false
    property string powerScreenName: ""

    function togglePower(screenName) {
        if (screenName && screenName.length > 0)
            root.powerScreenName = screenName;
        root.powerOpen = !root.powerOpen;
        if (root.powerOpen) {
            root.calendarOpen = false;
            root.batteryOpen = false;
        }
    }

    function toggleBattery(screenName) {
        if (screenName && screenName.length > 0)
            root.batteryScreenName = screenName;
        root.batteryOpen = !root.batteryOpen;
        if (root.batteryOpen) {
            root.calendarOpen = false;
            root.powerOpen = false;
        }
    }

    function toggleCalendar(screenName) {
        if (screenName && screenName.length > 0)
            root.calendarScreenName = screenName;
        root.calendarOpen = !root.calendarOpen;
        if (root.calendarOpen) {
            root.batteryOpen = false;
            root.powerOpen = false;
        }
    }

    function closePopups() {
        root.calendarOpen = false;
        root.batteryOpen = false;
        root.powerOpen = false;
    }
}
