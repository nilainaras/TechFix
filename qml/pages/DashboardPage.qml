import QtQuick
import QtQuick.Layouts
import TechFix

// Tableau de bord : chiffres clés, courbe mensuelle, répartition, dernières réparations,
// retards, techniciens les plus actifs et revenus.
PageScaffold {
    id: page

    title: "Tableau de bord"
    subtitle: "Vue d'ensemble de l'atelier"
    actions: AppButton { text: "Nouvelle réparation"; icon: "plus"; onClicked: Forms.newRepair() }

    readonly property bool wide: width >= 1000
    property int months: 6

    readonly property var monthly: AppData.repairsSeries(months)
    readonly property var statusSegments: AppData.statusCounts(0).map(function (s) {
        return { label: s.label, value: s.value, color: Theme.statusColor(s.statut) }
    })
    readonly property int totalRepairs: AppData.reparations.length
    readonly property var recent: AppData.repairViews().slice(0, 6)
    readonly property var lateList: AppData.repairViews().filter(function (v) { return v.late })
        .sort(function (a, b) { return b.age - a.age }).slice(0, 5)
    readonly property var techRanking: AppData.techLoad()
        .map(function (t) { return { label: t.nom, value: t.enCours + t.terminees, sub: t.enCours + " en cours" } })
        .sort(function (a, b) { return b.value - a.value }).slice(0, 5)
    readonly property var revenue: AppData.revenueSeries(6)
    readonly property real revenueNow: AppData.revenueOfMonth(0)
    readonly property real revenuePrev: AppData.revenueOfMonth(1)

    // ── chiffres clés ──
    CardGrid {
        // 4 cartes : 4 par ligne ou 2×2, jamais 3 + 1
        columns: width >= 820 ? 4 : 2

        KpiCard {
            title: "Réparations en cours"; icon: "wrench"; tone: "primary"
            value: AppData.enCours()
            spark: AppData.dailyDeposits(14)
            caption: "Déposées ces 14 derniers jours"
            appearDelay: 0
        }
        KpiCard {
            title: "Prêts à livrer"; icon: "package-check"; tone: "violet"
            value: AppData.aLivrer()
            caption: "Appareils à remettre aux clients"
            appearDelay: 60
        }
        KpiCard {
            title: "Revenus du mois"; icon: "banknote"; tone: "success"
            value: page.revenueNow
            format: function (v) { return Fmt.ar(v) }
            spark: AppData.dailyRevenue(14)
            delta: page.revenuePrev > 0 ? (page.revenueNow - page.revenuePrev) / page.revenuePrev * 100 : NaN
            appearDelay: 120
        }
        KpiCard {
            title: "En retard"; icon: "triangle-alert"; tone: "danger"
            value: AppData.enRetard()
            caption: "Plus de 7 jours sans être terminées"
            appearDelay: 180
        }
    }

    // ── courbe + répartition ──
    GridLayout {
        Layout.fillWidth: true
        columns: page.wide ? 3 : 1
        columnSpacing: 18
        rowSpacing: 18

        Card {
            Layout.columnSpan: page.wide ? 2 : 1
            Layout.fillHeight: true
            appearDelay: 240

            CardHeader {
                title: "Réparations par mois"
                subtitle: "Nombre d'appareils déposés à l'atelier"
                icon: "chart-line"
                Segmented {
                    options: [{ label: "6 mois", value: 6 }, { label: "12 mois", value: 12 }]
                    current: page.months
                    onSelected: (v) => page.months = v
                }
            }
            AreaChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                labels: page.monthly.map(function (m) { return m.label })
                values: page.monthly.map(function (m) { return m.value })
                unit: "réparations"
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 300

            CardHeader { title: "Répartition par statut"; subtitle: page.totalRepairs + " dossiers au total"; icon: "chart-pie"; tone: Theme.violet }
            DonutChart {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                Layout.preferredHeight: 200
                segments: page.statusSegments
                centerCaption: "dossiers"
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: page.statusSegments
                    delegate: RowLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 10
                        Rectangle { width: 10; height: 10; radius: 5; color: modelData.color }
                        Txt { text: modelData.label; Layout.fillWidth: true; font.pixelSize: Theme.fsMd }
                        Txt { text: modelData.value; variant: "strong"; font.pixelSize: Theme.fsMd }
                        Txt {
                            text: page.totalRepairs > 0 ? Math.round(modelData.value / page.totalRepairs * 100) + " %" : "0 %"
                            variant: "caption"
                            horizontalAlignment: Text.AlignRight
                            Layout.preferredWidth: 36
                        }
                    }
                }
            }
        }
    }

    // ── dernières réparations + à surveiller ──
    GridLayout {
        Layout.fillWidth: true
        columns: page.wide ? 3 : 1
        columnSpacing: 18
        rowSpacing: 18

        Card {
            Layout.columnSpan: page.wide ? 2 : 1
            Layout.fillHeight: true
            padding: 18
            spacing: 6
            appearDelay: 360

            CardHeader {
                title: "Dernières réparations"
                subtitle: "Les dossiers les plus récents"
                icon: "clipboard-list"
                AppButton { text: "Tout voir"; variant: "ghost"; compact: true; icon: "arrow-right"; onClicked: UI.go("repairs") }
            }
            Item { Layout.preferredHeight: 6 }
            Repeater {
                model: page.recent
                delegate: RepairRow {
                    required property var modelData
                    Layout.fillWidth: true
                    rep: modelData
                    padding: 10
                    border.width: 0
                    fill: hovered ? Theme.surfaceAlt : "transparent"
                    compact: page.width < 1000
                }
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 420

            CardHeader { title: "À surveiller"; subtitle: "Réparations en retard"; icon: "triangle-alert"; tone: Theme.danger }
            EmptyState {
                visible: page.lateList.length === 0
                icon: "circle-check"
                title: "Aucun retard"
                text: "Toutes les réparations avancent dans les temps."
            }
            Repeater {
                model: page.lateList
                delegate: Rectangle {
                    id: lateRow
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 62
                    radius: Theme.rMd
                    color: lateArea.containsMouse ? Theme.surfaceAlt : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.durFast } }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 6; rightMargin: 8 }
                        spacing: 12
                        Rectangle {
                            Layout.preferredWidth: 40; Layout.preferredHeight: 40; radius: 12
                            color: Theme.dangerSoft
                            Txt { anchors.centerIn: parent; text: lateRow.modelData.age + " j"; font.pixelSize: Theme.fsSm; font.weight: Font.Bold; color: Theme.danger }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Txt { text: lateRow.modelData.label; variant: "strong"; font.pixelSize: Theme.fsMd + 0.5; Layout.fillWidth: true; elide: Text.ElideRight }
                            Txt { text: lateRow.modelData.clientName + " · " + Theme.statusLabels[lateRow.modelData.statut]; variant: "caption"; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                        Icon { name: "chevron-right"; size: 17; color: Theme.textSubtle }
                    }
                    MouseArea {
                        id: lateArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: UI.openRepair(lateRow.modelData.id)
                    }
                }
            }
        }
    }

    // ── techniciens + revenus ──
    GridLayout {
        Layout.fillWidth: true
        columns: page.wide ? 2 : 1
        columnSpacing: 18
        rowSpacing: 18

        Card {
            Layout.fillHeight: true
            appearDelay: 480
            CardHeader { title: "Techniciens les plus actifs"; subtitle: "Dossiers pris en charge (en cours + terminés)"; icon: "user-cog"; tone: Theme.success }
            HBarList {
                items: page.techRanking
                color: Theme.success
                showRank: true
                valueFormat: function (v) { return v + " dossiers" }
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 540
            CardHeader { title: "Revenus des 6 derniers mois"; subtitle: "Réparations facturées (statut Terminé ou Livré)"; icon: "banknote"; tone: Theme.primary }
            BarChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 230
                labels: page.revenue.map(function (m) { return m.label })
                values: page.revenue.map(function (m) { return m.value })
            }
        }
    }
}
