import QtQuick
import QtQuick.Shapes
import TechFix

// Logo TechFix : une puce électronique + une clé à molette sur un dégradé bleu → vert.
// Dessiné en vectoriel (même tracé que assets/logo/techfix-logo.svg).
Item {
    id: root

    property real size: 40
    readonly property real k: size / 64     // le logo est dessiné sur une grille de 64

    width: size
    height: size

    Shape {
        anchors.fill: parent

        // fond arrondi en dégradé
        ShapePath {
            strokeColor: "transparent"
            fillGradient: LinearGradient {
                x1: 0; y1: 0; x2: root.size; y2: root.size
                GradientStop { position: 0; color: Theme.brandA }
                GradientStop { position: 1; color: Theme.brandB }
            }
            scale: Qt.size(root.k, root.k)
            PathSvg { path: "M16 0 H48 A16 16 0 0 1 64 16 V48 A16 16 0 0 1 48 64 H16 A16 16 0 0 1 0 48 V16 A16 16 0 0 1 16 0 Z" }
        }

        // puce + broches
        ShapePath {
            strokeColor: "#F3F7FF"
            strokeWidth: 3 * root.k
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            scale: Qt.size(root.k, root.k)
            PathSvg { path: "M24 17 H40 A7 7 0 0 1 47 24 V40 A7 7 0 0 1 40 47 H24 A7 7 0 0 1 17 40 V24 A7 7 0 0 1 24 17 Z" }
            PathSvg { path: "M25 9 V17 M39 9 V17 M25 47 V55 M39 47 V55 M9 25 H17 M9 39 H17 M47 25 H55 M47 39 H55" }
        }
    }

    // clé à molette au centre de la puce
    Icon {
        name: "wrench"
        size: 19.2 * root.k
        x: 22.4 * root.k
        y: 22.4 * root.k
        color: "#F3F7FF"
        weight: 2.7
    }
}
