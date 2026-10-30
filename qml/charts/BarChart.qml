import QtQuick
import TechFix
import "ChartUtils.js" as CU

// Histogramme vertical animé (barres qui poussent, survol avec info-bulle).
//   labels : ["mai", …]   values : [350000, …]   highlightLast : met en avant la dernière barre
Item {
    id: root

    property var labels: []
    property var values: []
    property color color: Theme.primary
    property bool highlightLast: true
    property string unit: ""
    property int ticks: 4
    property var axisFormat: function (v) { return Fmt.compact(v) }
    property var valueFormat: function (v) { return Fmt.ar(v) }
    property int hoverIndex: -1

    readonly property real padL: 46
    readonly property real padR: 8
    readonly property real padT: 12
    readonly property real padB: 30
    readonly property real plotW: Math.max(10, width - padL - padR)
    readonly property real plotH: Math.max(10, height - padT - padB)
    readonly property real slot: values.length > 0 ? plotW / values.length : plotW
    readonly property var axis: CU.niceScale(CU.maxOf(values), ticks)

    implicitHeight: 260

    // grille
    Repeater {
        model: root.ticks + 1
        delegate: Item {
            required property int index
            readonly property real yy: root.padT + root.plotH - index * root.plotH / root.ticks
            Rectangle {
                x: root.padL; y: parent.yy
                width: root.plotW; height: 1
                color: index === 0 ? Theme.borderStrong : Theme.border
                opacity: index === 0 ? 1 : 0.7
            }
            Txt {
                x: 0; y: parent.yy - height / 2
                width: root.padL - 10
                horizontalAlignment: Text.AlignRight
                text: root.axisFormat(index * root.axis.step)
                variant: "caption"
            }
        }
    }

    // barres
    Repeater {
        model: root.values.length
        delegate: Item {
            id: col
            required property int index
            readonly property real v: root.values[index] || 0
            readonly property bool active: index === root.hoverIndex
            readonly property bool emphasised: !root.highlightLast || index === root.values.length - 1
            property real grow: 0
            property real shown: v
            Behavior on shown { NumberAnimation { duration: Theme.durSlow; easing.type: Easing.OutCubic } }

            x: root.padL + index * root.slot
            y: root.padT
            width: root.slot
            height: root.plotH

            SequentialAnimation {
                running: true
                PauseAnimation { duration: Theme.animations ? col.index * 70 : 0 }
                NumberAnimation { target: col; property: "grow"; to: 1; duration: Theme.durChart * 0.75; easing.type: Easing.OutCubic }
            }

            Rectangle {
                id: bar
                width: Math.min(40, root.slot * 0.56)
                height: Math.max(col.v > 0 ? 4 : 0, root.plotH * (col.shown / root.axis.max) * col.grow)
                x: (parent.width - width) / 2
                y: parent.height - height
                radius: Math.min(8, width / 2)
                color: root.color
                opacity: col.active ? 1 : (col.emphasised ? 0.95 : 0.5)
                Behavior on opacity { NumberAnimation { duration: 140 } }
            }

            Txt {
                x: (parent.width - width) / 2
                y: parent.height + 8
                text: root.labels[index] || ""
                variant: "caption"
                font.weight: col.active ? Font.DemiBold : Font.Normal
                color: col.active ? Theme.text : Theme.textSubtle
            }
        }
    }

    // info-bulle
    Rectangle {
        visible: root.hoverIndex >= 0 && root.hoverIndex < root.values.length
        width: tipCol.implicitWidth + 24
        height: tipCol.implicitHeight + 18
        radius: Theme.rMd
        color: Theme.surface
        border.width: 1
        border.color: Theme.borderStrong
        readonly property real v: root.hoverIndex >= 0 ? (root.values[root.hoverIndex] || 0) : 0
        x: Math.max(0, Math.min(root.width - width, root.padL + (root.hoverIndex + 0.5) * root.slot - width / 2))
        y: Math.max(0, root.padT + root.plotH * (1 - v / root.axis.max) - height - 10)

        Column {
            id: tipCol
            anchors.centerIn: parent
            spacing: 2
            Txt { text: root.hoverIndex >= 0 ? (root.labels[root.hoverIndex] || "") : ""; variant: "caption" }
            Txt {
                text: root.hoverIndex >= 0 ? root.valueFormat(root.values[root.hoverIndex] || 0) + (root.unit !== "" ? " " + root.unit : "") : ""
                variant: "strong"
                font.pixelSize: Theme.fsMd
            }
        }
    }

    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onPointChanged: {
            if (!hovered || root.values.length === 0) { root.hoverIndex = -1; return }
            var i = Math.floor((point.position.x - root.padL) / root.slot)
            root.hoverIndex = (i >= 0 && i < root.values.length) ? i : -1
        }
        onHoveredChanged: if (!hovered) root.hoverIndex = -1
    }
}
