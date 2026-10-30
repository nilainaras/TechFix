import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TechFix

// Liste des réparations : recherche, filtres par statut et trois présentations
// (cartes, liste, kanban par étape).
PageScaffold {
    id: page

    title: "Réparations"
    subtitle: AppData.enCours() + " en cours · " + AppData.reparations.length + " dossiers au total"
    actions: AppButton { text: "Nouvelle réparation"; icon: "plus"; onClicked: Forms.newRepair() }

    property string query: ""
    property var statusFilter: -1            // -1 = toutes, 0..4 = un statut, "late" = en retard
    property string viewMode: "grid"         // grid | list | kanban

    readonly property var all: AppData.repairViews()
    readonly property var rows: {
        var q = Fmt.norm(query).trim()
        var f = statusFilter
        var kanban = viewMode === "kanban"
        return all.filter(function (v) {
            if (!kanban) {
                if (f === "late" && !v.late) return false
                if (typeof f === "number" && f >= 0 && v.statut !== f) return false
            }
            return q === "" || v.search.indexOf(q) >= 0
        })
    }

    readonly property var chips: {
        var list = [{ label: "Toutes", value: -1, count: all.length }]
        for (var s = 0; s < 5; s++) {
            var n = 0
            for (var i = 0; i < all.length; i++) if (all[i].statut === s) n++
            list.push({ label: Theme.statusLabels[s], value: s, count: n })
        }
        var late = all.filter(function (v) { return v.late }).length
        list.push({ label: "En retard", value: "late", count: late })
        return list
    }

    Component.onCompleted: {
        var t = UI.takeSearch("repairs")
        if (t !== "") search.text = t
    }

    // ── barre d'outils ──
    RowLayout {
        Layout.fillWidth: true
        spacing: 14

        SearchField {
            id: search
            Layout.fillWidth: true
            Layout.maximumWidth: 460
            placeholder: "Client, appareil, panne, technicien…"
            onTextChanged: page.query = text
        }
        Item { Layout.fillWidth: true }
        Segmented {
            options: [
                { icon: "layout-grid", label: page.width > 900 ? "Cartes" : "", value: "grid" },
                { icon: "list", label: page.width > 900 ? "Liste" : "", value: "list" },
                { icon: "columns-3", label: page.width > 900 ? "Kanban" : "", value: "kanban" }
            ]
            current: page.viewMode
            onSelected: (v) => page.viewMode = v
        }
    }

    FilterChips {
        visible: page.viewMode !== "kanban"
        Layout.fillWidth: true
        model: page.chips
        current: page.statusFilter
        onSelected: (v) => page.statusFilter = v
    }

    EmptyState {
        visible: page.rows.length === 0
        icon: "search"
        title: "Aucune réparation trouvée"
        text: page.all.length === 0 ? "Enregistrez le premier appareil déposé à l'atelier." : "Essayez un autre mot-clé ou retirez le filtre de statut."
        actionText: page.all.length === 0 ? "Nouvelle réparation" : "Réinitialiser les filtres"
        onAction: {
            if (page.all.length === 0) Forms.newRepair()
            else { search.text = ""; page.statusFilter = -1 }
        }
    }

    // ── cartes ──
    CardGrid {
        visible: page.viewMode === "grid" && page.rows.length > 0
        minCell: 340
        Repeater {
            model: page.viewMode === "grid" ? page.rows : []
            delegate: RepairCard {
                required property var modelData
                required property int index
                rep: modelData
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                appearDelay: index < 12 ? index * 40 : -1
            }
        }
    }

    // ── liste ──
    ColumnLayout {
        visible: page.viewMode === "list" && page.rows.length > 0
        Layout.fillWidth: true
        spacing: 10
        Repeater {
            model: page.viewMode === "list" ? page.rows : []
            delegate: RepairRow {
                required property var modelData
                required property int index
                rep: modelData
                Layout.fillWidth: true
                compact: page.width < 1000
                appearDelay: index < 14 ? index * 30 : -1
            }
        }
    }

    // ── kanban : une colonne par étape ──
    Flickable {
        id: kanban
        visible: page.viewMode === "kanban" && page.rows.length > 0
        Layout.fillWidth: true
        Layout.preferredHeight: board.implicitHeight + 8
        contentWidth: board.width
        contentHeight: board.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick

        Row {
            id: board
            spacing: 16
            readonly property real colW: Math.max(290, (kanban.width - 4 * spacing) / 5)

            Repeater {
                model: 5
                delegate: Column {
                    id: col
                    required property int index
                    readonly property var items: page.viewMode === "kanban" ? page.rows.filter(function (v) { return v.statut === col.index }) : []
                    width: board.colW
                    spacing: 12

                    Rectangle {
                        width: parent.width
                        height: 46
                        radius: Theme.rMd
                        color: Theme.statusSoft(col.index)

                        Row {
                            anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                            spacing: 10
                            Icon { name: Theme.statusIcons[col.index]; size: 18; color: Theme.statusColor(col.index); anchors.verticalCenter: parent.verticalCenter }
                            Txt { text: Theme.statusLabels[col.index]; variant: "strong"; color: Theme.statusColor(col.index); anchors.verticalCenter: parent.verticalCenter }
                        }
                        Rectangle {
                            anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
                            width: Math.max(26, cnt.implicitWidth + 12); height: 24; radius: 12
                            color: Theme.surface
                            Txt { id: cnt; anchors.centerIn: parent; text: col.items.length; font.pixelSize: Theme.fsSm; font.weight: Font.Bold; color: Theme.statusColor(col.index) }
                        }
                    }

                    Rectangle {
                        visible: col.items.length === 0
                        width: parent.width
                        height: 84
                        radius: Theme.rMd
                        color: "transparent"
                        border.width: 1
                        border.color: Theme.border
                        Txt { anchors.centerIn: parent; text: "Aucun dossier"; variant: "caption" }
                    }

                    Repeater {
                        model: col.items
                        delegate: RepairCard {
                            required property var modelData
                            width: col.width
                            rep: modelData
                            showStatus: false
                            padding: 16
                            spacing: 12
                        }
                    }
                }
            }
        }
    }
}
