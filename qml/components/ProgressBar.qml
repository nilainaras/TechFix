import QtQuick
import TechFix

// Barre de progression animée (value entre 0 et 1).
Rectangle {
    id: root

    property real value: 0
    property color fill: Theme.primary
    property real thickness: 8

    implicitHeight: thickness
    implicitWidth: 120
    radius: height / 2
    color: Theme.surfaceAlt

    Rectangle {
        height: parent.height
        radius: height / 2
        color: root.fill
        width: Math.max(root.value > 0 ? height : 0, parent.width * Math.min(1, Math.max(0, root.value)))
        Behavior on width { NumberAnimation { duration: Theme.durSlow; easing.type: Easing.OutCubic } }
    }
}
