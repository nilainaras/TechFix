import QtQuick
import TechFix

// Bouton principal de l'application.
//   variant : primary | secondary | soft | ghost | danger | dangerSoft
Item {
    id: root

    property string text: ""
    property string icon: ""
    property string variant: "primary"
    property bool compact: false
    signal clicked()

    implicitHeight: compact ? 34 : 42
    implicitWidth: row.implicitWidth + (compact ? 26 : 34)
    opacity: enabled ? 1 : 0.45
    scale: area.pressed ? 0.97 : 1
    Behavior on scale { NumberAnimation { duration: 90; easing.type: Easing.OutCubic } }

    readonly property color fg: {
        switch (variant) {
        case "primary": return Theme.textOnPrimary
        case "danger": return Theme.textOnPrimary
        case "dangerSoft": return Theme.danger
        case "soft": return Theme.primary
        }
        return Theme.text
    }

    function shade(c) { return Theme.dark ? Qt.lighter(c, 1.14) : Qt.darker(c, 1.06) }

    readonly property color base: {
        switch (variant) {
        case "primary": return Theme.primary
        case "danger": return Theme.danger
        case "dangerSoft": return Theme.dangerSoft
        case "soft": return Theme.primarySoft
        case "secondary": return Theme.surface
        }
        return "transparent"
    }

    readonly property color hoverColor: {
        switch (variant) {
        case "primary": return Theme.primaryHover
        case "ghost": return Theme.surfaceHover
        case "secondary": return Theme.surfaceHover
        }
        return shade(base)
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.rMd
        color: area.containsMouse ? root.hoverColor : root.base
        border.width: root.variant === "secondary" ? 1 : 0
        border.color: Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8

        Icon {
            visible: root.icon !== ""
            name: root.icon
            size: root.compact ? 16 : 18
            color: root.fg
            anchors.verticalCenter: parent.verticalCenter
        }
        Txt {
            visible: root.text !== ""
            text: root.text
            variant: "strong"
            font.pixelSize: root.compact ? Theme.fsMd : Theme.fsBase
            color: root.fg
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
