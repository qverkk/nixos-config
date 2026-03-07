import QtQuick
import QtQuick.Layouts
import Quickshell

PopupWindow {
    id: root

    required property Item anchorItem
    property date displayedDate: new Date()

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate();
    }

    function firstDayOffset(year, month) {
        return (new Date(year, month, 1).getDay() + 6) % 7;
    }

    function monthLabel() {
        return Qt.formatDate(displayedDate, "MMMM yyyy");
    }

    function cells() {
        const year = displayedDate.getFullYear();
        const month = displayedDate.getMonth();
        const offset = firstDayOffset(year, month);
        const currentMonthDays = daysInMonth(year, month);
        const previousMonthDays = daysInMonth(year, month - 1);
        const today = new Date();
        const result = [];

        for (let index = 0; index < 42; index += 1) {
            let day = 0;
            let monthOffset = 0;
            if (index < offset) {
                day = previousMonthDays - offset + index + 1;
                monthOffset = -1;
            } else if (index >= offset + currentMonthDays) {
                day = index - offset - currentMonthDays + 1;
                monthOffset = 1;
            } else {
                day = index - offset + 1;
            }

            const cellDate = new Date(year, month + monthOffset, day);
            result.push({
                day: day,
                inMonth: monthOffset === 0,
                today: cellDate.getFullYear() === today.getFullYear()
                    && cellDate.getMonth() === today.getMonth()
                    && cellDate.getDate() === today.getDate()
            });
        }

        return result;
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
        implicitWidth: 280
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

                Rectangle {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    radius: 14
                    color: Colors.base02

                    Text {
                        anchors.centerIn: parent
                        text: "<"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 12
                        color: Colors.base05
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.displayedDate = new Date(root.displayedDate.getFullYear(), root.displayedDate.getMonth() - 1, 1)
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: root.monthLabel()
                    font.family: "CaskaydiaCove Nerd Font Mono"
                    font.pixelSize: 13
                    font.bold: true
                    color: Colors.base05
                }

                Rectangle {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    radius: 14
                    color: Colors.base02

                    Text {
                        anchors.centerIn: parent
                        text: ">"
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 12
                        color: Colors.base05
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.displayedDate = new Date(root.displayedDate.getFullYear(), root.displayedDate.getMonth() + 1, 1)
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 7
                rowSpacing: 6
                columnSpacing: 6

                Repeater {
                    model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                    delegate: Text {
                        required property var modelData
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        font.family: "CaskaydiaCove Nerd Font Mono"
                        font.pixelSize: 11
                        color: Colors.base04
                    }
                }

                Repeater {
                    model: root.cells()
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 28
                        radius: 8
                        color: modelData.today
                            ? Qt.rgba(Colors.base0D.r, Colors.base0D.g, Colors.base0D.b, 0.25)
                            : "transparent"
                        border.width: modelData.today ? 1 : 0
                        border.color: Colors.base0D

                        Text {
                            anchors.centerIn: parent
                            text: modelData.day
                            font.family: "CaskaydiaCove Nerd Font Mono"
                            font.pixelSize: 12
                            color: modelData.inMonth ? Colors.base05 : Colors.base03
                        }
                    }
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDate(new Date(), "dddd, dd MMMM yyyy")
                font.family: "CaskaydiaCove Nerd Font Mono"
                font.pixelSize: 11
                color: Colors.base04
            }
        }
    }
}
