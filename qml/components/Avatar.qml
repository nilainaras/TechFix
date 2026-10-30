import QtQuick
import TechFix

// Pastille avec les initiales d'une personne (couleur stable calculée depuis le nom).
Rectangle {
    id: root

    property string name: ""
    property real size: 40
    property bool square: false
    property string icon: ""          // si renseigné : icône au lieu des initiales

    readonly property real h: Fmt.hue(name) / 360

    width: size
    height: size
    radius: square ? size * 0.3 : size / 2
    color: Qt.hsla(h, 0.55, Theme.dark ? 0.26 : 0.87, 1)

    Txt {
        visible: root.icon === ""
        anchors.centerIn: parent
        text: Fmt.initials(root.name)
        font.pixelSize: root.size * 0.36
        font.weight: Font.Bold
        font.family: Theme.fontHeading
        color: Qt.hsla(root.h, 0.6, Theme.dark ? 0.76 : 0.32, 1)
    }
    Icon {
        visible: root.icon !== ""
        anchors.centerIn: parent
        name: root.icon
        size: root.size * 0.5
        color: Qt.hsla(root.h, 0.6, Theme.dark ? 0.76 : 0.32, 1)
    }
}
