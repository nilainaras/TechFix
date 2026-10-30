import QtQuick
import QtQuick.Layouts
import TechFix

// Ligne « icône · libellé · valeur » pour les fiches de détail.
RowLayout {
    id: root

    property string icon: ""
    property string label: ""
    property string value: ""
    property color tone: Theme.textSubtle

    Layout.fillWidth: true
    spacing: 12

    Icon { visible: root.icon !== ""; name: root.icon; size: 17; color: root.tone }
    Txt { text: root.label; variant: "muted"; font.pixelSize: Theme.fsMd; Layout.preferredWidth: 104 }
    Txt {
        text: root.value
        variant: "strong"
        font.pixelSize: Theme.fsMd
        Layout.fillWidth: true
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
    }
}
