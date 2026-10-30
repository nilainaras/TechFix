import QtQuick
import TechFix

// Rangée de filtres « pastilles » avec compteur.  model : [{ label, value, count }]
Flow {
    id: root

    property var model: []
    property var current: ""
    signal selected(var value)

    spacing: 8

    Repeater {
        model: root.model

        delegate: Rectangle {
            id: chip
            required property var modelData
            readonly property bool active: modelData.value === root.current

            height: 34
            width: label.implicitWidth + (count.visible ? count.width + 8 : 0) + 28
            radius: height / 2
            color: active ? Theme.primary : (area.containsMouse ? Theme.surfaceHover : Theme.surface)
            border.width: active ? 0 : 1
            border.color: Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durFast } }

            Txt {
                id: label
                x: 14
                anchors.verticalCenter: parent.verticalCenter
                text: chip.modelData.label
                font.pixelSize: Theme.fsMd
                font.weight: Font.Medium
                color: chip.active ? Theme.textOnPrimary : Theme.textMuted
            }
            Rectangle {
                id: count
                visible: chip.modelData.count !== undefined
                x: label.x + label.implicitWidth + 8
                anchors.verticalCenter: parent.verticalCenter
                width: Math.max(22, countText.implicitWidth + 10)
                height: 20
                radius: 10
                color: chip.active ? Qt.rgba(1, 1, 1, 0.22) : Theme.surfaceAlt
                Txt {
                    id: countText
                    anchors.centerIn: parent
                    text: chip.modelData.count === undefined ? "" : chip.modelData.count
                    font.pixelSize: Theme.fsXs
                    font.weight: Font.DemiBold
                    color: chip.active ? Theme.textOnPrimary : Theme.textMuted
                }
            }

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.selected(chip.modelData.value)
            }
        }
    }
}
