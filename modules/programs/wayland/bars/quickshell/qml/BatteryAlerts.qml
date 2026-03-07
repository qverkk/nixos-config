import Quickshell.Services.UPower
import QtQuick

QtObject {
    id: root

    property bool available: UPower.displayDevice.isLaptopBattery
    property int percent: Math.round((UPower.displayDevice.percentage ?? 0) * 100)
    property int state: UPower.displayDevice.state
    property bool charging: [
        UPowerDeviceState.Charging,
        UPowerDeviceState.PendingCharge,
        UPowerDeviceState.FullyCharged
    ].includes(state)
    property bool lowSent: false
    property bool criticalSent: false
    property bool fullSent: false

    function notifyIfNeeded() {
        if (!root.available)
            return;

        if (root.charging) {
            root.lowSent = false;
            root.criticalSent = false;
            if (root.percent < 95)
                root.fullSent = false;
            if (root.percent >= 100 && !root.fullSent) {
                NotificationService.pushLocal("Battery", "Battery full", "You can unplug the charger.", "normal");
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
            NotificationService.pushLocal("Battery", "Critically low battery", "Plug in the charger soon.", "critical");
            root.criticalSent = true;
            return;
        }

        if (root.percent <= 20 && !root.lowSent) {
            NotificationService.pushLocal("Battery", "Low battery", "Consider plugging in your device.", "normal");
            root.lowSent = true;
        }
    }

    Component.onCompleted: notifyIfNeeded()
    onAvailableChanged: notifyIfNeeded()
    onPercentChanged: notifyIfNeeded()
    onChargingChanged: notifyIfNeeded()
}
