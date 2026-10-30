pragma Singleton
import QtQuick

// ─────────────────────────────────────────────────────────────────────────────
//  UI — état global de l'interface : page courante, tailles, messages.
//  Les pages ne se connaissent pas entre elles : elles passent par ce singleton
//  (UI.go("clients"), UI.toast("Enregistré"), UI.confirm({...}), UI.openForm({...})).
// ─────────────────────────────────────────────────────────────────────────────
QtObject {
    id: ui

    // ── Navigation ──────────────────────────────────────────────────────────
    property string page: "dashboard"
    property string previousPage: "dashboard"
    property int repairId: -1
    property double pageChangedAt: Date.now()

    // ── Taille de la fenêtre (renseignée par Main.qml) ──────────────────────
    property real windowWidth: 1366
    property real windowHeight: 800
    readonly property bool lowHeight: windowHeight < 800         // menu latéral plus compact
    readonly property bool compact: windowWidth < 1180      // barre latérale réduite
    readonly property bool narrow: windowWidth < 940        // mise en page très serrée
    property bool sidebarCollapsed: false                   // choix manuel de l'utilisateur
    readonly property bool railMode: sidebarCollapsed || compact

    // ── Signaux reçus par Main.qml ──────────────────────────────────────────
    signal toastRequested(string message, string kind)
    signal confirmRequested(var options)
    signal formRequested(var options)
    signal searchFocusRequested()

    function go(p) {
        if (p === page)
            return
        previousPage = page
        page = p
        pageChangedAt = Date.now()
    }

    function openRepair(id) {
        if (page !== "repair")
            previousPage = page
        repairId = id
        page = "repair"
        pageChangedAt = Date.now()
    }

    function back() {
        go(previousPage === "repair" ? "repairs" : previousPage)
    }

    // L'entrée de menu à surligner pour une page donnée.
    function navKey(p) { return p === "repair" ? "repairs" : p }

    function pageTitle(p) {
        switch (p) {
        case "dashboard": return "Tableau de bord"
        case "repairs": return "Réparations"
        case "repair": return "Détail de la réparation"
        case "clients": return "Clients"
        case "devices": return "Appareils"
        case "technicians": return "Techniciens"
        case "invoices": return "Factures"
        case "stats": return "Statistiques"
        case "history": return "Historique"
        case "settings": return "Paramètres"
        case "about": return "À propos"
        }
        return ""
    }

    // ── Recherche transmise à une page (ex. depuis la recherche globale) ──────
    property string searchPage: ""
    property string searchText: ""
    function goSearch(p, text) {
        searchPage = p
        searchText = text
        go(p)
    }
    function takeSearch(p) {
        if (searchPage !== p) return ""
        var t = searchText
        searchPage = ""
        searchText = ""
        return t
    }

    function toast(message, kind) { toastRequested(message, kind || "success") }
    function confirm(options) { confirmRequested(options) }
    function openForm(options) { formRequested(options) }

    // Vrai si la page vient d'être ouverte : sert à ne jouer l'animation d'entrée
    // des cartes qu'au changement de page (pas à chaque modification des données).
    function justEntered() { return Date.now() - pageChangedAt < 900 }
}
