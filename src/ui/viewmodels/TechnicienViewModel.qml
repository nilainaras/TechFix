import QtQuick

QtObject {
    id: root

    property var techniciens: []
    property string recherche: ""

    readonly property var techniciensFiltres: techniciens.filter(function(t) {
        if (!recherche) return true
        var term = recherche.toLowerCase()
        return t.nom.toLowerCase().indexOf(term) !== -1 ||
               t.specialite.toLowerCase().indexOf(term) !== -1
    })

    readonly property var techniciensActifs: techniciens.filter(function(t) { return t.actif !== false })

    function ajouterTechnicien(tech) {
        var maxId = techniciens.reduce(function(max, t) { return Math.max(max, t.id_technicien) }, 0)
        tech.id_technicien = maxId + 1
        tech.actif = true
        techniciens.push(tech)
    }

    function modifierTechnicien(id, nouveau) {
        var idx = techniciens.findIndex(function(t) { return t.id_technicien === id })
        if (idx !== -1) {
            techniciens[idx] = Object.assign({}, techniciens[idx], nouveau)
        }
    }

    function supprimerTechnicien(id) {
        techniciens = techniciens.filter(function(t) { return t.id_technicien !== id })
    }

    function chargerDonnees() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/mock_data.json", true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                techniciens = data.techniciens || []
            }
        }
        xhr.send()
    }

    Component.onCompleted: chargerDonnees()
}