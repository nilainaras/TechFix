import QtQuick
import QtQuick.Layouts
import TechFix

// Techniciens : charge de travail actuelle, dossiers terminés et chiffre d'affaires.
PageScaffold {
    id: page

    title: "Techniciens"
    subtitle: AppData.techniciens.length + " membres dans l'équipe"
    actions: AppButton { text: "Nouveau technicien"; icon: "user-plus"; onClicked: Forms.newTechnician() }

    property string query: ""
    readonly property int capacity: 6          // dossiers simultanés que l'on considère « pleine charge »

    readonly property var rows: {
        var q = Fmt.norm(query).trim()
        return AppData.techLoad().filter(function (t) {
            return q === "" || Fmt.norm(t.nom + " " + t.specialite).indexOf(q) >= 0
        }).sort(function (a, b) { return b.enCours - a.enCours })
    }

    readonly property int totalActive: {
        var n = 0
        for (var i = 0; i < rows.length; i++) n += rows[i].enCours
        return n
    }

    Component.onCompleted: {
        var t = UI.takeSearch("technicians")
        if (t !== "") search.text = t
    }

    RowLayout {
        Layout.fillWidth: true
        SearchField {
            id: search
            Layout.fillWidth: true
            Layout.maximumWidth: 460
            placeholder: "Nom ou spécialité…"
            onTextChanged: page.query = text
        }
        Item { Layout.fillWidth: true }
        Txt { visible: page.width > 800; text: page.totalActive + " dossiers en cours dans l'atelier"; variant: "muted" }
    }

    EmptyState {
        visible: page.rows.length === 0
        icon: "user-cog"
        title: AppData.techniciens.length === 0 ? "Aucun technicien" : "Aucun technicien trouvé"
        text: AppData.techniciens.length === 0 ? "Ajoutez les membres de l'équipe pour leur affecter des réparations." : "Essayez un autre nom ou une autre spécialité."
        actionText: AppData.techniciens.length === 0 ? "Nouveau technicien" : "Effacer la recherche"
        onAction: { if (AppData.techniciens.length === 0) Forms.newTechnician(); else search.text = "" }
    }

    CardGrid {
        visible: page.rows.length > 0
        minCell: 340
        Repeater {
            model: page.rows
            delegate: Card {
                id: card
                required property var modelData
                required property int index
                readonly property real load: modelData.enCours / page.capacity
                readonly property color loadColor: load >= 1 ? Theme.danger : load >= 0.7 ? Theme.warning : Theme.success
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                padding: 22
                spacing: 16
                appearDelay: index < 12 ? index * 40 : -1

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Avatar { name: card.modelData.nom; size: 58 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Txt { text: card.modelData.nom; variant: "h3"; Layout.fillWidth: true; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Icon { name: "wrench"; size: 14; color: Theme.primary }
                            Txt { text: card.modelData.specialite; variant: "muted"; font.pixelSize: Theme.fsMd; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                    }
                    Row {
                        spacing: 2
                        IconButton { icon: "pencil"; size: 34; iconSize: 17; tip: "Modifier"; onClicked: Forms.editTechnician(card.modelData.id) }
                        IconButton { icon: "trash-2"; variant: "danger"; size: 34; iconSize: 17; tip: "Supprimer"; onClicked: Forms.deleteTechnician(card.modelData.id) }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    RowLayout {
                        Layout.fillWidth: true
                        Txt { text: "Charge de travail"; variant: "muted"; font.pixelSize: Theme.fsMd; Layout.fillWidth: true }
                        Txt {
                            text: card.modelData.enCours + " / " + page.capacity + " dossiers"
                            font.pixelSize: Theme.fsMd; font.weight: Font.DemiBold; color: card.loadColor
                        }
                    }
                    ProgressBar { Layout.fillWidth: true; value: card.load; fill: card.loadColor; thickness: 9 }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 0
                    uniformCellWidths: true
                    Repeater {
                        model: [
                            { label: "En cours", value: String(card.modelData.enCours) },
                            { label: "Terminées", value: String(card.modelData.terminees) },
                            { label: "Chiffre d'aff.", value: Fmt.compact(card.modelData.revenu) + " Ar" }
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

                AppButton {
                    text: "Voir ses réparations"; icon: "arrow-right"; variant: "soft"; compact: true
                    Layout.alignment: Qt.AlignRight
                    onClicked: UI.goSearch("repairs", card.modelData.nom)
                }
            }
        }
    }
}
