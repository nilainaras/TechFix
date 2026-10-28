import QtQuick

QtObject {
    id: root

    property var appareils: []
    property var clients: []
    property string recherche: ""
    property int filtreClientId: 0  // 0 = tous

    readonly property var appareilsFiltres: appareils.filter(function(a) {
        var matchRecherche = !recherche ||
            a.marque.toLowerCase().indexOf(recherche.toLowerCase()) !== -1 ||
            a.modele.toLowerCase().indexOf(recherche.toLowerCase()) !== -1 ||
            a.numero_serie.toLowerCase().indexOf(recherche.toLowerCase()) !== -1

        var matchClient = filtreClientId === 0 || a.id_client === filtreClientId

        return matchRecherche && matchClient
    })

    function nomClient(idClient) {
        var c = clients.find(function(cl) { return cl.id_client === idClient })
        return c ? c.nom : "Inconnu"
    }

    function ajouterAppareil(appareil) {
        var maxId = appareils.reduce(function(max, a) { return Math.max(max, a.id_appareil) }, 0)
        appareil.id_appareil = maxId + 1
        appareil.date_ajout = new Date().toISOString().split('T')[0]
        appareils.push(appareil)
    }

    function supprimerAppareil(id) {
        appareils = appareils.filter(function(a) { return a.id_appareil !== id })
    }

    function chargerDonnees() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/mock_data.json", true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                appareils = data.appareils || []
                clients = data.clients || []
            }
        }
        xhr.send()
    }

    Component.onCompleted: chargerDonnees()
}