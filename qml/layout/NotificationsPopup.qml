import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TechFix

// Cloche du haut de l'écran : retards, appareils prêts, factures en attente.
Popup {
    id: root

    readonly property var items: AppData.notifications()
    readonly property int count: items.length

    width: 392
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 }
            NumberAnimation { property: "y"; from: root.y - 8; to: root.y; duration: 200; easing.type: Easing.OutCubic }
        }
    }
    exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 100 } }

    background: Item {
        SoftShadow { anchors.fill: parent; radius: Theme.rLg }
        Rectangle { anchors.fill: parent; radius: Theme.rLg; color: Theme.surface; border.width: 1; border.color: Theme.borderStrong }
    }

    contentItem: ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 18
            Layout.bottomMargin: 12
            Txt { text: "Notifications"; variant: "h3"; Layout.fillWidth: true }
            Tag { visible: root.count > 0; text: root.count + " à traiter"; tone: "primary"; small: true }
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }

        EmptyState {
            visible: root.count === 0
            icon: "check"
            title: "Tout est à jour"
            text: "Aucun retard ni facture en attente."
        }

        Repeater {
            model: root.items
            delegate: Item {
                id: row
                required property var modelData
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                Rectangle {
                    anchors { fill: parent; margins: 6 }
                    radius: Theme.rMd
                    color: area.containsMouse ? Theme.surfaceHover : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.durFast } }
                }

                RowLayout {
                    anchors { fill: parent; leftMargin: 18; rightMargin: 18 }
                    spacing: 12
                    Rectangle {
                        Layout.preferredWidth: 38
                        Layout.preferredHeight: 38
                        radius: 19
                        color: Theme.tint(Theme[row.modelData.kind])
                        Icon { anchors.centerIn: parent; name: row.modelData.icon; size: 19; color: Theme[row.modelData.kind] }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Txt { text: row.modelData.title; variant: "strong"; font.pixelSize: Theme.fsMd + 0.5; Layout.fillWidth: true; elide: Text.ElideRight }
                        Txt { text: row.modelData.text; variant: "caption"; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                    Txt { text: row.modelData.time; variant: "caption" }
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.close()
                        if (row.modelData.repId > 0) UI.openRepair(row.modelData.repId)
                        else UI.go("invoices")
                    }
                }
            }
        }
        Item { Layout.preferredHeight: 6 }
    }
}
