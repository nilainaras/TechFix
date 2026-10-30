import QtQuick
import TechFix

// Cinq petits segments : la progression d'une réparation en un coup d'œil (miniature de la frise).
Row {
    id: root

    property int status: 0
    property real segmentSpacing: 4

    spacing: segmentSpacing

    Repeater {
        model: 5
        delegate: Rectangle {
            required property int index
            width: (root.width - root.segmentSpacing * 4) / 5
            height: 5
            radius: 2.5
            color: index <= root.status ? Theme.statusColor(root.status) : Theme.border
            opacity: index === root.status ? 1 : (index < root.status ? 0.55 : 1)
            Behavior on color { ColorAnimation { duration: Theme.durNormal } }
        }
    }
}
