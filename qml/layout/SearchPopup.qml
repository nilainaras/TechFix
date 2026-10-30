import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TechFix

// Résultats de la recherche globale (réparations, clients, appareils).
//   query → texte tapé       picked() → émis quand un résultat est choisi (la barre se vide)
Popup {
    id: root

    property string query: ""
    signal picked()

    readonly property var results: AppData.search(query)
    readonly property int total: results.repairs.length + results.clients.length + results.devices.length

    padding: 8
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 140 } }
    exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 90 } }

    background: Item {
        SoftShadow { anchors.fill: parent; radius: Theme.rLg }
        Rectangle { anchors.fill: parent; radius: Theme.rLg; color: Theme.surface; border.width: 1; border.color: Theme.borderStrong }
    }

    function pick(fn) { root.close(); fn(); root.picked() }

    component Group: Txt {
        Layout.leftMargin: 10
        Layout.topMargin: 8
        font.pixelSize: Theme.fsSm
        font.weight: Font.DemiBold
        color: Theme.textSubtle
    }

    component Hit: Rectangle {
        id: hit
        property string icon: ""
        property color tone: Theme.primary
        property string title: ""
        property string subtitle: ""
        property int status: -1
        signal activated()
        Layout.fillWidth: true
        Layout.preferredHeight: 52
        radius: Theme.rMd
        color: a.containsMouse ? Theme.surfaceHover : "transparent"
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        RowLayout {
            anchors { fill: parent; leftMargin: 10; rightMargin: 12 }
            spacing: 12
            Rectangle {
                Layout.preferredWidth: 34; Layout.preferredHeight: 34; radius: 10
                color: Theme.tint(hit.tone)
                Icon { anchors.centerIn: parent; name: hit.icon; size: 17; color: hit.tone }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Txt { text: hit.title; variant: "strong"; font.pixelSize: Theme.fsMd + 0.5; Layout.fillWidth: true; elide: Text.ElideRight }
                Txt { text: hit.subtitle; variant: "caption"; Layout.fillWidth: true; elide: Text.ElideRight }
            }
            StatusBadge { visible: hit.status >= 0; status: Math.max(0, hit.status) }
        }
        MouseArea { id: a; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: hit.activated() }
    }

    contentItem: ColumnLayout {
        spacing: 2

        EmptyState {
            visible: root.total === 0
            icon: "search"
            title: "Aucun résultat"
            text: "Essayez un nom, un numéro de série ou un code R-0012."
        }

        Group { visible: root.results.repairs.length > 0; text: "Réparations" }
        Repeater {
            model: root.results.repairs
            delegate: Hit {
                required property var modelData
                icon: modelData.icon; tone: Theme.statusColor(modelData.statut)
                title: modelData.label + " · " + modelData.code
                subtitle: modelData.clientName + " — " + modelData.panne
                status: modelData.statut
                onActivated: root.pick(function () { UI.openRepair(modelData.id) })
            }
        }

        Group { visible: root.results.clients.length > 0; text: "Clients" }
        Repeater {
            model: root.results.clients
            delegate: Hit {
                required property var modelData
                icon: "user-round"; tone: Theme.primary
                title: modelData.nom
                subtitle: modelData.telephone
                onActivated: root.pick(function () { UI.goSearch("clients", modelData.nom) })
            }
        }

        Group { visible: root.results.devices.length > 0; text: "Appareils" }
        Repeater {
            model: root.results.devices
            delegate: Hit {
                required property var modelData
                icon: AppData.deviceIcon(modelData.type); tone: Theme.violet
                title: modelData.marque + " " + modelData.modele
                subtitle: modelData.type + " · " + modelData.numeroSerie
                onActivated: root.pick(function () { UI.goSearch("devices", modelData.numeroSerie) })
            }
        }
    }
}
