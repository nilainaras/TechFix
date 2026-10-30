import QtQuick
import QtQuick.Layouts
import TechFix

// Carte : surface arrondie avec bordure fine. Le contenu est disposé en colonne.
//   clickable  → la carte réagit au survol (elle se soulève) et émet clicked()
//   appearDelay→ animation d'entrée (fondu + glissement) quand la page vient de s'ouvrir
Rectangle {
    id: root

    default property alias content: inner.data
    property real padding: 20
    property real spacing: 12
    property bool clickable: false
    property int appearDelay: -1            // en ms ; -1 = pas d'animation
    property color fill: Theme.surface
    signal clicked()

    readonly property bool hovered: hover.hovered
    property real lifted: clickable && hovered ? -3 : 0
    property real enterShift: 0
    Behavior on lifted { NumberAnimation { duration: 170; easing.type: Easing.OutCubic } }

    Layout.fillWidth: true
    implicitHeight: inner.implicitHeight + padding * 2
    radius: Theme.rLg
    color: fill
    border.width: 1
    border.color: clickable && hovered ? Theme.borderStrong : Theme.border
    Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

    transform: [
        Translate { y: root.lifted },
        Translate { y: root.enterShift }
    ]

    // ombre légère sous la carte survolée
    Rectangle {
        z: -1
        anchors.fill: parent
        anchors.topMargin: 6
        radius: root.radius
        color: Theme.shadow
        opacity: root.clickable && root.hovered ? 0.35 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        visible: opacity > 0.01
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.clickable
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    HoverHandler { id: hover }

    ColumnLayout {
        id: inner
        x: root.padding
        y: root.padding
        width: root.width - root.padding * 2
        spacing: root.spacing
    }

    SequentialAnimation {
        id: enterAnim
        PauseAnimation { duration: Math.max(0, root.appearDelay) }
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 1; duration: Theme.durSlow; easing.type: Easing.OutCubic }
            NumberAnimation { target: root; property: "enterShift"; to: 0; duration: Theme.durSlow + 80; easing.type: Easing.OutCubic }
        }
    }

    Component.onCompleted: {
        if (appearDelay >= 0 && Theme.animations && UI.justEntered()) {
            opacity = 0
            enterShift = 18
            enterAnim.start()
        }
    }
}
