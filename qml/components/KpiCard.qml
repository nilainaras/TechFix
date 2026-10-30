import QtQuick
import QtQuick.Layouts
import TechFix

// Carte « chiffre clé » du tableau de bord : valeur animée, tendance et mini-courbe.
//   tone : primary | success | danger | warning | violet | slate
Card {
    id: root

    property string icon: "activity"
    property string tone: "primary"
    property string title: ""
    property real value: 0
    property var format: function (v) { return String(Math.round(v)) }
    property string caption: ""
    property var spark: []
    property real delta: NaN                    // variation en %, NaN = pas de tendance
    property string deltaCaption: "vs mois dernier"
    readonly property color toneColor: Theme[tone]

    padding: 20
    spacing: 14

    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        Rectangle {
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            radius: Theme.rMd
            color: Theme.tint(root.toneColor)
            Icon { anchors.centerIn: parent; name: root.icon; size: 22; color: root.toneColor }
        }
        Item { Layout.fillWidth: true }
        Sparkline {
            visible: root.spark.length > 1
            values: root.spark
            color: root.toneColor
            Layout.preferredWidth: 100
            Layout.preferredHeight: 38
        }
    }

    Txt { text: root.title; variant: "muted"; Layout.fillWidth: true; elide: Text.ElideRight; font.weight: Font.Medium; Layout.bottomMargin: -8 }

    CountText {
        value: root.value
        format: root.format
        variant: "display"
        font.pixelSize: Theme.fs3xl - 2
        Layout.fillWidth: true
        elide: Text.ElideRight
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Tag {
            visible: !isNaN(root.delta)
            small: true
            tone: root.delta >= 0 ? "success" : "danger"
            icon: root.delta >= 0 ? "trending-up" : "trending-down"
            text: (root.delta >= 0 ? "+" : "") + Math.round(root.delta) + " %"
        }
        Txt {
            text: !isNaN(root.delta) ? root.deltaCaption : root.caption
            variant: "caption"
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }
}
