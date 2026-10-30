import QtQuick
import QtQuick.Shapes
import TechFix

// Anneau de répartition. segments : [{ label, value, color }]
// Au survol d'un segment, le centre affiche son libellé et sa valeur.
Item {
    id: root

    property var segments: []
    property string centerCaption: "au total"
    property real thickness: 24
    property real progress: 0
    property int hoverIndex: -1

    readonly property real total: {
        var s = 0
        for (var i = 0; i < segments.length; i++) s += segments[i].value
        return s
    }
    readonly property real side: Math.min(width, height)
    readonly property real radius: (side - thickness) / 2 - 6
    readonly property real gap: 5                                   // degrés entre deux segments
    readonly property real capDeg: (thickness / 2) / Math.max(1, radius) * 180 / Math.PI

    // Début et amplitude de chaque arc, en degrés (0° = en haut, sens horaire).
    readonly property var arcs: {
        var out = []
        var acc = 0
        var nonZero = 0
        for (var k = 0; k < segments.length; k++) if (segments[k].value > 0) nonZero++
        for (var i = 0; i < segments.length; i++) {
            var sweep = total > 0 ? segments[i].value / total * 360 : 0
            var g = nonZero > 1 ? gap : 0
            var inset = nonZero > 1 ? capDeg * 0.75 : 0
            out.push({ start: acc, sweep: sweep, a0: acc + g / 2 + inset, a1: acc + sweep - g / 2 - inset })
            acc += sweep
        }
        return out
    }

    implicitWidth: 220
    implicitHeight: 220

    onSegmentsChanged: anim.restart()
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

    Item {
        id: stage
        anchors.centerIn: parent
        width: root.side
        height: root.side

        // piste
        Shape {
            anchors.fill: parent
            ShapePath {
                strokeColor: Theme.surfaceAlt
                strokeWidth: root.thickness
                fillColor: "transparent"
                PathAngleArc {
                    centerX: stage.width / 2; centerY: stage.height / 2
                    radiusX: root.radius; radiusY: root.radius
                    startAngle: 0; sweepAngle: 360
                }
            }
        }

        Repeater {
            model: root.segments.length
            delegate: Shape {
                id: seg
                required property int index
                readonly property var arc: root.arcs[index]
                readonly property real span: Math.max(0, arc.a1 - arc.a0)
                readonly property bool active: index === root.hoverIndex
                anchors.fill: parent
                visible: span > 0.2

                ShapePath {
                    strokeColor: root.segments[seg.index].color
                    strokeWidth: root.thickness + (seg.active ? 6 : 0)
                    fillColor: "transparent"
                    capStyle: root.arcs.length > 1 ? ShapePath.RoundCap : ShapePath.FlatCap
                    Behavior on strokeWidth { NumberAnimation { duration: 140 } }
                    PathAngleArc {
                        centerX: stage.width / 2; centerY: stage.height / 2
                        radiusX: root.radius; radiusY: root.radius
                        startAngle: -90 + seg.arc.a0
                        sweepAngle: seg.span * root.progress
                    }
                }
            }
        }
    }

    // texte central
    Column {
        anchors.centerIn: parent
        spacing: 0
        Txt {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.hoverIndex >= 0 ? String(root.segments[root.hoverIndex].value) : String(Math.round(root.total * root.progress))
            variant: "display"
            font.pixelSize: root.side * 0.2
        }
        Txt {
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.side - root.thickness * 2 - 24
            horizontalAlignment: Text.AlignHCenter
            text: root.hoverIndex >= 0 ? root.segments[root.hoverIndex].label : root.centerCaption
            variant: "muted"
            elide: Text.ElideRight
        }
    }

    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onPointChanged: {
            if (!hovered || root.total <= 0) { root.hoverIndex = -1; return }
            var dx = point.position.x - root.width / 2
            var dy = point.position.y - root.height / 2
            var dist = Math.sqrt(dx * dx + dy * dy)
            if (Math.abs(dist - root.radius) > root.thickness) { root.hoverIndex = -1; return }
            var deg = (Math.atan2(dy, dx) * 180 / Math.PI + 90 + 360) % 360
            var found = -1
            for (var i = 0; i < root.arcs.length; i++)
                if (root.segments[i].value > 0 && deg >= root.arcs[i].start && deg < root.arcs[i].start + root.arcs[i].sweep) { found = i; break }
            root.hoverIndex = found
        }
        onHoveredChanged: if (!hovered) root.hoverIndex = -1
    }
}
