pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Services.Mpris
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: barWindow

        required property ShellScreen modelData
        screen: modelData

        anchors.top: true
        anchors.left: true
        anchors.right: true

        // ExclusionMode.Auto with exactly 3 anchors (top+left+right, no bottom)
        // causes Hyprland to reserve space equal to the window height + margins.
        WlrLayershell.exclusionMode: ExclusionMode.Auto
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-bar"
        WlrLayershell.margins.top: 0
        WlrLayershell.margins.left: 0
        WlrLayershell.margins.right: 0
        color: "transparent"
        // Height = 6px top gap + 40px bar + 6px bottom gap so windows
        // get pushed down by the full 52px.
        implicitHeight: 40

        property bool idleInhibited: false
        property string clockStr: ""
        property string kbLayout: "??"

        // Poll keyboard layout via hyprctl devices -j every 2 seconds.
        // Use StdioCollector (not SplitParser) because JSON spans multiple lines.
        Timer {
            running: true
            interval: 2000
            repeat: true
            triggeredOnStart: true
            onTriggered: kbPoll.running = true
        }
        Process {
            id: kbPoll
            command: ["hyprctl", "devices", "-j"]
            stdout: StdioCollector {
                onStreamFinished: {
                    try {
                        const obj = JSON.parse(text);
                        const kbs = obj.keyboards ?? [];
                        const main = kbs.find(k => k.main) ?? kbs[0];
                        if (!main) { barWindow.kbLayout = "??"; return; }
                        const layout = main.active_keymap ?? "";
                        if (layout.toLowerCase().indexOf("polish") >= 0)
                            barWindow.kbLayout = "PL";
                        else if (layout.toLowerCase().indexOf("english") >= 0)
                            barWindow.kbLayout = "EN";
                        else
                            barWindow.kbLayout = layout.substring(0, 2).toUpperCase() || "??";
                    } catch(e) { barWindow.kbLayout = "??"; }
                }
            }
        }

        Timer {
            running: true
            interval: 1000
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                const d = new Date();
                const h = d.getHours().toString().padStart(2, "0");
                const m = d.getMinutes().toString().padStart(2, "0");
                barWindow.clockStr = h + ":" + m;
            }
        }

        // Floating bar container — sits 6px from top, 8px from left/right
        Rectangle {
            id: barContainer
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 0
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            height: 40
            radius: 12
            color: Qt.rgba(
                Colors.base00.r,
                Colors.base00.g,
                Colors.base00.b,
                0.92
            )

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 6

                // === LEFT: Audio pill ===
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: audioRow.implicitWidth + 20
                    radius: 1000
                    color: Colors.base01

                    RowLayout {
                        id: audioRow
                        anchors.centerIn: parent
                        spacing: 5

                        Item {
                            implicitWidth: speakerRow.implicitWidth
                            implicitHeight: speakerRow.implicitHeight

                            RowLayout {
                                id: speakerRow
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: AudioService.muted ? "\uf6a9" : "\uf028"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 13
                                    color: Colors.base0D
                                }
                                Text {
                                    text: Math.round(AudioService.volume * 100) + "%"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 12
                                    color: Colors.base05
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: audioLaunch.running = true
                                cursorShape: Qt.PointingHandCursor
                            }

                            Process {
                                id: audioLaunch
                                command: ["pavucontrol"]
                            }
                        }

                        Rectangle { width: 1; height: 12; color: Colors.base02 }

                        Item {
                            implicitWidth: micRow.implicitWidth
                            implicitHeight: micRow.implicitHeight

                            RowLayout {
                                id: micRow
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: AudioService.sourceMuted ? "\uf131" : "\uf130"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 13
                                    color: Colors.base0B
                                }
                                Text {
                                    text: Math.round(AudioService.sourceVolume * 100) + "%"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 12
                                    color: Colors.base05
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: micToggle.running = true
                                cursorShape: Qt.PointingHandCursor
                            }

                            Process {
                                id: micToggle
                                command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]
                            }
                        }

                        Rectangle { width: 1; height: 12; color: Colors.base02; visible: BrightnessService.available }

                        Item {
                            visible: BrightnessService.available
                            implicitWidth: brightnessRow.implicitWidth
                            implicitHeight: brightnessRow.implicitHeight

                            RowLayout {
                                id: brightnessRow
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "\uf185"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 13
                                    color: Colors.base0A
                                }
                                Text {
                                    text: BrightnessService.percent + "%"
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 12
                                    color: Colors.base05
                                }
                            }
                        }
                    }
                }

                // === LEFT: Sysinfo pill ===
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: sysRow.implicitWidth + 20
                    radius: 1000
                    color: Colors.base01

                    RowLayout {
                        id: sysRow
                        anchors.centerIn: parent
                        spacing: 5

                        // CPU — nf-fa-microchip \uf2db
                        Text {
                            text: "\uf2db"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 13
                            color: Colors.base08
                        }
                        Text {
                            text: SysInfo.cpuPercent + "%"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            color: Colors.base05
                        }

                        Rectangle { width: 1; height: 12; color: Colors.base02 }

                        // RAM — nf-fa-memory \uf538 not in all fonts, use text label
                        Text {
                            text: "RAM"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 11
                            color: Colors.base0E
                        }
                        Text {
                            text: SysInfo.memPercent + "%"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            color: Colors.base05
                        }

                        Rectangle { width: 1; height: 12; color: Colors.base02 }

                        // Disk — nf-fa-hdd \uf0a0
                        Text {
                            text: "\uf0a0"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 13
                            color: Colors.base0A
                        }
                        Text {
                            text: SysInfo.diskFree
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            color: Colors.base05
                        }
                    }
                }

                // === LEFT: Idle inhibitor ===
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 36
                    radius: 1000
                    color: barWindow.idleInhibited ? Colors.base0A : Colors.base01

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            barWindow.idleInhibited = !barWindow.idleInhibited;
                            if (barWindow.idleInhibited)
                                idleStart.running = true;
                            else
                                idleStop.running = true;
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                    Process {
                        id: idleStart
                        command: ["sh", "-c", "systemd-inhibit --what=idle --who=quickshell --why=user --mode=block sleep infinity &"]
                    }
                    Process {
                        id: idleStop
                        command: ["sh", "-c", "pkill -f 'sleep infinity'"]
                    }

                    Text {
                        anchors.centerIn: parent
                        text: barWindow.idleInhibited ? "\uf06e" : "\uf070"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 13
                        color: barWindow.idleInhibited ? Colors.base00 : Colors.base05
                    }
                }

                // === SPACER ===
                Item { Layout.fillWidth: true }

                // === CENTER: Workspaces ===
                Workspaces {
                    Layout.alignment: Qt.AlignVCenter
                }

                // === SPACER ===
                Item { Layout.fillWidth: true }

                // === RIGHT: Now-playing indicator pill ===
                // Shows a music note icon + pulsing dot when media is active.
                // Click toggles DashboardState.pinnedOpen to pin the dashboard open.
                Rectangle {
                    id: nowPlayingPill
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 28

                    readonly property var player: Mpris.players.values.length > 0
                        ? Mpris.players.values[0] : null
                    readonly property bool playing: player?.isPlaying ?? false

                    // Only show when there is an active player
                    visible: player !== null
                    Layout.preferredWidth: visible ? nowPlayingRow.implicitWidth + 20 : 0

                    radius: 1000
                    color: DashboardState.pinnedOpen
                        ? Qt.rgba(Colors.base0D.r, Colors.base0D.g, Colors.base0D.b, 0.25)
                        : Colors.base01

                    MouseArea {
                        anchors.fill: parent
                        onClicked: DashboardState.pinnedOpen = !DashboardState.pinnedOpen
                        cursorShape: Qt.PointingHandCursor
                    }

                    RowLayout {
                        id: nowPlayingRow
                        anchors.centerIn: parent
                        spacing: 6

                        // Music note icon
                        Text {
                            text: "\uf001"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 13
                            color: nowPlayingPill.playing ? Colors.base0D : Colors.base05
                        }

                        // Pulsing dot when playing
                        Rectangle {
                            visible: nowPlayingPill.playing
                            width: 6; height: 6; radius: 3
                            color: Colors.base0B

                        }
                    }
                }

                // === RIGHT: Status pill ===
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: statusRow.implicitWidth + 20
                    radius: 1000
                    color: Colors.base01

                    RowLayout {
                        id: statusRow
                        anchors.centerIn: parent
                        spacing: 6

                        // Power button — nf-fa-power-off \uf011
                        Item {
                            id: powerButton
                            implicitWidth: powerIcon.implicitWidth
                            implicitHeight: 28

                            Text {
                                id: powerIcon
                                anchors.centerIn: parent
                                text: "\uf011"
                                font.family: "CaskaydiaCove Nerd Font Mono"
                                font.pixelSize: 13
                                color: Colors.base08
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: ShellState.togglePower(barWindow.screen.name)
                                cursorShape: Qt.PointingHandCursor
                            }

                            Loader {
                                active: ShellState.powerOpen && ShellState.powerScreenName === barWindow.screen.name
                                sourceComponent: PowerPopup {
                                    anchorItem: powerButton
                                }
                            }
                        }

                        Rectangle { width: 1; height: 12; color: Colors.base02 }

                        // Keyboard layout — nf-fa-keyboard \uf11c
                        Text {
                            text: "\uf11c " + barWindow.kbLayout
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            color: Colors.base05
                        }

                        Rectangle { width: 1; height: 12; color: Colors.base02 }

                        // Bluetooth — nf-fa-bluetooth \uf293 / nf-fa-bluetooth-b \uf294
                        Text {
                            text: {
                                if (!Bluetooth.defaultAdapter?.enabled) return "\uf293";
                                if (Bluetooth.devices.values.some(d => d.connected)) return "\uf294";
                                return "\uf293";
                            }
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 13
                            color: Bluetooth.defaultAdapter?.enabled
                                ? (Bluetooth.devices.values.some(d => d.connected) ? Colors.base0D : Colors.base05)
                                : Colors.base03

                            MouseArea {
                                anchors.fill: parent
                                onClicked: bluetoothLaunch.running = true
                                cursorShape: Qt.PointingHandCursor
                            }

                            Process {
                                id: bluetoothLaunch
                                command: ["blueman-manager"]
                            }
                        }

                        Rectangle { width: 1; height: 12; color: Colors.base02 }

                        Item {
                            implicitWidth: netRow.implicitWidth
                            implicitHeight: 28

                            MouseArea {
                                anchors.fill: parent
                                onClicked: netLaunch.running = true
                                cursorShape: Qt.PointingHandCursor
                            }

                            Process {
                                id: netLaunch
                                command: ["kitty", "-e", "nmtui"]
                            }

                            RowLayout {
                                id: netRow
                                anchors.centerIn: parent
                                spacing: 4

                                Text {
                                    text: {
                                        if (!NetworkInfo.connected) return "\uf071";
                                        if (NetworkInfo.connectionType === "ethernet") return "\uf796";
                                        return "\uf1eb";
                                    }
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 13
                                    color: NetworkInfo.connected ? Colors.base0B : Colors.base08
                                }

                                Text {
                                    visible: NetworkInfo.connected
                                    text: {
                                        if (!NetworkInfo.connected) return "";
                                        if (NetworkInfo.connectionType === "wifi")
                                            return NetworkInfo.connectionName + " " + NetworkInfo.signal + "%";
                                        return NetworkInfo.connectionName;
                                    }
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 12
                                    color: Colors.base05
                                }
                            }
                        }

                        // Battery (laptops only)
                        Rectangle {
                            id: batteryPill
                            visible: UPower.displayDevice.isLaptopBattery
                            width: visible ? batRow.implicitWidth + 8 : 0
                            height: 28
                            color: "transparent"

                            MouseArea {
                                anchors.fill: parent
                                onClicked: ShellState.toggleBattery(barWindow.screen.name)
                                cursorShape: Qt.PointingHandCursor
                            }

                            RowLayout {
                                id: batRow
                                anchors.centerIn: parent
                                spacing: 4

                                Rectangle { width: 1; height: 12; color: Colors.base02 }

                                Text {
                                    text: {
                                        const perc = Math.round(UPower.displayDevice.percentage * 100);
                                        const charging = [UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged, UPowerDeviceState.PendingCharge].includes(UPower.displayDevice.state);
                                        return (charging ? "\uf0e7" : "\uf240") + " " + perc + "%";
                                    }
                                    font.family: "CaskaydiaCove Nerd Font Mono"
                                    font.pixelSize: 12
                                    color: {
                                        const perc = Math.round(UPower.displayDevice.percentage * 100);
                                        if (perc <= 20) return Colors.base08;
                                        if (perc <= 40) return Colors.base0A;
                                        return Colors.base05;
                                    }
                                }
                            }

                            Loader {
                                active: ShellState.batteryOpen && ShellState.batteryScreenName === barWindow.screen.name
                                sourceComponent: BatteryPopup {
                                    anchorItem: batteryPill
                                }
                            }
                        }
                    }
                }

                // === RIGHT: Tray ===
                Rectangle {
                    id: trayPill
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: trayWidget.implicitWidth > 0 ? trayWidget.implicitWidth + 16 : 0
                    visible: trayWidget.implicitWidth > 0
                    radius: 1000
                    color: Colors.base01
                    clip: true

                    TrayWidget {
                        id: trayWidget
                        anchors.centerIn: parent
                        height: parent.height
                    }
                }

                // === RIGHT: Clock — same pill style as others, accent text ===
                Rectangle {
                    id: clockPill
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: clockRow.implicitWidth + 20
                    radius: 1000
                    color: Colors.base01

                    MouseArea {
                        anchors.fill: parent
                        onClicked: ShellState.toggleCalendar(barWindow.screen.name)
                        cursorShape: Qt.PointingHandCursor
                    }

                    RowLayout {
                        id: clockRow
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "\uf017"
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 13
                            color: Colors.base0E
                        }
                        Text {
                            text: barWindow.clockStr
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 13
                            font.bold: true
                            color: Colors.base0C
                        }
                    }

                    Loader {
                        active: ShellState.calendarOpen && ShellState.calendarScreenName === barWindow.screen.name
                        sourceComponent: CalendarPopup {
                            anchorItem: clockPill
                        }
                    }
                }

            } // RowLayout
        } // barContainer
    } // PanelWindow
} // Variants
