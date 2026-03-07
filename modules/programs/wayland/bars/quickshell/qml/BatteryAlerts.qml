import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick

Item {
    id: root

    property bool available: UPower.displayDevice.isLaptopBattery
    property int percent: Math.round((UPower.displayDevice.percentage ?? 0) * 100)
    property int state: UPower.displayDevice.state
    property bool charging: [
        UPowerDeviceState.Charging,
        UPowerDeviceState.PendingCharge,
        UPowerDeviceState.FullyCharged
    ].includes(state)
    property string pendingSummary: ""
    property string pendingBody: ""
    property string pendingUrgency: "normal"
    property bool lowSent: false
    property bool criticalSent: false
    property bool fullSent: false

    Process {
        id: notifyProcess
        command: ["notify-send", "-u", root.pendingUrgency, root.pendingSummary, root.pendingBody]
    }

    function sendNotification(summary, body, urgency) {
        root.pendingSummary = summary;
        root.pendingBody = body;
        root.pendingUrgency = urgency;
        notifyProcess.running = true;
    }

    function notifyIfNeeded() {
        if (!root.available)
            return;

        if (root.charging) {
            root.lowSent = false;
            root.criticalSent = false;
            if (root.percent < 95)
                root.fullSent = false;
            if (root.percent >= 100 && !root.fullSent) {
                root.sendNotification("Battery full", "You can unplug the charger.", "normal");
                root.fullSent = true;
            }
            return;
        }

        root.fullSent = false;

        if (root.percent > 20)
            root.lowSent = false;
        if (root.percent > 10)
            root.criticalSent = false;

        if (root.percent <= 10 && !root.criticalSent) {
            root.sendNotification("Critically low battery", "Plug in the charger soon.", "critical");
            root.criticalSent = true;
            return;
        }

        if (root.percent <= 20 && !root.lowSent) {
            root.sendNotification("Low battery", "Consider plugging in your device.", "normal");
            root.lowSent = true;
        }
    }

    Component.onCompleted: notifyIfNeeded()
    onAvailableChanged: notifyIfNeeded()
    onPercentChanged: notifyIfNeeded()
    onChargingChanged: notifyIfNeeded()
}
