import QtQuick

QtObject {
    id: root

    property var reparations: []
    property var appareils: []
    property var techniciens: []
    property var clients: []
    property var interventions: []

    property string recherche: ""
    property string filtreStatut: "Tous"
    property int filtreTechnicienId: 0

    readonly property var reparationsFiltrees: reparations.filter(function(r) {
        var matchRecherche = !recherche ||
            r.panne.toLowerCase().indexOf(recherche.toLowerCase()) !== -1

        var matchStatut = filtreStatut === "Tous" || r.statut === filtreStatut
        var matchTech = filtreTechnicienId === 0 || r.id_technicien === filtreTechnicienId

        return matchRecherche && matchStatut && matchTech
    })

    readonly property var statutsDisponibles: ["Tous", "Reçu", "Diagnostiqué", "En réparation", "Terminé", "Livré"]

    function infoReparation(id) {
        var r = reparations.find(function(rep) { return rep.id_reparation === id })
        if (!r) return null

        var appareil = appareils.find(function(a) { return a.id_appareil === r.id_appareil })
        var client = null
        if (appareil) {
            client = clients.find(function(c) { return c.id_client === appareil.id_client })
        }
        var tech = techniciens.find(function(t) { return t.id_technicien === r.id_technicien })
        var coutTotal = interventions
            .filter(function(i) { return i.id_reparation === id })
            .reduce(function(sum, i) { return sum + (i.cout || 0) }, 0)

        return {
            reparation: r,
            appareil: appareil,
            client: client,
            technicien: tech,
            coutTotal: coutTotal,
            interventions: interventions.filter(function(i) { return i.id_reparation === id })
        }
    }

    function changerStatut(id, nouveauStatut) {
        var idx = reparations.findIndex(function(r) { return r.id_reparation === id })
        if (idx !== -1) {
            reparations[idx].statut = nouveauStatut
            var now = new Date().toISOString().split('T')[0]
            if (nouveauStatut === "Diagnostiqué") reparations[idx].date_diagnostic = now
            if (nouveauStatut === "Terminé") reparations[idx].date_fin = now
            if (nouveauStatut === "Livré") reparations[idx].date_livraison = now
        }
    }

    function ajouterReparation(rep) {
        var maxId = reparations.reduce(function(max, r) { return Math.max(max, r.id_reparation) }, 0)
        rep.id_reparation = maxId + 1
        rep.statut = "Reçu"
        rep.date_depot = new Date().toISOString().split('T')[0]
        reparations.push(rep)
    }

    function chargerDonnees() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/mock_data.json", true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                reparations = data.reparations || []
                appareils = data.appareils || []
                techniciens = data.techniciens || []
                clients = data.clients || []
                interventions = data.interventions || []
            }
        }
        xhr.send()
    }

    Component.onCompleted: chargerDonnees()
}