import QtQuick
import QtQuick.Layouts
import TechFix

// Statistiques : revenus, dépôts, types d'appareils, pannes fréquentes, marques,
// performance des techniciens et délais, sur 3, 6 ou 12 mois.
PageScaffold {
    id: page

    title: "Statistiques"
    subtitle: "Analyse de l'activité de l'atelier"

    property int months: 6
    readonly property bool wide: width >= 1000

    readonly property var summary: AppData.periodSummary(months)
    readonly property var revenue: AppData.revenueSeries(months)
    readonly property var deposits: AppData.repairsSeries(months)
    readonly property var types: AppData.typeCounts(months)
    readonly property var pannes: AppData.topPannes(months, 6)
    readonly property var brands: AppData.brandCounts(months, 6)
    readonly property var techs: AppData.techPerformance(months).filter(function (t) { return t.count > 0 }).slice(0, 6)
    readonly property var delays: AppData.avgDelayByType(months)

    actions: Segmented {
        options: [{ label: "3 mois", value: 3 }, { label: "6 mois", value: 6 }, { label: "12 mois", value: 12 }]
        current: page.months
        onSelected: (v) => page.months = v
    }

    CardGrid {
        // 5 cartes : on évite la carte seule sur la dernière ligne
        columns: width >= 1000 ? 5 : (width >= 620 ? 3 : 2)
        KpiCard {
            title: "Revenus"; icon: "banknote"; tone: "success"
            value: page.summary.revenue; format: function (v) { return Fmt.compact(v) + " Ar" }
            caption: "Réparations facturées"; appearDelay: 0
        }
        KpiCard {
            title: "Dossiers"; icon: "clipboard-list"; tone: "primary"
            value: page.summary.count
            caption: "Appareils déposés"; appearDelay: 50
        }
        KpiCard {
            title: "Coût moyen"; icon: "coins"; tone: "violet"
            value: page.summary.avgCost; format: function (v) { return Fmt.ar(v) }
            caption: "Par réparation facturée"; appearDelay: 100
        }
        KpiCard {
            title: "Délai moyen"; icon: "timer"; tone: "warning"
            value: page.summary.avgDelay
            format: function (v) { return String(Math.round(v * 10) / 10).replace(".", ",") + " j" }
            caption: "Du dépôt à la livraison"; appearDelay: 150
        }
        KpiCard {
            title: "Taux de livraison"; icon: "package-check"; tone: "teal"
            value: page.summary.successRate; format: function (v) { return Math.round(v) + " %" }
            caption: "Dossiers remis aux clients"; appearDelay: 200
        }
    }

    GridLayout {
        Layout.fillWidth: true
        columns: page.wide ? 2 : 1
        columnSpacing: 18
        rowSpacing: 18

        Card {
            Layout.fillHeight: true
            appearDelay: 240
            CardHeader { title: "Revenus par mois"; subtitle: "Montant facturé à la fin des réparations"; icon: "banknote"; tone: Theme.success }
            BarChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 260
                color: Theme.success
                labels: page.revenue.map(function (m) { return m.label })
                values: page.revenue.map(function (m) { return m.value })
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 300
            CardHeader { title: "Appareils déposés"; subtitle: "Nombre de dossiers ouverts chaque mois"; icon: "chart-line"; tone: Theme.primary }
            AreaChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 260
                labels: page.deposits.map(function (m) { return m.label })
                values: page.deposits.map(function (m) { return m.value })
                unit: "dépôts"
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 360
            CardHeader { title: "Types d'appareils"; subtitle: "Ce qui arrive le plus souvent à l'atelier"; icon: "chart-pie"; tone: Theme.violet }
            RowLayout {
                Layout.fillWidth: true
                spacing: 24
                DonutChart {
                    Layout.preferredWidth: 190
                    Layout.preferredHeight: 190
                    segments: page.types.map(function (t, i) { return { label: t.label, value: t.value, color: Theme.chart[i % Theme.chart.length] } })
                    centerCaption: "dossiers"
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Repeater {
                        model: page.types
                        delegate: RowLayout {
                            required property var modelData
                            required property int index
                            Layout.fillWidth: true
                            spacing: 10
                            Rectangle { width: 10; height: 10; radius: 5; color: Theme.chart[index % Theme.chart.length] }
                            Txt { text: modelData.label; Layout.fillWidth: true; elide: Text.ElideRight; font.pixelSize: Theme.fsMd }
                            Txt { text: modelData.value; variant: "strong"; font.pixelSize: Theme.fsMd }
                        }
                    }
                }
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 420
            CardHeader { title: "Pannes les plus fréquentes"; subtitle: "Motifs de dépôt les plus signalés"; icon: "triangle-alert"; tone: Theme.danger }
            HBarList {
                items: page.pannes
                color: Theme.danger
                showRank: true
                valueFormat: function (v) { return v + (v > 1 ? " cas" : " cas") }
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 480
            CardHeader { title: "Techniciens"; subtitle: "Chiffre d'affaires des réparations terminées"; icon: "user-cog"; tone: Theme.success }
            HBarList {
                items: page.techs.map(function (t) { return { label: t.nom, value: t.revenue, sub: t.count + " dossiers" } })
                color: Theme.success
                showRank: true
                valueFormat: function (v) { return Fmt.compact(v) + " Ar" }
            }
        }

        Card {
            Layout.fillHeight: true
            appearDelay: 540
            CardHeader { title: "Marques les plus réparées"; subtitle: "Répartition par fabricant"; icon: "microchip"; tone: Theme.primary }
            HBarList {
                items: page.brands
                color: Theme.primary
                valueFormat: function (v) { return v + " dossiers" }
            }
        }

        Card {
            Layout.fillHeight: true
            Layout.columnSpan: page.wide ? 2 : 1
            appearDelay: 600
            CardHeader { title: "Délai moyen par type d'appareil"; subtitle: "Nombre de jours entre le dépôt et la livraison"; icon: "timer"; tone: Theme.warning }
            HBarList {
                items: page.delays
                color: Theme.warning
                valueFormat: function (v) { return String(v).replace(".", ",") + " j" }
            }
        }
    }
}
