import QtQuick
import TechFix

// Contrôle segmenté (ex. Grille | Liste, 3 mois | 6 mois | 12 mois).
//   options : [{ label, value, icon }]   — label ou icon (ou les deux)
Item {
    id: root

    property var options: []
    property var current: undefined
    property real itemPadding: 16
    signal selected(var value)

    property real thumbX: 4
    property real thumbW: 0

    readonly property int currentIndex: {
        for (var i = 0; i < options.length; i++)
            if (options[i].value === current) return i
        return 0
    }

    implicitHeight: 40
    implicitWidth: row.implicitWidth + 8

    function updateThumb() {
        var it = rep.itemAt(currentIndex)
        if (it) { thumbX = row.x + it.x; thumbW = it.width }
    }
    onCurrentIndexChanged: updateThumb()
    onWidthChanged: updateThumb()
    Component.onCompleted: updateThumb()

    Rectangle {
        anchors.fill: parent
        radius: Theme.rMd
        color: Theme.surfaceAlt
        border.width: 1
        border.color: Theme.border
    }

    Rectangle {
        id: thumb
        y: 4
        height: parent.height - 8
        x: root.thumbX
        width: root.thumbW
        radius: Theme.rSm
        color: Theme.surface
        border.width: 1
        border.color: Theme.border
        Behavior on x { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
    }

    Row {
        id: row
        x: 4
        y: 4
        height: parent.height - 8

        Repeater {
            id: rep
            model: root.options
            delegate: Item {
                id: seg
                required property var modelData
                required property int index
                readonly property bool active: index === root.currentIndex

                height: row.height
                width: inner.implicitWidth + root.itemPadding * 2
                onWidthChanged: root.updateThumb()

                Row {
                    id: inner
                    anchors.centerIn: parent
                    spacing: 7
                    Icon {
                        visible: !!seg.modelData.icon
                        name: seg.modelData.icon || ""
                        size: 16
                        color: seg.active ? Theme.primary : Theme.textMuted
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Txt {
                        visible: !!seg.modelData.label
                        text: seg.modelData.label || ""
                        font.pixelSize: Theme.fsMd
                        font.weight: seg.active ? Font.DemiBold : Font.Medium
                        color: seg.active ? Theme.text : Theme.textMuted
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.selected(seg.modelData.value)
                }
            }
        }
    }
}
