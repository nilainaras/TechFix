import QtQuick
import QtQuick.Layouts
import TechFix

// À propos : identité de l'application, fonctionnalités, technologies et équipe.
PageScaffold {
    id: page

    title: "À propos"
    subtitle: "TechFix · version 1.0.0"
    maxContentWidth: 1080

    // ✎ À COMPLÉTER PAR LE GROUPE : remplacez ces lignes par les membres de l'équipe.
    readonly property var team: [
        { name: "Membre 1", role: "Rôle à définir" },
        { name: "Membre 2", role: "Rôle à définir" },
        { name: "Membre 3", role: "Rôle à définir" },
        { name: "Membre 4", role: "Rôle à définir" }
    ]

    readonly property var features: [
        { icon: "wrench", title: "Suivi des réparations", text: "Cartes, liste ou kanban : chaque dossier avance étape par étape." },
        { icon: "activity", title: "Règle des statuts", text: "Reçu, diagnostic, en réparation, terminé, livré : sans saut ni retour en arrière." },
        { icon: "coins", title: "Coût calculé", text: "Le coût final est la somme des interventions, jamais saisi à la main." },
        { icon: "receipt", title: "Factures automatiques", text: "Générées dès qu'une réparation est terminée." },
        { icon: "chart-column", title: "Tableau de bord", text: "Indicateurs, courbes et retards pour piloter l'atelier." },
        { icon: "palette", title: "Thème clair et sombre", text: "Un confort visuel adapté à la journée comme au soir." }
    ]

    Card {
        padding: 32
        spacing: 24
        appearDelay: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: 24
            LogoMark { size: 92 }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Txt { text: "TechFix"; variant: "display"; font.pixelSize: 40 }
                Txt {
                    text: "Gérez les clients, les appareils et les réparations de votre atelier informatique, du dépôt à la livraison."
                    variant: "muted"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    lineHeight: 1.25
                    font.pixelSize: Theme.fsLg - 1
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Tag { text: "Version 1.0.0"; tone: "primary"; icon: "badge-check" }
                    Tag { text: "Interface uniquement"; icon: "layout-dashboard" }
                    Tag { text: "Projet 4 · L1 Informatique" }
                }
            }
        }
    }

    CardGrid {
        minCell: 300
        maxColumns: 3
        Repeater {
            model: page.features
            delegate: Card {
                required property var modelData
                required property int index
                Layout.alignment: Qt.AlignTop
                padding: 22
                spacing: 10
                appearDelay: 80 + index * 50
                Rectangle {
                    Layout.preferredWidth: 44; Layout.preferredHeight: 44; radius: Theme.rMd
                    color: Theme.primarySoft
                    Icon { anchors.centerIn: parent; name: modelData.icon; size: 22; color: Theme.primary }
                }
                Txt { text: modelData.title; variant: "h3"; Layout.topMargin: 4 }
                Txt { text: modelData.text; variant: "muted"; Layout.fillWidth: true; wrapMode: Text.WordWrap; lineHeight: 1.25 }
            }
        }
    }

    GridLayout {
        Layout.fillWidth: true
        columns: page.width >= 980 ? 2 : 1
        columnSpacing: 18
        rowSpacing: 18

        Card {
            Layout.alignment: Qt.AlignTop
            appearDelay: 400
            CardHeader { title: "Technologies"; subtitle: "Ce qui fait tourner l'interface"; icon: "code"; tone: Theme.violet }
            Flow {
                Layout.fillWidth: true
                spacing: 8
                Tag { text: "Qt 6.8"; tone: "success"; icon: "zap" }
                Tag { text: "Qt Quick"; tone: "primary" }
                Tag { text: "QML"; tone: "primary" }
                Tag { text: "Quick Controls (Basic)" }
                Tag { text: "CMake" }
                Tag { text: "MinGW" }
                Tag { text: "Plus Jakarta Sans & Inter" }
                Tag { text: "Icônes Lucide" }
            }
            Txt {
                text: AppData.demoMode ? "Les données affichées sont fictives et conservées en mémoire. Le backend (base de données) sera branché plus tard sans toucher aux pages." : "Les données sont lues depuis la base de données de l'atelier."
                variant: "caption"
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                lineHeight: 1.25
            }
        }

        Card {
            Layout.alignment: Qt.AlignTop
            appearDelay: 460
            CardHeader { title: "L'équipe"; subtitle: "Les personnes derrière TechFix"; icon: "users-round"; tone: Theme.success }
            Repeater {
                model: page.team
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 12
                    Avatar { name: modelData.name; size: 40 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Txt { text: modelData.name; variant: "strong" }
                        Txt { text: modelData.role; variant: "caption" }
                    }
                }
            }
        }
    }
}
