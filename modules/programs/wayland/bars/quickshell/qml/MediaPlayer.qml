import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    visible: root.player !== null
    implicitHeight: 30
    implicitWidth: visible ? mediaRow.implicitWidth + 20 : 0
    radius: 1000
    color: Colors.base01

    RowLayout {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: "\uf048"
            font.family: "CaskaydiaCove Nerd Font Mono"
            font.pixelSize: 12
            color: Colors.base05
            opacity: 0.7
            MouseArea {
                anchors.fill: parent
                onClicked: root.player?.previous()
                cursorShape: Qt.PointingHandCursor
            }
        }

        Text {
            text: root.player?.isPlaying ? "\uf04c" : "\uf04b"
            font.family: "CaskaydiaCove Nerd Font Mono"
            font.pixelSize: 13
            color: Colors.base0D
            MouseArea {
                anchors.fill: parent
                onClicked: root.player?.togglePlaying()
                cursorShape: Qt.PointingHandCursor
            }
        }

        Text {
            text: "\uf051"
            font.family: "CaskaydiaCove Nerd Font Mono"
            font.pixelSize: 12
            color: Colors.base05
            opacity: 0.7
            MouseArea {
                anchors.fill: parent
                onClicked: root.player?.next()
                cursorShape: Qt.PointingHandCursor
            }
        }

        Text {
            visible: (root.player?.trackTitle ?? "") !== ""
            text: {
                if (!root.player) return "";
                const title = root.player.trackTitle || "";
                return title.length > 25 ? title.substring(0, 25) + "…" : title;
            }
            font.family: "CaskaydiaCove Nerd Font Mono"
            font.pixelSize: 12
            color: Colors.base05
        }
    }
}
