import QtQuick
import QtQuick.Layouts
import TechFix

// Clients : cartes avec nombre d'appareils, de réparations et total dépensé.
PageScaffold {
    id: page

    title: "Clients"
    subtitle: AppData.clients.length + " clients enregistrés"
    actions: AppButton { text: "Nouveau client"; icon: "user-plus"; onClicked: Forms.newClient() }

    property string query: ""
    property string filter: "all"          // all | active | idle

    // une ligne enrichie par client
    readonly property var all: {
        var reps = AppData.repairViews()
        return AppData.clients.map(function (c) {
            var devs = AppData.appareilsOf(c.id).length
            var mine = reps.filter(function (r) { return r.clientId === c.id })
            var active = mine.filter(function (r) { return r.statut < 4 }).length
            var spent = 0
            for (var i = 0; i < mine.length; i++) if (mine[i].statut >= 3) spent += mine[i].cout
            return { id: c.id, nom: c.nom, telephone: c.telephone, devices: devs, repairs: mine.length, active: active, spent: spent }
        }).sort(function (a, b) { return a.nom.localeCompare(b.nom) })
    }

    readonly property var rows: {
        var q = Fmt.norm(query).trim()
        return all.filter(function (c) {
            if (filter === "active" && c.active === 0) return false
            if (filter === "idle" && c.active > 0) return false
            return q === "" || Fmt.norm(c.nom + " " + c.telephone).indexOf(q) >= 0
        })
    }

    readonly property var chips: [
        { label: "Tous", value: "all", count: all.length },
        { label: "Réparation en cours", value: "active", count: all.filter(function (c) { return c.active > 0 }).length },
        { label: "Sans réparation en cours", value: "idle", count: all.filter(function (c) { return c.active === 0 }).length }
    ]

    Component.onCompleted: {
        var t = UI.takeSearch("clients")
        if (t !== "") search.text = t
    }

    RowLayout {
        Layout.fillWidth: true
        SearchField {
            id: search
            Layout.fillWidth: true
            Layout.maximumWidth: 460
            placeholder: "Nom ou numéro de téléphone…"
            onTextChanged: page.query = text
        }
        Item { Layout.fillWidth: true }
    }

    FilterChips {
        Layout.fillWidth: true
        model: page.chips
        current: page.filter
        onSelected: (v) => page.filter = v
    }

    EmptyState {
        visible: page.rows.length === 0
        icon: "users-round"
        title: page.all.length === 0 ? "Aucun client pour le moment" : "Aucun client trouvé"
        text: page.all.length === 0 ? "Ajoutez votre premier client pour pouvoir enregistrer ses appareils." : "Essayez un autre nom ou un autre numéro."
        actionText: page.all.length === 0 ? "Nouveau client" : "Effacer la recherche"
        onAction: { if (page.all.length === 0) Forms.newClient(); else { search.text = ""; page.filter = "all" } }
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
                spacing: 16
                appearDelay: index < 12 ? index * 40 : -1

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Avatar { name: card.modelData.nom; size: 54 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Txt { text: card.modelData.nom; variant: "h3"; Layout.fillWidth: true; elide: Text.ElideRight }
                        RowLayout {
                            spacing: 6
                            Icon { name: "phone"; size: 14; color: Theme.textSubtle }
                            Txt { text: card.modelData.telephone; variant: "muted"; font.pixelSize: Theme.fsMd }
                        }
                    }
                    Row {
                        spacing: 2
                        IconButton { icon: "pencil"; size: 34; iconSize: 17; tip: "Modifier"; onClicked: Forms.editClient(card.modelData.id) }
                        IconButton { icon: "trash-2"; variant: "danger"; size: 34; iconSize: 17; tip: "Supprimer"; onClicked: Forms.deleteClient(card.modelData.id) }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 0
                    uniformCellWidths: true
                    Repeater {
                        model: [
                            { label: "Appareils", value: String(card.modelData.devices) },
                            { label: "Réparations", value: String(card.modelData.repairs) },
                            { label: "Dépensé", value: Fmt.compact(card.modelData.spent) + " Ar" }
                        ]
                        delegate: ColumnLayout {
                            required property var modelData
                            Layout.fillWidth: true
                            spacing: 2
                            Txt { text: modelData.value; variant: "strong"; font.pixelSize: Theme.fsLg }
                            Txt { text: modelData.label; variant: "caption" }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Tag {
                        tone: card.modelData.active > 0 ? "primary" : ""
                        icon: "wrench"; small: true
                        text: card.modelData.active === 0 ? "Aucune réparation en cours"
                              : card.modelData.active + (card.modelData.active > 1 ? " en cours" : " en cours")
                    }
                    Item { Layout.fillWidth: true }
                    AppButton {
                        icon: "laptop"; variant: "ghost"; compact: true; text: "Appareils"
                        onClicked: UI.goSearch("devices", card.modelData.nom)
                    }
                    AppButton {
                        text: "Réparation"; icon: "plus"; variant: "soft"; compact: true
                        onClicked: Forms.newRepair(card.modelData.id)
                    }
                }
            }
        }
    }
}
