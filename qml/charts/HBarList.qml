import QtQuick
import QtQuick.Layouts
import TechFix
import "ChartUtils.js" as CU

// Classement en barres horizontales.  items : [{ label, value, sub?, color? }]
ColumnLayout {
    id: root

    property var items: []
    property color color: Theme.primary
    property var valueFormat: function (v) { return String(v) }
    property bool showRank: false
    readonly property real maxValue: Math.max(1, CU.maxOf(items.map(function (i) { return i.value })))

    Layout.fillWidth: true
    spacing: 14

    Repeater {
        model: root.items

        delegate: ColumnLayout {
            id: row
            required property var modelData
            required property int index
            property real grow: 0

            Layout.fillWidth: true
            spacing: 7

            SequentialAnimation {
                running: true
                PauseAnimation { duration: Theme.animations ? row.index * 80 : 0 }
                NumberAnimation { target: row; property: "grow"; to: 1; duration: Theme.durChart * 0.8; easing.type: Easing.OutCubic }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                Txt {
                    visible: root.showRank
                    text: String(row.index + 1)
                    variant: "caption"
                    Layout.preferredWidth: 14
                }
                Txt {
                    text: row.modelData.label
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    font.pixelSize: Theme.fsMd
                    font.weight: Font.Medium
                }
                Txt {
                    visible: !!row.modelData.sub
                    text: row.modelData.sub || ""
                    variant: "caption"
                }
                Txt {
                    text: root.valueFormat(row.modelData.value)
                    font.pixelSize: Theme.fsMd
                    font.weight: Font.DemiBold
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: Theme.surfaceAlt
                Rectangle {
                    height: parent.height
                    radius: 4
                    width: Math.max(row.modelData.value > 0 ? 8 : 0, parent.width * (row.modelData.value / root.maxValue) * row.grow)
                    color: row.modelData.color !== undefined ? row.modelData.color : root.color
                }
            }
        }
    }
}
