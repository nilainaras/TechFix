import QtQuick
import QtQuick.Shapes
import TechFix

// Icône vectorielle (bibliothèque Lucide, voir theme/Icons.qml).
// Se colore avec `color`, se redimensionne avec `size`, sans aucune image.
//     Icon { name: "wrench"; size: 20; color: Theme.primary }
Item {
    id: root

    property string name: ""
    property real size: 20
    property color color: Theme.text
    property real weight: 1.9          // épaisseur du trait (grille de 24 unités)

    implicitWidth: size
    implicitHeight: size
    width: size
    height: size

    Shape {
        anchors.fill: parent
        ShapePath {
            strokeColor: root.color
            strokeWidth: root.weight * root.size / 24
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            scale: Qt.size(root.size / 24, root.size / 24)
            PathSvg { path: Icons.paths[root.name] || "" }
        }
    }
}
