import QtQuick

QtObject {
    id: root

    // Données brutes
    property var clients: []
    property var appareils: []
    property var techniciens: []
    property var reparations: []
    property var interventions: []

    // KPIs calculés
    readonly property int totalReparations: reparations.length
    readonly property int totalClients: clients.length
    readonly property int totalAppareils: appareils.length
    readonly property int totalTechniciens: techniciens.length

    readonly property int enCours: reparations.filter(function(r) {
        return ["Reçu", "Diagnostiqué", "En réparation"].indexOf(r.statut) !== -1
    }).length

    readonly property int termineesCeMois: reparations.filter(function(r) {
        if (r.statut !== "Terminé" && r.statut !== "Livré") return false
        if (!r.date_fin) return false
        var d = new Date(r.date_fin)
        var now = new Date()
        return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear()
    }).length

    readonly property real caDuMois: interventions.reduce(function(sum, i) {
        if (!i.date) return sum
        var d = new Date(i.date)
        var now = new Date()
        if (d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear()) {
            return sum + (i.cout || 0)
        }
        return sum
    }, 0)

    readonly property int reparationsEnRetard: reparations.filter(function(r) {
        if (r.statut === "Livré") return false
        if (!r.date_depot) return false
        var depot = new Date(r.date_depot)
        var now = new Date()
        var diff = Math.ceil((now - depot) / (1000 * 60 * 60 * 24))
        return diff > 7
    }).length

    // Liste des réparations en retard
    readonly property var listeRetard: reparations.filter(function(r) {
        if (r.statut === "Livré") return false
        if (!r.date_depot) return false
        var depot = new Date(r.date_depot)
        var now = new Date()
        var diff = Math.ceil((now - depot) / (1000 * 60 * 60 * 24))
        return diff > 7
    }).map(function(r) {
        var appareil = appareils.find(function(a) { return a.id_appareil === r.id_appareil })
        var depot = new Date(r.date_depot)
        var now = new Date()
        var jours = Math.ceil((now - depot) / (1000 * 60 * 60 * 24))
        return {
            id: r.id_reparation,
            appareil: appareil ? appareil.marque + " " + appareil.modele : "Inconnu",
            jours: jours
        }
    })

    // Activités récentes (5 dernières réparations)
    readonly property var activitesRecentes: reparations
        .slice()
        .sort(function(a, b) { return new Date(b.date_depot) - new Date(a.date_depot) })
        .slice(0, 5)
        .map(function(r) {
            var appareil = appareils.find(function(a) { return a.id_appareil === r.id_appareil })
            var client = clients.find(function(c) {
                if (!appareil) return null
                return c.id_client === appareil.id_client
            })
            return {
                id: r.id_reparation,
                appareil: appareil ? appareil.marque + " " + appareil.modele : "Inconnu",
                client: client ? client.nom : "Inconnu",
                statut: r.statut,
                date: r.date_depot
            }
        })

    // Répartition par statut (pour graphique)
    readonly property var repartitionStatuts: [
        { statut: "Reçu", count: reparations.filter(function(r) { return r.statut === "Reçu" }).length, color: "#64748b" },
        { statut: "Diagnostiqué", count: reparations.filter(function(r) { return r.statut === "Diagnostiqué" }).length, color: "#00d4ff" },
        { statut: "En réparation", count: reparations.filter(function(r) { return r.statut === "En réparation" }).length, color: "#ffaa00" },
        { statut: "Terminé", count: reparations.filter(function(r) { return r.statut === "Terminé" }).length, color: "#00ff88" },
        { statut: "Livré", count: reparations.filter(function(r) { return r.statut === "Livré" }).length, color: "#a855f7" }
    ]

    // Chargement des données
    function chargerDonnees() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/mock_data.json", true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                clients = data.clients || []
                appareils = data.appareils || []
                techniciens = data.techniciens || []
                reparations = data.reparations || []
                interventions = data.interventions || []
            }
        }
        xhr.send()
    }

    // Helper : trouver un appareil par ID
    function getAppareil(id) {
        return appareils.find(function(a) { return a.id_appareil === id })
    }

    // Helper : trouver un client par ID d'appareil
    function getClientFromAppareil(idAppareil) {
        var appareil = getAppareil(idAppareil)
        if (!appareil) return null
        return clients.find(function(c) { return c.id_client === appareil.id_client })
    }

    // Helper : trouver un technicien par ID
    function getTechnicien(id) {
        return techniciens.find(function(t) { return t.id_technicien === id })
    }

    // Helper : coût total d'une réparation
    function coutTotalReparation(idReparation) {
        return interventions
            .filter(function(i) { return i.id_reparation === idReparation })
            .reduce(function(sum, i) { return sum + (i.cout || 0) }, 0)
    }

    Component.onCompleted: chargerDonnees()
}