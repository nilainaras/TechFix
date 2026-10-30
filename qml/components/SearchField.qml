import QtQuick
import TechFix

// Champ de recherche avec loupe et bouton d'effacement.
Item {
    id: root

    property alias text: input.text
    property alias input: input
    property string placeholder: "Rechercher…"
    signal accepted()

    function forceFocus() { input.forceActiveFocus(); input.selectAll() }

    implicitHeight: 42
    implicitWidth: 280

    Rectangle {
        anchors.fill: parent
        radius: Theme.rMd
        color: Theme.surface
        border.width: input.activeFocus ? 2 : 1
        border.color: input.activeFocus ? Theme.primary : (hover.hovered ? Theme.borderStrong : Theme.border)
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }
    }
    HoverHandler { id: hover }

    Icon {
        id: lens
        name: "search"
        size: 18
        color: input.activeFocus ? Theme.primary : Theme.textSubtle
        anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
    }

    TextInput {
        id: input
        anchors { left: lens.right; leftMargin: 10; right: clearBtn.left; rightMargin: 6; verticalCenter: parent.verticalCenter }
        color: Theme.text
        selectionColor: Theme.primary
        selectedTextColor: Theme.textOnPrimary
        font.family: Theme.fontBody
        font.pixelSize: Theme.fsBase
        clip: true
        selectByMouse: true
        onAccepted: root.accepted()

        Text {
            visible: input.text.length === 0 && input.preeditText.length === 0
            text: root.placeholder
            color: Theme.textSubtle
            font: input.font
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Item {
        id: clearBtn
        width: input.text.length > 0 ? 34 : 10
        height: parent.height
        anchors.right: parent.right

        Rectangle {
            visible: input.text.length > 0
            anchors.centerIn: parent
            width: 22; height: 22; radius: 11
            color: clearArea.containsMouse ? Theme.borderStrong : Theme.surfaceAlt
            Icon { anchors.centerIn: parent; name: "x"; size: 12; color: Theme.textMuted }
        }
        MouseArea {
            id: clearArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: input.text.length > 0
            cursorShape: Qt.PointingHandCursor
            onClicked: { input.text = ""; input.forceActiveFocus() }
        }
    }
}
