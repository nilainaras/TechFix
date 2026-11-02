import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import TechFix

ApplicationWindow {
    id: win
    width: 1440
    height: 900
    minimumWidth: 960
    minimumHeight: 640
    visible: true
    visibility: Window.Maximized          // s'adapte à l'écran de l'utilisateur
    title: "TechFix — Gestion d'un atelier de réparation informatique"
    color: Theme.bg
    font.family: Theme.fontBody

    Settings {
        id: prefs
        category: "TechFix"
        property bool dark: Qt.styleHints.colorScheme === Qt.ColorScheme.Dark
        property bool animations: true
        property bool sidebarCollapsed: false
    }

    Component.onCompleted: {
        Theme.animations = false
        Theme.dark = prefs.dark
        UI.sidebarCollapsed = prefs.sidebarCollapsed
        Qt.callLater(function () { Theme.animations = prefs.animations })
    }

    Connections {
        target: Theme
        function onDarkChanged() { prefs.dark = Theme.dark }
        function onAnimationsChanged() { if (settled) prefs.animations = Theme.animations }
    }
    Connections {
        target: UI
        function onSidebarCollapsedChanged() { prefs.sidebarCollapsed = UI.sidebarCollapsed }
        function onPageChanged() { stack.replace(win.routes[UI.page] || dashboardPage) }
        function onFormRequested(options) { form.open(options) }
        function onConfirmRequested(options) { confirmDialog.open(options) }
        function onToastRequested(message, kind) { toasts.show(message, kind) }
    }
    property bool settled: false
    Timer { interval: 400; running: true; onTriggered: win.settled = true }

    Binding { target: UI; property: "windowWidth"; value: win.width }
    Binding { target: UI; property: "windowHeight"; value: win.height }

    Shortcut { sequence: "Ctrl+K"; onActivated: topBar.focusSearch() }
    Shortcut { sequence: "Alt+Left"; onActivated: UI.back() }

    // ── Pages ───────────────────────────────────────────────────────────────
    Component { id: dashboardPage; DashboardPage {} }
    Component { id: repairsPage; RepairsPage {} }
    Component { id: repairPage; RepairDetailPage {} }
    Component { id: clientsPage; ClientsPage {} }
    Component { id: devicesPage; DevicesPage {} }
    Component { id: techniciansPage; TechniciansPage {} }
    Component { id: invoicesPage; InvoicesPage {} }
    Component { id: statsPage; StatsPage {} }
    Component { id: historyPage; HistoryPage {} }
    Component { id: settingsPage; SettingsPage {} }
    Component { id: aboutPage; AboutPage {} }

    readonly property var routes: ({
        dashboard: dashboardPage, repairs: repairsPage, repair: repairPage, clients: clientsPage,
        devices: devicesPage, technicians: techniciansPage, invoices: invoicesPage, stats: statsPage,
        history: historyPage, settings: settingsPage, about: aboutPage
    })

    // ── Mise en page ────────────────────────────────────────────────────────
    Sidebar {
        id: sidebar
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
    }

    // Petite pastille sur le bord du menu : réduit / agrandit la barre latérale.
    Rectangle {
        id: edgeToggle
        visible: !UI.compact
        z: 20
        width: 26; height: 26; radius: 13
        x: sidebar.width - width / 2
        y: Theme.topbarHeight - height / 2
        color: edgeArea.containsMouse ? Theme.primary : Theme.surface
        border.width: 1
        border.color: edgeArea.containsMouse ? Theme.primary : Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
        Icon {
            anchors.centerIn: parent
            name: "chevron-left"; size: 15
            color: edgeArea.containsMouse ? Theme.textOnPrimary : Theme.textMuted
            rotation: UI.sidebarCollapsed ? 180 : 0
            Behavior on rotation { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }
        }
        MouseArea {
            id: edgeArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: UI.sidebarCollapsed = !UI.sidebarCollapsed
        }
        Tip { side: "right"; text: UI.sidebarCollapsed ? "Agrandir le menu" : "Réduire le menu"; visible: edgeArea.containsMouse }
    }

    Item {
        anchors { left: sidebar.right; right: parent.right; top: parent.top; bottom: parent.bottom }

        TopBar {
            id: topBar
            height: Theme.topbarHeight
            anchors { left: parent.left; right: parent.right; top: parent.top }
            z: 5
        }

        StackView {
            id: stack
            anchors { left: parent.left; right: parent.right; top: topBar.bottom; bottom: parent.bottom }
            clip: true
            initialItem: dashboardPage

            replaceEnter: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durNormal + 40; easing.type: Easing.OutCubic }
                    NumberAnimation { property: "y"; from: 16; to: 0; duration: Theme.durSlow; easing.type: Easing.OutCubic }
                }
            }
            replaceExit: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
            }
        }
    }

    // ── Couches supérieures ─────────────────────────────────────────────────
    FormPanel { id: form; anchors.fill: parent; z: 50 }
    ConfirmDialog { id: confirmDialog; anchors.fill: parent; z: 60 }
    ToastHost { id: toasts; anchors.fill: parent; z: 70; rightInset: form.opened ? form.panelWidth : 0 }
}
