import QtQuick
import QtQuick.Effects
import TechFix

// Ombre douce et floue derrière un élément arrondi (fenêtres, panneaux, bulles).
// Désactivée automatiquement avec le rendu logiciel (pas de shaders disponibles).
Item {
    id: root

    property real radius: Theme.rLg
    property real blur: 1.0
    property real yOffset: 10
    property color color: Theme.shadow

    Loader {
        anchors.fill: parent
        active: GraphicsInfo.api !== GraphicsInfo.Software && GraphicsInfo.api !== GraphicsInfo.Null

        sourceComponent: Item {
            Rectangle {
                id: source
                anchors.fill: parent
                radius: root.radius
                color: "#000000"
                visible: false
            }
            MultiEffect {
                source: source
                anchors.fill: source
                shadowEnabled: true
                shadowColor: root.color
                shadowBlur: root.blur
                shadowVerticalOffset: root.yOffset
                shadowOpacity: 1
                autoPaddingEnabled: true
            }
        }
    }
}
