import QtQuick
import QtQuick.Layouts
import TechFix

// Menu latéral marine. Se réduit en rail d'icônes (choix de l'utilisateur ou fenêtre étroite).
Rectangle {
    id: root

    readonly property bool rail: UI.railMode

    width: rail ? Theme.sidebarRail : Theme.sidebarWidth
    color: Theme.sidebar
    clip: true
    Behavior on width { NumberAnimation { duration: Theme.durSlow; easing.type: Easing.OutCubic } }

    readonly property var groups: [
        { title: "Atelier", items: [
            { key: "dashboard", label: "Tableau de bord", icon: "layout-dashboard" },
            { key: "repairs", label: "Réparations", icon: "wrench" } ] },
        { title: "Gestion", items: [
            { key: "clients", label: "Clients", icon: "users-round" },
            { key: "devices", label: "Appareils", icon: "laptop" },
            { key: "technicians", label: "Techniciens", icon: "user-cog" } ] },
        { title: "Suivi", items: [
            { key: "invoices", label: "Factures", icon: "receipt" },
            { key: "history", label: "Historique", icon: "history" },
            { key: "stats", label: "Statistiques", icon: "chart-column" } ] }
    ]

    // trait de séparation à droite
    Rectangle { anchors.right: parent.right; width: 1; height: parent.height; color: Theme.sidebarBorder }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 0
        spacing: 0

        // ── marque ──
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.topbarHeight

            LogoMark {
                id: logo
                size: 42
                x: root.rail ? (parent.width - width) / 2 : 22
                anchors.verticalCenter: parent.verticalCenter
                Behavior on x { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
            }
            Column {
                visible: opacity > 0.01
                opacity: root.rail ? 0 : 1
                anchors { left: logo.right; leftMargin: 13; verticalCenter: parent.verticalCenter }
                Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
                Txt {
                    text: "TechFix"
                    font.family: Theme.fontHeading
                    font.pixelSize: 23
                    font.weight: Font.ExtraBold
                    color: "#F1F5FF"
                }
                Txt { text: "Atelier de réparation"; font.pixelSize: Theme.fsXs + 0.5; color: Theme.sidebarMuted }
            }
        }
        Rectangle { Layout.fillWidth: true; Layout.leftMargin: 18; Layout.rightMargin: 18; height: 1; color: Theme.sidebarBorder }

        // ── navigation ──
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: nav.implicitHeight + 24
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: nav
                x: 14
                y: 14
                width: parent.width - 28
                spacing: 4

                Repeater {
                    model: root.groups
                    delegate: Column {
                        id: group
                        required property var modelData
                        required property int index
                        width: nav.width
                        spacing: 4

                        Item {
                            width: parent.width
                            height: group.index === 0 ? 22 : (UI.lowHeight ? 30 : 38)
                            Txt {
                                text: group.modelData.title
                                font.pixelSize: Theme.fsSm
                                font.weight: Font.DemiBold
                                color: Theme.sidebarMuted
                                x: 6
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 4
                                opacity: root.rail ? 0 : 1
                                Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
                            }
                            // en mode rail, un simple trait remplace le titre de groupe
                            Rectangle {
                                visible: root.rail && group.index > 0
                                width: 22; height: 1
                                color: Theme.sidebarBorder
                                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 8 }
                            }
                        }

                        Repeater {
                            model: group.modelData.items
                            delegate: SidebarItem {
                                required property var modelData
                                width: nav.width
                                icon: modelData.icon
                                label: modelData.label
                                rail: root.rail
                                active: UI.navKey(UI.page) === modelData.key
                                badge: modelData.key === "repairs" ? AppData.enCours() : 0
                                onClicked: UI.go(modelData.key)
                            }
                        }
                    }
                }
            }
        }

        // ── pied : paramètres, à propos, réduire ──
        Rectangle { Layout.fillWidth: true; Layout.leftMargin: 18; Layout.rightMargin: 18; height: 1; color: Theme.sidebarBorder }
        Column {
            Layout.fillWidth: true
            Layout.margins: 14
            spacing: 4

            SidebarItem {
                width: parent.width
                icon: "settings"; label: "Paramètres"; rail: root.rail
                active: UI.page === "settings"
                onClicked: UI.go("settings")
            }
            SidebarItem {
                width: parent.width
                icon: "info"; label: "À propos"; rail: root.rail
                active: UI.page === "about"
                onClicked: UI.go("about")
            }
            SidebarItem {
                visible: !UI.compact
                width: parent.width
                icon: UI.sidebarCollapsed ? "panel-left-open" : "panel-left-close"
                label: "Réduire le menu"
                rail: root.rail
                onClicked: UI.sidebarCollapsed = !UI.sidebarCollapsed
            }
        }
    }
}
