import QtQuick
import QtQuick.Shapes
import TechFix
import "ChartUtils.js" as CU

// Courbe avec remplissage dégradé, axes, grille et info-bulle au survol.
//   labels : ["mai", "juin", …]   values : [12, 18, …]
Item {
    id: root

    property var labels: []
    property var values: []
    property color color: Theme.primary
    property string unit: ""                       // « réparations » dans l'info-bulle
    property var valueFormat: function (v) { return String(Math.round(v)) }
    property int ticks: 4
    property real progress: 0
    property int hoverIndex: -1

    readonly property real padL: 38
    readonly property real padR: 22
    readonly property real padT: 12
    readonly property real padB: 30
    readonly property real plotW: Math.max(10, width - padL - padR)
    readonly property real plotH: Math.max(10, height - padT - padB)
    readonly property var axis: CU.niceScale(CU.maxOf(values), ticks)

    readonly property var pts: {
        var n = values.length
        var out = []
        for (var i = 0; i < n; i++)
            out.push({ x: n > 1 ? i * plotW / (n - 1) : plotW / 2, y: plotH - (values[i] / axis.max) * plotH })
        return out
    }

    implicitHeight: 260

    onValuesChanged: anim.restart()
    Component.onCompleted: anim.start()

    NumberAnimation {
        id: anim
        target: root
        property: "progress"
        from: 0
        to: 1
        duration: Theme.durChart
        easing.type: Easing.OutCubic
    }

    // ── grille et axe vertical ──────────────────────────────────────────────
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
                text: root.valueFormat(index * root.axis.step)
                variant: "caption"
            }
        }
    }

    // ── axe horizontal ──────────────────────────────────────────────────────
    Repeater {
        model: root.labels
        delegate: Txt {
            required property string modelData
            required property int index
            x: root.padL + (root.pts[index] ? root.pts[index].x : 0) - width / 2
            y: root.padT + root.plotH + 8
            text: modelData
            variant: "caption"
            font.weight: index === root.hoverIndex ? Font.DemiBold : Font.Normal
            color: index === root.hoverIndex ? Theme.text : Theme.textSubtle
        }
    }

    // ── courbe ──────────────────────────────────────────────────────────────
    Item {
        x: root.padL
        y: root.padT
        width: root.plotW * root.progress
        height: root.plotH + 4
        clip: true

        Shape {
            width: root.plotW
            height: root.plotH + 4

            ShapePath {
                strokeColor: "transparent"
                fillGradient: LinearGradient {
                    x1: 0; y1: 0; x2: 0; y2: root.plotH
                    GradientStop { position: 0; color: Theme.tint(root.color, 0.34) }
                    GradientStop { position: 1; color: Theme.tint(root.color, 0.0) }
                }
                PathSvg { path: CU.areaPath(root.pts, root.plotH) }
            }
            ShapePath {
                strokeColor: root.color
                strokeWidth: 3
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                PathSvg { path: CU.smoothPath(root.pts) }
            }
        }
    }

    // ── repère vertical + points ────────────────────────────────────────────
    Rectangle {
        visible: root.hoverIndex >= 0
        x: root.padL + (root.pts[root.hoverIndex] ? root.pts[root.hoverIndex].x : 0)
        y: root.padT
        width: 1
        height: root.plotH
        color: root.color
        opacity: 0.45
    }

    Repeater {
        model: root.pts
        delegate: Rectangle {
            required property var modelData
            required property int index
            readonly property bool active: index === root.hoverIndex
            x: root.padL + modelData.x - width / 2
            y: root.padT + modelData.y - height / 2
            width: active ? 14 : 9
            height: width
            radius: width / 2
            color: Theme.surface
            border.width: active ? 3.5 : 2.5
            border.color: root.color
            opacity: root.progress > (modelData.x / Math.max(1, root.plotW)) ? 1 : 0
            Behavior on width { NumberAnimation { duration: 120 } }
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
    }

    // ── info-bulle ──────────────────────────────────────────────────────────
    Rectangle {
        id: tip
        visible: root.hoverIndex >= 0 && root.pts[root.hoverIndex] !== undefined
        readonly property var p: root.pts[root.hoverIndex] || { x: 0, y: 0 }
        width: tipCol.implicitWidth + 24
        height: tipCol.implicitHeight + 18
        radius: Theme.rMd
        color: Theme.surface
        border.width: 1
        border.color: Theme.borderStrong
        x: Math.max(0, Math.min(root.width - width, root.padL + p.x - width / 2))
        y: Math.max(0, root.padT + p.y - height - 16)

        Column {
            id: tipCol
            anchors.centerIn: parent
            spacing: 2
            Txt { text: root.hoverIndex >= 0 ? root.labels[root.hoverIndex] : ""; variant: "caption" }
            Txt {
                text: root.hoverIndex >= 0 ? root.valueFormat(root.values[root.hoverIndex]) + (root.unit !== "" ? " " + root.unit : "") : ""
                variant: "strong"
                font.pixelSize: Theme.fsMd
            }
        }
    }

    HoverHandler {
        id: hover
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onPointChanged: {
            if (!hovered || root.values.length === 0) { root.hoverIndex = -1; return }
            var x = point.position.x - root.padL
            var n = root.values.length
            root.hoverIndex = n > 1 ? Math.max(0, Math.min(n - 1, Math.round(x / root.plotW * (n - 1)))) : 0
        }
        onHoveredChanged: if (!hovered) root.hoverIndex = -1
    }
}
