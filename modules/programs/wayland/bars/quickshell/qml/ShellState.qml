pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property bool sidebarLeftOpen: false
    property int sidebarLeftTab: 0
    property string sidebarLeftScreenName: ""
    property bool notificationsOpen: false
    property string notificationsScreenName: ""
    property bool calendarOpen: false
    property string calendarScreenName: ""

    function openSidebar(screenName, tabIndex) {
        if (screenName && screenName.length > 0)
            root.sidebarLeftScreenName = screenName;
        if (typeof tabIndex === "number")
            root.sidebarLeftTab = tabIndex;
        root.sidebarLeftOpen = true;
    }

    function toggleSidebar(screenName, tabIndex) {
        if (root.sidebarLeftOpen) {
            root.sidebarLeftOpen = false;
            return;
        }

        root.openSidebar(screenName, tabIndex);
    }

    function closeSidebar() {
        root.sidebarLeftOpen = false;
    }

    function toggleNotifications(screenName) {
        if (screenName && screenName.length > 0)
            root.notificationsScreenName = screenName;
        root.notificationsOpen = !root.notificationsOpen;
        if (root.notificationsOpen)
            root.calendarOpen = false;
    }

    function toggleCalendar(screenName) {
        if (screenName && screenName.length > 0)
            root.calendarScreenName = screenName;
        root.calendarOpen = !root.calendarOpen;
        if (root.calendarOpen)
            root.notificationsOpen = false;
    }

    function closePopups() {
        root.notificationsOpen = false;
        root.calendarOpen = false;
    }
}
