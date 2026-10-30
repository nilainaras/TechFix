import QtQuick
import QtQuick.Layouts
import TechFix

// Appareils : un type d'icône par catégorie, propriétaire et historique de réparations.
PageScaffold {
    id: page

    title: "Appareils"
    subtitle: AppData.appareils.length + " appareils enregistrés"
    actions: AppButton { text: "Nouvel appareil"; icon: "plus"; onClicked: Forms.newDevice() }

    property string query: ""
    property string typeFilter: ""         // "" = tous

    readonly property var all: {
        var reps = AppData.reparations
        return AppData.appareils.map(function (a) {
            var n = 0, open = 0
            for (var i = 0; i < reps.length; i++) {
                if (reps[i].appareilId !== a.id) continue
                n++
                if (reps[i].statut < 4) open++
            }
            return { id: a.id, clientId: a.clientId, type: a.type, marque: a.marque, modele: a.modele,
                     numeroSerie: a.numeroSerie, owner: AppData.clientName(a.clientId), repairs: n, open: open,
                     icon: AppData.deviceIcon(a.type) }
        })
    }

    readonly property var rows: {
        var q = Fmt.norm(query).trim()
        return all.filter(function (d) {
            if (typeFilter !== "" && d.type !== typeFilter) return false
            return q === "" || Fmt.norm(d.marque + " " + d.modele + " " + d.numeroSerie + " " + d.owner + " " + d.type).indexOf(q) >= 0
        })
    }

    readonly property var chips: {
        var list = [{ label: "Tous", value: "", count: all.length }]
        var types = Forms.deviceTypes
        for (var i = 0; i < types.length; i++) {
            var t = types[i]
            list.push({ label: t, value: t, count: all.filter(function (d) { return d.type === t }).length })
        }
        return list
    }

    Component.onCompleted: {
        var t = UI.takeSearch("devices")
        if (t !== "") search.text = t
    }

    RowLayout {
        Layout.fillWidth: true
        SearchField {
            id: search
            Layout.fillWidth: true
            Layout.maximumWidth: 460
            placeholder: "Marque, modèle, numéro de série, propriétaire…"
            onTextChanged: page.query = text
        }
        Item { Layout.fillWidth: true }
    }

    FilterChips {
        Layout.fillWidth: true
        model: page.chips
        current: page.typeFilter
        onSelected: (v) => page.typeFilter = v
    }

    EmptyState {
        visible: page.rows.length === 0
        icon: "laptop"
        title: page.all.length === 0 ? "Aucun appareil enregistré" : "Aucun appareil trouvé"
        text: page.all.length === 0 ? "Ajoutez un appareil en l'associant à son propriétaire." : "Essayez un autre mot-clé ou un autre type d'appareil."
        actionText: page.all.length === 0 ? "Nouvel appareil" : "Réinitialiser les filtres"
        onAction: { if (page.all.length === 0) Forms.newDevice(); else { search.text = ""; page.typeFilter = "" } }
    }

    CardGrid {
        visible: page.rows.length > 0
        minCell: 330
        Repeater {
            model: page.rows
            delegate: Card {
                id: card
                required property var modelData
                required property int index
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                padding: 20
                spacing: 14
                appearDelay: index < 12 ? index * 40 : -1

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Rectangle {
                        Layout.preferredWidth: 52; Layout.preferredHeight: 52; radius: Theme.rMd
                        color: Theme.violetSoft
                        Icon { anchors.centerIn: parent; name: card.modelData.icon; size: 26; color: Theme.violet }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Txt { text: card.modelData.marque + " " + card.modelData.modele; variant: "h3"; Layout.fillWidth: true; elide: Text.ElideRight }
                        Txt { text: card.modelData.type; variant: "caption" }
                    }
                    Row {
                        spacing: 2
                        IconButton { icon: "pencil"; size: 34; iconSize: 17; tip: "Modifier"; onClicked: Forms.editDevice(card.modelData.id) }
                        IconButton { icon: "trash-2"; variant: "danger"; size: 34; iconSize: 17; tip: "Supprimer"; onClicked: Forms.deleteDevice(card.modelData.id) }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 38
                    radius: Theme.rSm
                    color: Theme.surfaceAlt
                    RowLayout {
                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                        spacing: 8
                        Icon { name: "hash"; size: 15; color: Theme.textSubtle }
                        Txt { text: card.modelData.numeroSerie; font.family: "Consolas"; font.pixelSize: Theme.fsMd; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Avatar { name: card.modelData.owner; size: 28 }
                    Txt { text: card.modelData.owner; Layout.fillWidth: true; elide: Text.ElideRight; font.pixelSize: Theme.fsMd }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Tag {
                        small: true
                        tone: card.modelData.open > 0 ? "primary" : ""
                        icon: "wrench"
                        text: card.modelData.open > 0 ? "En réparation" : card.modelData.repairs + (card.modelData.repairs > 1 ? " passages" : " passage")
                    }
                    Item { Layout.fillWidth: true }
                    AppButton {
                        text: "Réparer"; icon: "plus"; variant: "soft"; compact: true
                        onClicked: Forms.newRepair(card.modelData.clientId)
                    }
                }
            }
        }
    }
}
