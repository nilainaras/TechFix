import QtQuick

QtObject {
    id: root

    property var clients: []
    property var appareils: []
    property string recherche: ""

    // Clients filtrés
    readonly property var clientsFiltres: clients.filter(function(c) {
        if (!recherche) return true
        var term = recherche.toLowerCase()
        return c.nom.toLowerCase().indexOf(term) !== -1 ||
               c.telephone.toLowerCase().indexOf(term) !== -1 ||
               (c.email && c.email.toLowerCase().indexOf(term) !== -1)
    })

    // Appareils d'un client
    function appareilsDuClient(idClient) {
        return appareils.filter(function(a) { return a.id_client === idClient })
    }

    // Ajouter un client
    function ajouterClient(client) {
        var maxId = clients.reduce(function(max, c) { return Math.max(max, c.id_client) }, 0)
        client.id_client = maxId + 1
        client.date_creation = new Date().toISOString().split('T')[0]
        clients.push(client)
    }

    // Modifier un client
    function modifierClient(id, nouveauClient) {
        var idx = clients.findIndex(function(c) { return c.id_client === id })
        if (idx !== -1) {
            clients[idx] = Object.assign({}, clients[idx], nouveauClient)
        }
    }

    // Supprimer un client
    function supprimerClient(id) {
        clients = clients.filter(function(c) { return c.id_client !== id })
    }

    function chargerDonnees() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/mock_data.json", true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                clients = data.clients || []
                appareils = data.appareils || []
            }
        }
        xhr.send()
    }

    Component.onCompleted: chargerDonnees()
}