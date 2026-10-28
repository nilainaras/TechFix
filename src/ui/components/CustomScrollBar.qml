import QtQuick
import QtQuick.Controls

ScrollBar {
    id: control

    property bool isDarkMode: true

    implicitWidth: 10
    implicitHeight: 10

    policy: ScrollBar.AsNeeded

    contentItem: Rectangle {
        implicitWidth: 8
        implicitHeight: 8

        radius: width / 2
        color: control.pressed
            ? (isDarkMode ? "#00d4ff" : "#0066ff")
            : (isDarkMode ? "#334155" : "#cbd5e1")

        opacity: control.active ? 1.0 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}