pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string connectionType: ""
    property string connectionName: ""
    property int signal: 0
    property bool connected: false

    Timer {
        running: true
        interval: 5000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            nmcli.running = true;
            wifiSignal.running = true;
        }
    }

    // Get active connection type and name (no SIGNAL field — not supported on 'device' table)
    Process {
        id: nmcli
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                let found = false;
                for (const line of lines) {
                    const parts = line.split(":");
                    // parts[0]=type, parts[1]=state, parts[2]=connection
                    if (parts.length >= 3 && parts[1] === "connected"
                            && parts[0] !== "loopback" && parts[0] !== "tun"
                            && parts[0] !== "bridge") {
                        root.connectionType = parts[0];
                        root.connectionName = parts[2];
                        root.connected = true;
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    root.connected = false;
                    root.connectionType = "";
                    root.connectionName = "";
                    root.signal = 0;
                }
            }
        }
    }

    // Get wifi signal separately via 'nmcli device wifi' (only valid for wifi)
    Process {
        id: wifiSignal
        command: ["nmcli", "-t", "-f", "SSID,SIGNAL,ACTIVE", "device", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                for (const line of lines) {
                    const parts = line.split(":");
                    // parts[0]=ssid, parts[1]=signal, parts[2]=active (yes/no)
                    if (parts.length >= 3 && parts[2] === "yes") {
                        root.signal = parseInt(parts[1] || "0", 10);
                        break;
                    }
                }
            }
        }
    }
}
