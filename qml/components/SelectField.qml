import QtQuick
import QtQuick.Controls
import TechFix

// Liste déroulante.  options : [{ value, label, sub }]
// currentValue est en lecture seule ici : on réagit à `activated(value)` pour la mettre à jour.
Item {
    id: root

    property string label: ""
    property string placeholder: "Sélectionner…"
    property string emptyText: "Aucune option disponible"
    property string error: ""
    property bool required: false
    property var options: []
    property var currentValue: ""
    signal activated(var value)

    readonly property var currentOption: {
        for (var i = 0; i < options.length; i++)
            if (options[i].value === currentValue) return options[i]
        return null
    }

    implicitHeight: col.implicitHeight
    implicitWidth: 300

    Column {
        id: col
        width: parent.width
        spacing: 7

        Row {
            spacing: 4
            visible: root.label !== ""
            Txt { text: root.label; variant: "label"; color: Theme.text; font.pixelSize: Theme.fsMd; font.weight: Font.DemiBold }
            Txt { visible: root.required; text: "*"; color: Theme.danger; font.pixelSize: Theme.fsMd; font.weight: Font.Bold }
        }

        Rectangle {
            id: box
            width: parent.width
            height: 44
            radius: Theme.rMd
            color: Theme.surface
            border.width: (pop.opened || root.error !== "") ? 2 : 1
            border.color: root.error !== "" ? Theme.danger : pop.opened ? Theme.primary : (area.containsMouse ? Theme.borderStrong : Theme.border)
            Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

            Txt {
                anchors { left: parent.left; leftMargin: 14; right: chevron.left; rightMargin: 8; verticalCenter: parent.verticalCenter }
                text: root.currentOption ? root.currentOption.label : (root.options.length === 0 ? root.emptyText : root.placeholder)
                color: root.currentOption ? Theme.text : Theme.textSubtle
                elide: Text.ElideRight
            }
            Icon {
                id: chevron
                name: "chevron-down"
                size: 18
                color: Theme.textMuted
                rotation: pop.opened ? 180 : 0
                anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
                Behavior on rotation { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
            }

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: pop.opened ? pop.close() : pop.open()
            }

            Popup {
                id: pop
                y: box.height + 6
                width: box.width
                padding: 6
                height: Math.min(list.contentHeight + 12, 264)
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                enter: Transition {
                    ParallelAnimation {
                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 140 }
                        NumberAnimation { property: "scale"; from: 0.96; to: 1; duration: 160; easing.type: Easing.OutCubic }
                    }
                }
                exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 90 } }

                background: Rectangle {
                    radius: Theme.rMd
                    color: Theme.surface
                    border.width: 1
                    border.color: Theme.borderStrong
                }

                contentItem: ListView {
                    id: list
                    clip: true
                    model: root.options
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: AppScrollBar {}

                    delegate: Rectangle {
                        required property var modelData
                        width: list.width
                        height: modelData.sub ? 52 : 40
                        radius: Theme.rSm
                        readonly property bool selected: modelData.value === root.currentValue
                        color: selected ? Theme.primarySoft : (rowArea.containsMouse ? Theme.surfaceHover : "transparent")

                        Column {
                            anchors { left: parent.left; leftMargin: 12; right: tick.left; rightMargin: 8; verticalCenter: parent.verticalCenter }
                            spacing: 1
                            Txt { width: parent.width; text: modelData.label; elide: Text.ElideRight; font.weight: selected ? Font.DemiBold : Font.Normal; color: selected ? Theme.primary : Theme.text }
                            Txt { visible: !!modelData.sub; width: parent.width; text: modelData.sub || ""; variant: "caption"; elide: Text.ElideRight }
                        }
                        Icon { id: tick; visible: selected; name: "check"; size: 16; color: Theme.primary; anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter } }

                        MouseArea {
                            id: rowArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { root.activated(modelData.value); pop.close() }
                        }
                    }
                }
            }
        }

        Row {
            spacing: 6
            visible: root.error !== ""
            Icon { name: "circle-alert"; size: 14; color: Theme.danger; anchors.verticalCenter: parent.verticalCenter }
            Txt { text: root.error; color: Theme.danger; font.pixelSize: Theme.fsSm; anchors.verticalCenter: parent.verticalCenter }
        }
    }
}
