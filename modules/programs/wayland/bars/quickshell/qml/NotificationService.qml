pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
    id: root

    component NotificationRecord: QtObject {
        required property int notificationId
        property Notification trackedNotification: null
        property string appNameOverride: "Shell"
        property string summaryOverride: ""
        property string bodyOverride: ""
        property string imageOverride: ""
        property string urgencyOverride: "normal"
        property var actionsOverride: []
        property bool popup: false
        property bool read: false
        property double time: Date.now()
        property Timer timer: null

        property string appName: trackedNotification?.appName ?? appNameOverride
        property string summary: trackedNotification?.summary ?? summaryOverride
        property string body: trackedNotification?.body ?? bodyOverride
        property string image: trackedNotification?.image ?? imageOverride
        property string urgency: trackedNotification?.urgency.toString() ?? urgencyOverride
        property var actions: trackedNotification
            ? trackedNotification.actions.map(action => ({
                identifier: action.identifier,
                text: action.text
            }))
            : actionsOverride
    }

    component PopupTimer: Timer {
        required property int notificationId
        interval: 7000
        running: true
        repeat: false
        onTriggered: {
            root.timeoutNotification(notificationId);
            destroy();
        }
    }

    property int unread: list.filter(notif => !notif.read).length
    property bool silent: false
    property int nextLocalId: 100000
    property list<NotificationRecord> list: []
    property var popupList: list.filter(notif => notif.popup)

    Component {
        id: notificationRecordComponent
        NotificationRecord {}
    }

    Component {
        id: popupTimerComponent
        PopupTimer {}
    }

    function appendRecord(record) {
        root.list = [...root.list, record];
    }

    function createPopupTimer(record, interval) {
        record.popup = !root.silent;
        if (!record.popup) {
            root.list = root.list.slice();
            return;
        }
        record.timer = popupTimerComponent.createObject(root, {
            notificationId: record.notificationId,
            interval: interval
        });
        root.list = root.list.slice();
    }

    function pushLocal(appName, summary, body, urgency) {
        const record = notificationRecordComponent.createObject(root, {
            notificationId: root.nextLocalId,
            appNameOverride: appName,
            summaryOverride: summary,
            bodyOverride: body,
            urgencyOverride: urgency || "normal",
            time: Date.now()
        });
        root.nextLocalId += 1;
        appendRecord(record);
        createPopupTimer(record, 7000);
    }

    function markAllRead() {
        for (const record of root.list)
            record.read = true;
        root.list = root.list.slice();
    }

    function timeoutNotification(id) {
        const record = root.list.find(notif => notif.notificationId === id);
        if (!record)
            return;
        record.popup = false;
        if (record.timer) {
            record.timer.stop();
            record.timer = null;
        }
        root.list = root.list.slice();
    }

    function dismissNotification(id) {
        const record = root.list.find(notif => notif.notificationId === id);
        if (!record)
            return;
        if (record.timer) {
            record.timer.stop();
            record.timer.destroy();
            record.timer = null;
        }
        if (record.trackedNotification)
            record.trackedNotification.dismiss();
        root.list = root.list.filter(notif => notif.notificationId !== id);
        record.destroy();
    }

    function clearAll() {
        const current = root.list.slice();
        for (const record of current) {
            if (record.timer) {
                record.timer.stop();
                record.timer.destroy();
                record.timer = null;
            }
            if (record.trackedNotification)
                record.trackedNotification.dismiss();
            record.destroy();
        }
        root.list = [];
    }

    function invokeAction(id, identifier) {
        const record = root.list.find(notif => notif.notificationId === id);
        if (!record || !record.trackedNotification)
            return;
        const action = record.trackedNotification.actions.find(candidate => candidate.identifier === identifier);
        if (action)
            action.invoke();
        dismissNotification(id);
    }

    NotificationServer {
        id: notificationServer
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: notification => {
            notification.tracked = true;
            const expireTimeout = notification.expireTimeout < 0 ? 7000 : notification.expireTimeout;
            const record = notificationRecordComponent.createObject(root, {
                notificationId: notification.id,
                trackedNotification: notification,
                time: Date.now()
            });
            appendRecord(record);
            if (expireTimeout !== 0)
                createPopupTimer(record, expireTimeout);
        }
    }
}
