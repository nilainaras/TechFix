import QtQuick
import QtQuick.Controls

ScrollBar {
    id: control

    orientation: Qt.Vertical
    policy: ScrollBar.AsNeeded

    implicitWidth: orientation === Qt.Vertical ? 10 : 0
    implicitHeight: orientation === Qt.Horizontal ? 10 : 0

    background: Rectangle {
        radius: 5
        implicitWidth: 5
        color: "#172554"
        opacity: 0.7
    }

    contentItem: Rectangle {
        radius: 5
        color: control.pressed ? "#00E5FF"
             : control.hovered ? "#38BDF8"
             : "#38BDF8"
        implicitWidth: 6
        implicitHeight: 30
    }
}