import QtQuick
import TechFix

// Petite pastille d'information.
//   tone : "" (neutre) | primary | success | danger | warning | violet | slate
//   ou bien fournir directement fg / bg.
Rectangle {
    id: root

    property string text: ""
    property string icon: ""
    property string tone: ""
    property bool dot: false
    property bool small: false
    property color fg: tone === "" ? Theme.textMuted : Theme[tone]
    property color bg: tone === "" ? Theme.surfaceAlt : Theme[tone + "Soft"]

    implicitHeight: small ? 22 : 26
    implicitWidth: row.implicitWidth + (small ? 16 : 20)
    radius: height / 2
    color: bg

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Rectangle {
            visible: root.dot
            width: 7; height: 7; radius: 4
            color: root.fg
            anchors.verticalCenter: parent.verticalCenter
        }
        Icon {
            visible: root.icon !== ""
            name: root.icon
            size: root.small ? 12 : 14
            color: root.fg
            anchors.verticalCenter: parent.verticalCenter
        }
        Txt {
            text: root.text
            color: root.fg
            font.pixelSize: root.small ? Theme.fsXs : Theme.fsSm
            font.weight: Font.DemiBold
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
