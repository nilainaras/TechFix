import QtQuick

QtObject {
    id: root

    property var interventions: []

    function interventionsDeReparation(idReparation) {
        return interventions.filter(function(i) { return i.id_reparation === idReparation })
    }

    function coutTotal(idReparation) {
        return interventionsDeReparation(idReparation)
            .reduce(function(sum, i) { return sum + (i.cout || 0) }, 0)
    }

    function ajouterIntervention(intervention) {
        var maxId = interventions.reduce(function(max, i) { return Math.max(max, i.id_intervention) }, 0)
        intervention.id_intervention = maxId + 1
        intervention.date = new Date().toISOString().split('T')[0]
        interventions.push(intervention)
    }

    function supprimerIntervention(id) {
        interventions = interventions.filter(function(i) { return i.id_intervention !== id })
    }

    function modifierIntervention(id, nouveau) {
        var idx = interventions.findIndex(function(i) { return i.id_intervention === id })
        if (idx !== -1) {
            interventions[idx] = Object.assign({}, interventions[idx], nouveau)
        }
    }

    function chargerDonnees() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/mock_data.json", true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                interventions = data.interventions || []
            }
        }
        xhr.send()
    }

    Component.onCompleted: chargerDonnees()
}