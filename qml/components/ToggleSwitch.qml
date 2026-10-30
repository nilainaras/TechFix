import QtQuick
import TechFix

// Interrupteur on/off animé.
Item {
    id: root

    property bool checked: false
    signal toggled(bool value)

    implicitWidth: 46
    implicitHeight: 26
    opacity: enabled ? 1 : 0.45

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.checked ? Theme.primary : Theme.borderStrong
        Behavior on color { ColorAnimation { duration: Theme.durNormal } }
    }

    Rectangle {
        id: knob
        width: 20; height: 20; radius: 10
        y: 3
        x: root.checked ? parent.width - width - 3 : 3
        color: Theme.textOnPrimary
        Behavior on x { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutBack; easing.overshoot: 1.4 } }
        scale: area.pressed ? 1.1 : 1
        Behavior on scale { NumberAnimation { duration: 100 } }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
}
