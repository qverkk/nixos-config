import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: osdWindow

        required property ShellScreen modelData
        screen: modelData

        anchors.bottom: true
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-osd"
        WlrLayershell.margins.bottom: 72
        color: "transparent"

        implicitWidth: 320
        implicitHeight: 56
        visible: osdTimer.running

        property real displayVolume: AudioService.volume
        property real lastVolume: -1

        onDisplayVolumeChanged: {
            if (lastVolume >= 0 && Math.abs(displayVolume - lastVolume) > 0.001)
                osdTimer.restart();
            lastVolume = displayVolume;
        }

        Timer {
            id: osdTimer
            interval: 2000
        }

        Rectangle {
            anchors.centerIn: parent
            width: 300
            height: 48
            radius: 1000
            color: Colors.base01
            opacity: osdTimer.running ? 1.0 : 0.0

            RowLayout {
                anchors.centerIn: parent
                spacing: 12

                Text {
                    text: AudioService.muted ? "\uf6a9" : "\uf028"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 16
                    color: Colors.base0D
                }

                Rectangle {
                    width: 180
                    height: 5
                    radius: 1000
                    color: Colors.base02

                    Rectangle {
                        width: parent.width * Math.min(1, AudioService.volume)
                        height: parent.height
                        radius: 1000
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: Colors.base0D }
                            GradientStop { position: 1.0; color: Colors.base0E }
                        }
                    }
                }

                Text {
                    text: Math.round(AudioService.volume * 100) + "%"
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 13
                    font.bold: true
                    color: Colors.base05
                }
            }
        }

    }
}
