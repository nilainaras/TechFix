import QtQuick
import QtQuick.Shapes
import TechFix
import "ChartUtils.js" as CU

// Mini-courbe sans axes (tendance), qui se dessine de gauche à droite à l'ouverture.
Item {
    id: root

    property var values: []
    property color color: Theme.primary
    property real progress: 0

    implicitWidth: 110
    implicitHeight: 40

    readonly property real padTop: 4
    readonly property real padBottom: 4
    readonly property var pts: {
        var n = values.length
        var out = []
        if (n < 2) return out
        var m = Math.max(CU.maxOf(values), 1)
        var h = height - padTop - padBottom
        for (var i = 0; i < n; i++)
            out.push({ x: 2 + i * (width - 4) / (n - 1), y: padTop + h - (values[i] / m) * h })
        return out
    }

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

    Item {
        width: root.width * root.progress
        height: root.height
        clip: true

        Shape {
            width: root.width
            height: root.height

            ShapePath {
                strokeColor: "transparent"
                fillGradient: LinearGradient {
                    x1: 0; y1: 0; x2: 0; y2: root.height
                    GradientStop { position: 0; color: Theme.tint(root.color, 0.32) }
                    GradientStop { position: 1; color: Theme.tint(root.color, 0.0) }
                }
                PathSvg { path: CU.areaPath(root.pts, root.height) }
            }
            ShapePath {
                strokeColor: root.color
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                PathSvg { path: CU.smoothPath(root.pts) }
            }
        }
    }
}
