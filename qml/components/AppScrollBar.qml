import QtQuick
import QtQuick.Controls
import TechFix

// Barre de défilement fine qui se fait discrète.
ScrollBar {
    id: control

    padding: 3
    implicitWidth: 12

    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 40
        radius: 3
        color: control.pressed ? Theme.textSubtle : Theme.borderStrong
        opacity: control.active || control.hovered ? 0.95 : 0.0
        Behavior on opacity { NumberAnimation { duration: 220 } }
    }
    background: Item {}
}
