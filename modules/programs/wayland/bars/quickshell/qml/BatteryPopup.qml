import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

PopupWindow {
    id: root

    required property Item anchorItem

    readonly property int percent: Math.round((UPower.displayDevice.percentage ?? 0) * 100)
    readonly property int state: UPower.displayDevice.state
    readonly property bool charging: [
        UPowerDeviceState.Charging,
        UPowerDeviceState.PendingCharge,
        UPowerDeviceState.FullyCharged
    ].includes(state)
    readonly property real timeValue: charging ? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty
    readonly property real energyRate: UPower.displayDevice.changeRate
    readonly property real health: {
        const devList = UPower.devices.values;
        for (let index = 0; index < devList.length; index += 1) {
            const dev = devList[index];
            if (dev.isLaptopBattery && dev.healthSupported) {
                const value = dev.healthPercentage;
                if (value === 0)
                    return 0.01;
                if (value < 1)
                    return value * 100;
                return value;
            }
        }
        return 0;
    }

    function formatDuration(seconds) {
        if (!seconds || seconds <= 0)
            return "Unknown";
        const totalSeconds = Math.round(seconds);
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        if (hours > 0)
            return hours + "h " + minutes + "m";
        return minutes + "m";
    }

    function statusLabel() {
        if (state === UPowerDeviceState.FullyCharged)
            return "Fully charged";
        if (state === UPowerDeviceState.PendingCharge)
            return "Plugged in";
        if (state === UPowerDeviceState.Charging)
            return "Charging";
        if (state === UPowerDeviceState.Discharging)
            return "Discharging";
        if (state === UPowerDeviceState.Empty)
            return "Empty";
        return "Unknown";
    }

    visible: true
    color: "transparent"
    implicitWidth: popupRect.implicitWidth
    implicitHeight: popupRect.implicitHeight
    anchor {
        window: anchorItem.QsWindow.window
        item: anchorItem
        edges: Edges.Bottom | Edges.Right
        gravity: Edges.Bottom | Edges.Right
    }
    mask: Region {
        item: popupRect
    }

    Rectangle {
        id: popupRect
        implicitWidth: 300
        implicitHeight: contentColumn.implicitHeight + 20
        radius: 12
        color: Colors.base01
        border.width: 1
        border.color: Colors.base02

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: root.charging ? "\uf0e7" : "\uf240"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 14
                    color: root.percent <= 20 && !root.charging ? Colors.base08 : Colors.base0E
                }

                Text {
                    Layout.fillWidth: true
                    text: "Battery"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 13
                    font.bold: true
                    color: Colors.base05
                }

                Rectangle {
                    radius: 8
                    color: Colors.base02
                    implicitWidth: percentLabel.implicitWidth + 10
                    implicitHeight: percentLabel.implicitHeight + 4

                    Text {
                        id: percentLabel
                        anchors.centerIn: parent
                        text: root.percent + "%"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 11
                        color: Colors.base05
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: 10
                color: Colors.base02
                border.width: 1
                border.color: Qt.rgba(Colors.base03.r, Colors.base03.g, Colors.base03.b, 0.6)
                implicitHeight: infoColumn.implicitHeight + 16

                ColumnLayout {
                    id: infoColumn
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Status"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base04
                        }

                        Text {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignRight
                            text: root.statusLabel()
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base05
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: root.timeValue > 0 && root.energyRate > 0.01 && root.state !== UPowerDeviceState.FullyCharged

                        Text {
                            text: root.charging ? "Time to full" : "Time to empty"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base04
                        }

                        Text {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignRight
                            text: root.formatDuration(root.timeValue)
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base05
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: root.energyRate > 0.01 && root.state !== UPowerDeviceState.FullyCharged

                        Text {
                            text: root.charging ? "Charge rate" : "Drain rate"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base04
                        }

                        Text {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignRight
                            text: root.energyRate.toFixed(2) + "W"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base05
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: root.health > 0

                        Text {
                            text: "Health"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base04
                        }

                        Text {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignRight
                            text: root.health.toFixed(1) + "%"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base05
                        }
                    }
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.charging ? "Charging information" : "Battery information"
                font.family: "CaskaydiaCove Nerd Font Mono"
                font.pixelSize: 11
                color: Colors.base04
            }
        }
    }
}
