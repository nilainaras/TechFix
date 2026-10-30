import QtQuick
import TechFix

// Bascule clair / sombre : le bouton glisse et l'icône (soleil / lune) change.
Item {
    id: root

    implicitWidth: 66
    implicitHeight: 36

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Theme.dark ? Theme.primarySoft : Theme.surfaceAlt
        border.width: 1
        border.color: Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durNormal } }
    }

    // icônes de fond
    Icon { name: "sun"; size: 15; color: Theme.textSubtle; x: 10; anchors.verticalCenter: parent.verticalCenter }
    Icon { name: "moon"; size: 15; color: Theme.textSubtle; x: parent.width - width - 10; anchors.verticalCenter: parent.verticalCenter }

    Rectangle {
        id: knob
        width: 28; height: 28; radius: 14
        y: 4
        x: Theme.dark ? parent.width - width - 4 : 4
        color: Theme.primary
        Behavior on x { NumberAnimation { duration: Theme.durSlow; easing.type: Easing.OutBack; easing.overshoot: 1.3 } }

        Icon {
            anchors.centerIn: parent
            name: Theme.dark ? "moon" : "sun"
            size: 15
            color: Theme.textOnPrimary
            rotation: Theme.dark ? 0 : 90
            Behavior on rotation { NumberAnimation { duration: Theme.durSlow; easing.type: Easing.OutCubic } }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Theme.dark = !Theme.dark
    }

    Tip { text: Theme.dark ? "Passer en mode clair" : "Passer en mode sombre"; visible: area.containsMouse }
}
