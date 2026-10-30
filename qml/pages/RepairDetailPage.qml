import QtQuick
import QtQuick.Layouts
import TechFix

// Détail d'une réparation : frise des étapes (règle métier appliquée), interventions
// avec coût total calculé, et fiches du client, de l'appareil et du technicien.
PageScaffold {
    id: page

    showBack: true
    onBackClicked: UI.back()

    readonly property var rv: {
        var r = AppData.reparation(UI.repairId)
        return r ? AppData.repairView(r) : null
    }
    readonly property var device: rv ? AppData.appareil(rv.appareilId) : null
    readonly property var tech: rv ? AppData.technicien(rv.technicienId) : null
    readonly property var items: rv ? AppData.interventionsOf(rv.id) : []
    readonly property var nextInfo: rv ? AppData.nextStatusInfo(rv.id) : ({ ok: false, next: -1, reason: "" })
    readonly property bool wide: width >= 980
    readonly property bool canEditItems: rv !== null && rv.statut >= 1 && rv.statut <= 2

    title: rv ? rv.label : "Réparation introuvable"
    subtitle: rv ? rv.code + " · déposée le " + Fmt.date(rv.dateDepot) : ""

    actions: Row {
        spacing: 10
        visible: page.rv !== null
        AppButton { text: "Modifier"; icon: "pencil"; variant: "secondary"; onClicked: Forms.editRepair(page.rv.id) }
        IconButton {
            icon: "trash-2"; variant: "danger"; tip: "Supprimer la réparation"; size: 42
            onClicked: Forms.deleteRepair(page.rv.id, function () { UI.back() })
        }
    }

    function advance() {
        var res = AppData.advanceStatus(rv.id)
        UI.toast(res.message, res.ok ? "success" : "danger")
    }

    EmptyState {
        visible: page.rv === null
        icon: "circle-alert"
        title: "Cette réparation n'existe plus"
        text: "Elle a peut-être été supprimée. Retournez à la liste pour en choisir une autre."
        actionText: "Retour aux réparations"
        onAction: UI.go("repairs")
    }

    // ── avancement ──
    Card {
        visible: page.rv !== null
        padding: 24
        spacing: 18
        appearDelay: 0

        CardHeader {
            title: "Avancement"
            subtitle: page.rv ? (page.rv.statut === 4 ? "Dossier clos : l'appareil a été remis au client."
                                                     : "Cliquez sur l'étape suivante ou utilisez le bouton.") : ""
            icon: "activity"
            AppButton {
                visible: page.rv !== null && page.rv.statut < 4
                text: page.nextInfo.next >= 0 ? "Passer à « " + Theme.statusLabels[page.nextInfo.next] + " »" : ""
                icon: "arrow-right"
                opacity: page.nextInfo.ok ? 1 : 0.6
                onClicked: page.advance()
            }
            Tag { visible: page.rv !== null && page.rv.statut === 4; text: "Dossier clos"; tone: "violet"; icon: "badge-check" }
        }

        Stepper {
            Layout.fillWidth: true
            Layout.topMargin: 8
            status: page.rv ? page.rv.statut : 0
            timeline: page.rv ? page.rv.timeline : []
            interactive: true
            onStepClicked: (i) => {
                var res = AppData.tryGoTo(page.rv.id, i)
                UI.toast(res.message, res.ok ? "success" : "danger")
            }
        }

        Rectangle {
            visible: page.rv !== null && !page.nextInfo.ok && page.rv.statut < 4
            Layout.fillWidth: true
            implicitHeight: hint.implicitHeight + 24
            radius: Theme.rMd
            color: Theme.warningSoft
            RowLayout {
                id: hint
                anchors { fill: parent; margins: 12 }
                spacing: 10
                Icon { name: "info"; size: 18; color: Theme.warning }
                Txt { text: page.nextInfo.reason; Layout.fillWidth: true; wrapMode: Text.WordWrap; color: Theme.text; font.pixelSize: Theme.fsMd }
            }
        }
    }

    GridLayout {
        visible: page.rv !== null
        Layout.fillWidth: true
        columns: page.wide ? 3 : 1
        columnSpacing: 18
        rowSpacing: 18

        // ── interventions ──
        Card {
            Layout.columnSpan: page.wide ? 2 : 1
            Layout.alignment: Qt.AlignTop
            padding: 22
            spacing: 6
            appearDelay: 80

            CardHeader {
                title: "Interventions"
                subtitle: page.items.length + (page.items.length > 1 ? " travaux saisis" : " travail saisi") + " · le coût final est la somme des interventions"
                icon: "hammer"
                tone: Theme.warning
                AppButton {
                    text: "Ajouter"; icon: "plus"; compact: true
                    enabled: page.canEditItems
                    onClicked: Forms.newIntervention(page.rv.id)
                }
            }

            EmptyState {
                visible: page.items.length === 0
                icon: "hammer"
                title: "Aucune intervention"
                text: page.rv && page.rv.statut === 0
                      ? "Passez la réparation en « Diagnostic » pour saisir les premiers travaux."
                      : "Ajoutez chaque travail effectué avec son coût : le total se calcule seul."
            }

            Item { Layout.preferredHeight: 6; visible: page.items.length > 0 }

            Repeater {
                model: page.items
                delegate: Rectangle {
                    id: row
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    radius: Theme.rMd
                    color: rowHover.hovered ? Theme.surfaceAlt : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.durFast } }
                    HoverHandler { id: rowHover }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 10; rightMargin: 8 }
                        spacing: 14
                        Rectangle {
                            Layout.preferredWidth: 38; Layout.preferredHeight: 38; radius: 11
                            color: Theme.warningSoft
                            Icon { anchors.centerIn: parent; name: "wrench"; size: 18; color: Theme.warning }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Txt { text: row.modelData.description; variant: "strong"; Layout.fillWidth: true; elide: Text.ElideRight }
                            Txt { text: Fmt.dateTime(row.modelData.date); variant: "caption" }
                        }
                        Txt { text: Fmt.ar(row.modelData.cout); variant: "strong" }
                        IconButton {
                            icon: "trash-2"; variant: "danger"; size: 34; iconSize: 17
                            tip: "Supprimer"
                            opacity: page.rv && page.rv.statut < 3 && rowHover.hovered ? 1 : 0
                            enabled: opacity > 0.5
                            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
                            onClicked: Forms.deleteIntervention(row.modelData.id)
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 10; height: 1; color: Theme.border }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 8
                spacing: 12
                Column {
                    Layout.fillWidth: true
                    Txt { text: "Coût total"; variant: "strong" }
                    Txt { text: page.rv && page.rv.statut >= 3 ? "Montant facturé au client" : "Mis à jour à chaque intervention"; variant: "caption" }
                }
                CountText {
                    value: page.rv ? page.rv.cout : 0
                    format: function (v) { return Fmt.ar(v) }
                    variant: "h1"
                    color: Theme.primary
                }
            }
        }

        // ── fiches ──
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            spacing: 18

            Card {
                appearDelay: 160
                CardHeader { title: "Client"; icon: "user-round"; tone: Theme.primary }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    Avatar { name: page.rv ? page.rv.clientName : ""; size: 48 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Txt { text: page.rv ? page.rv.clientName : ""; variant: "strong"; font.pixelSize: Theme.fsLg - 1; Layout.fillWidth: true; elide: Text.ElideRight }
                        Txt { text: page.rv ? page.rv.clientPhone : ""; variant: "muted" }
                    }
                    IconButton {
                        icon: "arrow-up-right"; variant: "surface"; tip: "Voir les clients"
                        onClicked: UI.goSearch("clients", page.rv.clientName)
                    }
                }
            }

            Card {
                appearDelay: 220
                spacing: 10
                CardHeader { title: "Appareil"; icon: page.rv ? page.rv.icon : "laptop"; tone: Theme.violet }
                InfoLine { icon: "tag"; label: "Type"; value: page.device ? page.device.type : "—" }
                InfoLine { icon: "microchip"; label: "Marque"; value: page.device ? page.device.marque : "—" }
                InfoLine { icon: "layers"; label: "Modèle"; value: page.device ? page.device.modele : "—" }
                InfoLine { icon: "hash"; label: "N° de série"; value: page.device ? page.device.numeroSerie : "—" }
            }

            Card {
                appearDelay: 280
                spacing: 10
                CardHeader { title: "Technicien"; icon: "user-cog"; tone: Theme.success }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    Avatar { name: page.tech ? page.tech.nom : ""; size: 44 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Txt { text: page.tech ? page.tech.nom : "—"; variant: "strong"; Layout.fillWidth: true; elide: Text.ElideRight }
                        Txt { text: page.tech ? page.tech.specialite : ""; variant: "caption"; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }
            }

            Card {
                appearDelay: 340
                spacing: 10
                CardHeader { title: "Panne signalée"; icon: "triangle-alert"; tone: Theme.danger }
                Txt { text: page.rv ? page.rv.panne : ""; Layout.fillWidth: true; wrapMode: Text.WordWrap; lineHeight: 1.25 }
                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
                InfoLine { icon: "calendar"; label: "Déposé le"; value: page.rv ? Fmt.date(page.rv.dateDepot) : "" }
                InfoLine {
                    icon: "clock"; label: "Durée"
                    value: page.rv ? (page.rv.age === 0 ? "Aujourd'hui" : page.rv.age + (page.rv.age > 1 ? " jours" : " jour")) : ""
                    tone: page.rv && page.rv.late ? Theme.danger : Theme.textSubtle
                }
            }
        }
    }
}
