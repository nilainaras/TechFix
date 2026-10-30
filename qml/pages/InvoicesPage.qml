import QtQuick
import QtQuick.Layouts
import TechFix

// Factures : générées automatiquement quand une réparation passe à « Terminé ».
// Une facture est « payée » quand l'appareil a été livré.
PageScaffold {
    id: page

    title: "Factures"
    subtitle: "Générées automatiquement à partir des réparations terminées"

    property string query: ""
    property string filter: "all"          // all | due | paid

    readonly property var all: AppData.factures()
    readonly property var paidList: all.filter(function (f) { return f.payee })
    readonly property var dueList: all.filter(function (f) { return !f.payee })
    function sum(list) { var s = 0; for (var i = 0; i < list.length; i++) s += list[i].montant; return s }

    readonly property var rows: {
        var q = Fmt.norm(query).trim()
        return all.filter(function (f) {
            if (filter === "due" && f.payee) return false
            if (filter === "paid" && !f.payee) return false
            return q === "" || Fmt.norm(f.numero + " " + f.clientName + " " + f.label + " " + f.code).indexOf(q) >= 0
        })
    }

    readonly property var chips: [
        { label: "Toutes", value: "all", count: all.length },
        { label: "À régler", value: "due", count: dueList.length },
        { label: "Payées", value: "paid", count: paidList.length }
    ]

    CardGrid {
        // 4 cartes : 4 par ligne ou 2×2, jamais 3 + 1
        columns: width >= 820 ? 4 : 2
        KpiCard {
            title: "Total facturé"; icon: "receipt"; tone: "primary"
            value: page.sum(page.all); format: function (v) { return Fmt.ar(v) }
            caption: page.all.length + " factures émises"; appearDelay: 0
        }
        KpiCard {
            title: "Encaissé"; icon: "circle-check"; tone: "success"
            value: page.sum(page.paidList); format: function (v) { return Fmt.ar(v) }
            caption: page.paidList.length + " factures payées"; appearDelay: 60
        }
        KpiCard {
            title: "À encaisser"; icon: "hourglass"; tone: "warning"
            value: page.sum(page.dueList); format: function (v) { return Fmt.ar(v) }
            caption: page.dueList.length + " en attente de livraison"; appearDelay: 120
        }
        KpiCard {
            title: "Facture moyenne"; icon: "coins"; tone: "violet"
            value: page.all.length > 0 ? page.sum(page.all) / page.all.length : 0
            format: function (v) { return Fmt.ar(Math.round(v / 5000) * 5000) }
            caption: "Sur l'ensemble des factures"; appearDelay: 180
        }
    }

    RowLayout {
        Layout.fillWidth: true
        SearchField {
            id: search
            Layout.fillWidth: true
            Layout.maximumWidth: 460
            placeholder: "N° de facture, client, appareil…"
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
        icon: "receipt"
        title: page.all.length === 0 ? "Aucune facture pour l'instant" : "Aucune facture trouvée"
        text: page.all.length === 0 ? "Une facture apparaît dès qu'une réparation passe à « Terminé »." : "Essayez un autre mot-clé ou un autre filtre."
        actionText: page.all.length === 0 ? "" : "Réinitialiser les filtres"
        onAction: { search.text = ""; page.filter = "all" }
    }

    ColumnLayout {
        visible: page.rows.length > 0
        Layout.fillWidth: true
        spacing: 10

        Repeater {
            model: page.rows
            delegate: Card {
                id: row
                required property var modelData
                required property int index
                Layout.fillWidth: true
                padding: 14
                clickable: true
                appearDelay: index < 14 ? index * 30 : -1
                onClicked: UI.openRepair(modelData.repId)

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14

                    Rectangle {
                        Layout.preferredWidth: 44; Layout.preferredHeight: 44; radius: Theme.rMd
                        color: row.modelData.payee ? Theme.successSoft : Theme.warningSoft
                        Icon {
                            anchors.centerIn: parent
                            name: row.modelData.payee ? "circle-check" : "receipt"
                            size: 21
                            color: row.modelData.payee ? Theme.success : Theme.warning
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Txt { text: row.modelData.numero; variant: "strong"; Layout.fillWidth: true; elide: Text.ElideRight }
                        Txt { text: row.modelData.clientName + " · " + row.modelData.label; variant: "caption"; Layout.fillWidth: true; elide: Text.ElideRight }
                    }

                    Txt {
                        visible: page.width > 760
                        text: Fmt.date(row.modelData.date)
                        variant: "muted"
                        font.pixelSize: Theme.fsMd
                        Layout.preferredWidth: 110
                    }
                    Tag {
                        text: row.modelData.payee ? "Payée" : "À régler"
                        tone: row.modelData.payee ? "success" : "warning"
                        dot: true
                    }
                    Txt {
                        text: Fmt.ar(row.modelData.montant)
                        variant: "strong"
                        horizontalAlignment: Text.AlignRight
                        Layout.preferredWidth: 112
                    }
                    IconButton {
                        icon: "download"; tip: "Télécharger en PDF"
                        onClicked: UI.toast("L'export PDF sera disponible avec le backend.", "info")
                    }
                }
            }
        }
    }
}
