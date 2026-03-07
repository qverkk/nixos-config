pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool available: false
    property int percent: 0

    Timer {
        running: true
        interval: 5000
        repeat: true
        triggeredOnStart: true
        onTriggered: brightnessPoll.running = true
    }

    Process {
        id: brightnessPoll
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim();
                if (output.length === 0) {
                    root.available = false;
                    root.percent = 0;
                    return;
                }

                const line = output.split("\n")[0];
                const parts = line.split(",");
                const lastField = parts.length > 0 ? parts[parts.length - 1] : "";
                const match = /(\d+)%/.exec(lastField);
                if (!match) {
                    root.available = false;
                    root.percent = 0;
                    return;
                }

                root.available = true;
                root.percent = parseInt(match[1], 10);
            }
        }
    }
}
