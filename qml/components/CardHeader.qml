import QtQuick
import QtQuick.Layouts
import TechFix

// En-tête d'une carte : pastille d'icône, titre, sous-titre et zone d'actions à droite.
RowLayout {
    id: root

    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property color tone: Theme.primary
    default property alias actions: actionsRow.data

    Layout.fillWidth: true
    spacing: 12

    Rectangle {
        visible: root.icon !== ""
        Layout.preferredWidth: 38
        Layout.preferredHeight: 38
        radius: Theme.rMd
        color: Theme.tint(root.tone)
        Icon { anchors.centerIn: parent; name: root.icon; size: 19; color: root.tone }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 1
        Txt { text: root.title; variant: "h3"; Layout.fillWidth: true; elide: Text.ElideRight }
        Txt {
            visible: root.subtitle !== ""
            text: root.subtitle
            variant: "caption"
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }

    Row {
        id: actionsRow
        spacing: 6
    }
}
