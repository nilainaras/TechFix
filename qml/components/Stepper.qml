import QtQuick
import TechFix

// Frise des étapes d'une réparation : Reçu → Diagnostic → En réparation → Terminé → Livré.
// Une piste relie les étapes, comme une piste de circuit imprimé ; la partie parcourue se remplit
// en dégradé et l'étape courante « respire ».
//   interactive → un clic sur une étape émet stepClicked(index) (la règle métier décide si c'est permis)
Item {
    id: root

    property int status: 0
    property var timeline: []
    property bool interactive: false
    signal stepClicked(int index)

    readonly property real cell: width / 5
    readonly property real nodeSize: 44

    implicitHeight: nodeSize + 62

    function dateOf(step) {
        for (var i = 0; i < timeline.length; i++)
            if (timeline[i].statut === step) return timeline[i].date
        return null
    }

    // piste de fond
    Rectangle {
        id: track
        x: root.cell / 2
        y: root.nodeSize / 2 - 2
        width: root.cell * 4
        height: 4
        radius: 2
        color: Theme.border
    }

    // partie parcourue
    Rectangle {
        x: track.x
        y: track.y
        height: 4
        radius: 2
        width: root.cell * root.status
        Behavior on width { NumberAnimation { duration: Theme.durSlow + 200; easing.type: Easing.OutCubic } }
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: Theme.statusColor(0) }
            GradientStop { position: 1; color: Theme.statusColor(root.status) }
        }
    }

    Repeater {
        model: 5

        delegate: Item {
            id: step
            required property int index
            readonly property bool done: index < root.status
            readonly property bool current: index === root.status
            readonly property color tone: Theme.statusColor(index)
            readonly property var when: root.dateOf(index)

            x: index * root.cell
            width: root.cell
            height: root.height

            // halo qui respire autour de l'étape courante
            Rectangle {
                id: halo
                visible: step.current && root.status < 4
                width: root.nodeSize
                height: width
                radius: width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                border.width: 2
                border.color: step.tone
                opacity: 0

                SequentialAnimation on scale {
                    running: halo.visible && Theme.animations
                    loops: Animation.Infinite
                    NumberAnimation { from: 1; to: 1.55; duration: 1500; easing.type: Easing.OutCubic }
                    PauseAnimation { duration: 400 }
                }
                SequentialAnimation on opacity {
                    running: halo.visible && Theme.animations
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.7; to: 0; duration: 1500; easing.type: Easing.OutCubic }
                    PauseAnimation { duration: 400 }
                }
            }

            // pastille de l'étape
            Rectangle {
                id: node
                width: root.nodeSize
                height: width
                radius: width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: (step.done || step.current) ? step.tone : Theme.surface
                border.width: (step.done || step.current) ? 0 : 2
                border.color: nodeArea.containsMouse && root.interactive ? Theme.textSubtle : Theme.borderStrong
                scale: step.current ? 1.08 : (nodeArea.containsMouse && root.interactive ? 1.06 : 1)
                Behavior on color { ColorAnimation { duration: Theme.durNormal } }
                Behavior on scale { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutBack } }

                Icon {
                    anchors.centerIn: parent
                    name: step.done ? "check" : Theme.statusIcons[step.index]
                    size: step.done ? 22 : 21
                    weight: step.done ? 2.6 : 2
                    color: (step.done || step.current) ? Theme.textOnPrimary : Theme.textSubtle
                }

                MouseArea {
                    id: nodeArea
                    anchors.fill: parent
                    enabled: root.interactive
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.stepClicked(step.index)
                }
            }

            Column {
                anchors.top: node.bottom
                anchors.topMargin: 12
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 8
                spacing: 2

                Txt {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: Theme.statusLabels[step.index]
                    elide: Text.ElideRight
                    font.pixelSize: Theme.fsBase
                    font.weight: step.current ? Font.Bold : Font.Medium
                    color: step.current ? step.tone : (step.done ? Theme.text : Theme.textSubtle)
                }
                Txt {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: step.when ? Fmt.dateTime(step.when) : (step.current ? "En cours" : "À venir")
                    elide: Text.ElideRight
                    variant: "caption"
                }
            }
        }
    }
}
