import QtQuick
import QtQuick.Layouts
import TechFix

// Paramètres : apparence, comportement, données de démonstration et raccourcis.
PageScaffold {
    id: page

    title: "Paramètres"
    subtitle: "Personnalisez l'application à votre goût"
    maxContentWidth: 980

    Card {
        spacing: 18
        appearDelay: 0
        CardHeader { title: "Apparence"; subtitle: "Thème et confort visuel"; icon: "palette"; tone: Theme.violet }

        SettingRow {
            icon: Theme.dark ? "moon" : "sun"
            title: "Thème"
            description: "Clair pour la journée, sombre pour travailler le soir. Le choix est mémorisé."
            Segmented {
                options: [{ icon: "sun", label: "Clair", value: "light" }, { icon: "moon", label: "Sombre", value: "dark" }]
                current: Theme.dark ? "dark" : "light"
                onSelected: (v) => Theme.dark = (v === "dark")
            }
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
        SettingRow {
            icon: "sparkles"
            title: "Animations"
            description: "Transitions de pages, graphiques animés et effets de survol."
            ToggleSwitch { checked: Theme.animations; onToggled: (v) => Theme.animations = v }
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
        SettingRow {
            icon: "panel-left-close"
            title: "Menu latéral réduit"
            description: "Affiche seulement les icônes pour laisser plus de place au contenu."
            ToggleSwitch { checked: UI.sidebarCollapsed; onToggled: (v) => UI.sidebarCollapsed = v }
        }
    }

    Card {
        spacing: 18
        appearDelay: 80
        CardHeader { title: "Atelier"; subtitle: "Informations de l'application"; icon: "store"; tone: Theme.primary }

        SettingRow {
            icon: "languages"
            title: "Langue"
            description: "L'interface est disponible en français pour le moment."
            Tag { text: "Français"; tone: "primary" }
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
        SettingRow {
            icon: "coins"
            title: "Devise"
            description: "Tous les montants sont exprimés en Ariary."
            Tag { text: "Ariary (Ar)" }
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
        SettingRow {
            icon: "hourglass"
            title: "Seuil de retard"
            description: "Une réparation non terminée après ce délai est signalée en rouge."
            Tag { text: "7 jours"; tone: "danger" }
        }
    }

    Card {
        visible: AppData.demoMode
        spacing: 18
        appearDelay: 160
        CardHeader { title: "Données de démonstration"; subtitle: "Aucun backend pour l'instant : tout est en mémoire"; icon: "database"; tone: Theme.warning }

        Flow {
            Layout.fillWidth: true
            spacing: 10
            Tag { text: AppData.clients.length + " clients"; icon: "users-round" }
            Tag { text: AppData.appareils.length + " appareils"; icon: "laptop" }
            Tag { text: AppData.techniciens.length + " techniciens"; icon: "user-cog" }
            Tag { text: AppData.reparations.length + " réparations"; icon: "wrench" }
            Tag { text: AppData.interventions.length + " interventions"; icon: "hammer" }
        }

        SettingRow {
            icon: "rotate-ccw"
            title: "Réinitialiser les données"
            description: "Revient aux données d'exemple. Vos ajouts et modifications seront perdus."
            AppButton {
                text: "Réinitialiser"; variant: "dangerSoft"; icon: "rotate-ccw"
                onClicked: UI.confirm({
                    title: "Réinitialiser les données ?",
                    message: "Les clients, appareils et réparations ajoutés ou modifiés seront remplacés par les données d'exemple.",
                    confirmText: "Réinitialiser",
                    tone: "warning",
                    icon: "rotate-ccw",
                    onConfirm: function () { AppData.reset(); UI.toast("Données d'exemple restaurées.") }
                })
            }
        }
    }

    Card {
        spacing: 14
        appearDelay: 240
        CardHeader { title: "Raccourcis clavier"; subtitle: "Travaillez plus vite"; icon: "keyboard"; tone: Theme.success }

        Repeater {
            model: [
                { keys: "Ctrl + K", text: "Aller à la recherche globale" },
                { keys: "Alt + ←", text: "Revenir à la page précédente" },
                { keys: "Échap", text: "Fermer un panneau ou une fenêtre" }
            ]
            delegate: RowLayout {
                required property var modelData
                Layout.fillWidth: true
                spacing: 12
                Rectangle {
                    Layout.preferredWidth: 96; Layout.preferredHeight: 32; radius: 8
                    color: Theme.surfaceAlt; border.width: 1; border.color: Theme.border
                    Txt { anchors.centerIn: parent; text: modelData.keys; font.pixelSize: Theme.fsMd; font.weight: Font.DemiBold }
                }
                Txt { text: modelData.text; Layout.fillWidth: true }
            }
        }
    }
}
