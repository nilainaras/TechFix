import QtQuick
import TechFix

// Bouton carré avec une icône seule (et une info-bulle).
//   variant : ghost | soft | danger | surface
Item {
    id: root

    property string icon: ""
    property string tip: ""
    property string variant: "ghost"
    property real size: 38
    property real iconSize: 19
    property bool dot: false            // petit point de notification
    property bool active: false
    signal clicked()

    width: size
    height: size
    opacity: enabled ? 1 : 0.4
    scale: area.pressed ? 0.92 : 1
    Behavior on scale { NumberAnimation { duration: 90 } }

    readonly property color fg: variant === "danger" ? Theme.danger
                              : (variant === "soft" || active) ? Theme.primary
                              : Theme.textMuted

    Rectangle {
        anchors.fill: parent
        radius: Theme.rMd
        color: {
            if (root.variant === "danger")
                return area.containsMouse ? Theme.dangerSoft : "transparent"
            if (root.variant === "soft" || root.active)
                return Theme.primarySoft
            if (root.variant === "surface")
                return area.containsMouse ? Theme.surfaceHover : Theme.surface
            return area.containsMouse ? Theme.surfaceHover : "transparent"
        }
        border.width: root.variant === "surface" ? 1 : 0
        border.color: Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }

    Icon {
        anchors.centerIn: parent
        name: root.icon
        size: root.iconSize
        color: area.containsMouse && root.variant !== "danger" && !root.active ? Theme.text : root.fg
    }

    Rectangle {
        visible: root.dot
        width: 9; height: 9; radius: 5
        color: Theme.danger
        border.width: 2
        border.color: Theme.surface
        anchors { top: parent.top; right: parent.right; topMargin: 7; rightMargin: 7 }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    Tip { text: root.tip; visible: area.containsMouse && root.tip !== "" }
}
