import QtQuick
import QtQuick.Layouts
import TechFix

// Ligne de réglage : titre + description à gauche, contrôle (interrupteur, bouton…) à droite.
RowLayout {
    id: root

    property string title: ""
    property string description: ""
    property string icon: ""
    default property alias control: controlRow.data

    Layout.fillWidth: true
    spacing: 14

    Rectangle {
        visible: root.icon !== ""
        Layout.preferredWidth: 40
        Layout.preferredHeight: 40
        radius: Theme.rMd
        color: Theme.primarySoft
        Icon { anchors.centerIn: parent; name: root.icon; size: 20; color: Theme.primary }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Txt { text: root.title; variant: "strong"; Layout.fillWidth: true; elide: Text.ElideRight }
        Txt {
            visible: root.description !== ""
            text: root.description
            variant: "caption"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }

    Row {
        id: controlRow
        spacing: 8
        Layout.alignment: Qt.AlignVCenter
    }
}
