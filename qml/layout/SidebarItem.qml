import QtQuick
import TechFix

// Entrée du menu latéral. En mode réduit, seule l'icône reste (avec une info-bulle).
Item {
    id: root

    property string icon: ""
    property string label: ""
    property bool active: false
    property bool rail: false
    property int badge: 0
    signal clicked()

    height: UI.lowHeight ? 38 : 46
    width: parent ? parent.width : 200

    // fond (survol / actif)
    Rectangle {
        anchors.fill: parent
        radius: Theme.rMd
        color: root.active ? Theme.sidebarActive : (area.containsMouse ? Theme.sidebarHover : "transparent")
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }

    // repère de l'entrée active
    Rectangle {
        width: 4
        height: root.active ? 22 : 0
        radius: 2
        color: Theme.sidebarAccent
        anchors { left: parent.left; leftMargin: -1; verticalCenter: parent.verticalCenter }
        Behavior on height { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutBack } }
    }

    Icon {
        id: ico
        name: root.icon
        size: 21
        color: root.active ? "#F1F5FF" : (area.containsMouse ? Theme.sidebarText : Theme.sidebarMuted)
        x: root.rail ? (parent.width - width) / 2 : 17
        anchors.verticalCenter: parent.verticalCenter
        Behavior on x { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
    }

    Txt {
        id: lbl
        visible: opacity > 0.01
        opacity: root.rail ? 0 : 1
        text: root.label
        anchors { left: parent.left; leftMargin: 52; right: pill.left; rightMargin: 8; verticalCenter: parent.verticalCenter }
        elide: Text.ElideRight
        font.pixelSize: Theme.fsBase
        font.weight: root.active ? Font.DemiBold : Font.Medium
        color: root.active ? "#F1F5FF" : Theme.sidebarText
        Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
    }

    Rectangle {
        id: pill
        visible: root.badge > 0
        width: Math.max(24, badgeText.implicitWidth + 12)
        height: 22
        radius: 11
        color: root.active ? Theme.sidebarAccent : Theme.sidebarBorder
        x: root.rail ? parent.width - width - 6 : parent.width - width - 12
        y: root.rail ? 4 : (parent.height - height) / 2
        scale: root.rail ? 0.8 : 1
        Behavior on x { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
        Behavior on y { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
        Txt {
            id: badgeText
            anchors.centerIn: parent
            text: root.badge
            font.pixelSize: Theme.fsXs
            font.weight: Font.Bold
            color: root.active ? "#0B1220" : Theme.sidebarText
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    Tip { text: root.label; side: "right"; visible: root.rail && area.containsMouse }
}
