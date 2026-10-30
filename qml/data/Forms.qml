pragma Singleton
import QtQuick
import TechFix

// ─────────────────────────────────────────────────────────────────────────────
//  Forms — les formulaires de l'application (panneau latéral) et les suppressions.
//  Chaque fonction décrit un formulaire pour FormPanel.qml et appelle AppData à la validation.
//  Les pages se contentent d'écrire :  Forms.newClient()  ou  Forms.editRepair(id)
// ─────────────────────────────────────────────────────────────────────────────
QtObject {
    readonly property var deviceTypes: ["Ordinateur portable", "Ordinateur de bureau", "Smartphone", "Tablette"]

    // ── listes pour les champs « choix » ────────────────────────────────────
    function clientOptions() {
        return AppData.clients.slice().sort(function (a, b) { return a.nom.localeCompare(b.nom) })
            .map(function (c) { return { value: c.id, label: c.nom, sub: c.telephone } })
    }
    function technicienOptions() {
        return AppData.techniciens.map(function (t) { return { value: t.id, label: t.nom, sub: t.specialite } })
    }
    function appareilOptions(clientId) {
        if (!clientId) return []
        return AppData.appareilsOf(clientId).map(function (a) {
            return { value: a.id, label: a.marque + " " + a.modele, sub: a.type + " · " + a.numeroSerie }
        })
    }
    function typeOptions() {
        return deviceTypes.map(function (t) { return { value: t, label: t } })
    }

    // ── Clients ─────────────────────────────────────────────────────────────
    function clientFields() {
        return [
            { key: "nom", label: "Nom complet", type: "text", required: true, icon: "user-round", placeholder: "Ex. Rakoto Jean", minLength: 2 },
            { key: "telephone", label: "Téléphone", type: "phone", required: true, icon: "phone", placeholder: "034 12 345 67" }
        ]
    }

    function newClient() {
        UI.openForm({
            title: "Nouveau client", subtitle: "Enregistrez ses coordonnées.", icon: "user-round", submitText: "Ajouter le client",
            fields: clientFields(),
            onSubmit: function (v) {
                AppData.addClient({ nom: v.nom.trim(), telephone: v.telephone.trim() })
                return { ok: true, message: "Client « " + v.nom.trim() + " » ajouté." }
            }
        })
    }

    function editClient(id) {
        var c = AppData.client(id)
        if (!c) return
        UI.openForm({
            title: "Modifier le client", subtitle: c.nom, icon: "pencil", submitText: "Enregistrer",
            values: { nom: c.nom, telephone: c.telephone },
            fields: clientFields(),
            onSubmit: function (v) {
                AppData.updateClient(id, { nom: v.nom.trim(), telephone: v.telephone.trim() })
                return { ok: true, message: "Client mis à jour." }
            }
        })
    }

    function deleteClient(id) {
        var c = AppData.client(id)
        if (!c) return
        var devs = AppData.appareilsOf(id).length
        var reps = AppData.repairsOfClient(id).length
        UI.confirm({
            title: "Supprimer ce client ?",
            message: "« " + c.nom + " » sera supprimé" + (devs > 0 ? ", ainsi que ses " + devs + " appareil(s) et " + reps + " réparation(s)." : ".") + " Cette action est définitive.",
            confirmText: "Supprimer",
            onConfirm: function () { AppData.removeClient(id); UI.toast("Client supprimé.") }
        })
    }

    // ── Appareils ───────────────────────────────────────────────────────────
    function deviceFields() {
        return [
            { key: "clientId", label: "Propriétaire", type: "select", required: true, options: clientOptions(), placeholder: "Choisir le client" },
            { key: "type", label: "Type d'appareil", type: "select", required: true, options: typeOptions(), placeholder: "Choisir le type" },
            { key: "marque", label: "Marque", type: "text", required: true, placeholder: "Ex. HP, Samsung, Tecno" },
            { key: "modele", label: "Modèle", type: "text", required: true, placeholder: "Ex. Pavilion 15" },
            { key: "numeroSerie", label: "Numéro de série", type: "text", required: true, icon: "hash", placeholder: "Inscrit sous l'appareil", minLength: 4 }
        ]
    }

    function newDevice(clientId) {
        UI.openForm({
            title: "Nouvel appareil", subtitle: "Associez-le à son propriétaire.", icon: "laptop", submitText: "Ajouter l'appareil",
            values: { clientId: clientId || "" },
            fields: deviceFields(),
            onSubmit: function (v) {
                AppData.addAppareil({ clientId: v.clientId, type: v.type, marque: v.marque.trim(), modele: v.modele.trim(), numeroSerie: v.numeroSerie.trim().toUpperCase() })
                return { ok: true, message: "Appareil « " + v.marque.trim() + " " + v.modele.trim() + " » ajouté." }
            }
        })
    }

    function editDevice(id) {
        var a = AppData.appareil(id)
        if (!a) return
        UI.openForm({
            title: "Modifier l'appareil", subtitle: a.marque + " " + a.modele, icon: "pencil", submitText: "Enregistrer",
            values: { clientId: a.clientId, type: a.type, marque: a.marque, modele: a.modele, numeroSerie: a.numeroSerie },
            fields: deviceFields(),
            onSubmit: function (v) {
                AppData.updateAppareil(id, { clientId: v.clientId, type: v.type, marque: v.marque.trim(), modele: v.modele.trim(), numeroSerie: v.numeroSerie.trim().toUpperCase() })
                return { ok: true, message: "Appareil mis à jour." }
            }
        })
    }

    function deleteDevice(id) {
        var a = AppData.appareil(id)
        if (!a) return
        var reps = AppData.repairsOfDevice(id).length
        UI.confirm({
            title: "Supprimer cet appareil ?",
            message: "« " + a.marque + " " + a.modele + " » sera supprimé" + (reps > 0 ? " avec ses " + reps + " réparation(s)." : ".") + " Cette action est définitive.",
            confirmText: "Supprimer",
            onConfirm: function () { AppData.removeAppareil(id); UI.toast("Appareil supprimé.") }
        })
    }

    // ── Techniciens ─────────────────────────────────────────────────────────
    function technicianFields() {
        return [
            { key: "nom", label: "Nom complet", type: "text", required: true, icon: "user-round", placeholder: "Ex. Rakotoarivelo Hasina", minLength: 2 },
            { key: "specialite", label: "Spécialité", type: "text", required: true, icon: "wrench", placeholder: "Ex. Matériel & soudure", minLength: 3 }
        ]
    }

    function newTechnician() {
        UI.openForm({
            title: "Nouveau technicien", subtitle: "Ajoutez-le à l'équipe de l'atelier.", icon: "user-cog", submitText: "Ajouter le technicien",
            fields: technicianFields(),
            onSubmit: function (v) {
                AppData.addTechnicien({ nom: v.nom.trim(), specialite: v.specialite.trim() })
                return { ok: true, message: "Technicien « " + v.nom.trim() + " » ajouté." }
            }
        })
    }

    function editTechnician(id) {
        var t = AppData.technicien(id)
        if (!t) return
        UI.openForm({
            title: "Modifier le technicien", subtitle: t.nom, icon: "pencil", submitText: "Enregistrer",
            values: { nom: t.nom, specialite: t.specialite },
            fields: technicianFields(),
            onSubmit: function (v) {
                AppData.updateTechnicien(id, { nom: v.nom.trim(), specialite: v.specialite.trim() })
                return { ok: true, message: "Technicien mis à jour." }
            }
        })
    }

    function deleteTechnician(id) {
        var t = AppData.technicien(id)
        if (!t) return
        UI.confirm({
            title: "Supprimer ce technicien ?",
            message: "« " + t.nom + " » sera retiré de l'équipe. S'il est rattaché à des réparations, la suppression sera refusée.",
            confirmText: "Supprimer",
            onConfirm: function () {
                var res = AppData.removeTechnicien(id)
                UI.toast(res.message, res.ok ? "success" : "danger")
            }
        })
    }

    // ── Réparations ─────────────────────────────────────────────────────────
    function repairFields() {
        return [
            { key: "clientId", label: "Client", type: "select", required: true, options: clientOptions(), placeholder: "Choisir le client" },
            { key: "appareilId", label: "Appareil", type: "select", required: true, dependsOn: "clientId",
              options: function (v) { return appareilOptions(v.clientId) },
              placeholder: "Choisir l'appareil", emptyText: "Choisissez d'abord un client qui possède un appareil" },
            { key: "technicienId", label: "Technicien affecté", type: "select", required: true, options: technicienOptions(), placeholder: "Choisir le technicien" },
            { key: "panne", label: "Panne signalée", type: "multiline", required: true, minLength: 5, placeholder: "Ex. L'écran reste noir au démarrage" }
        ]
    }

    function newRepair(clientId) {
        UI.openForm({
            title: "Nouvelle réparation", subtitle: "L'appareil entre à l'atelier au statut « Reçu ».", icon: "wrench", submitText: "Enregistrer le dépôt",
            values: { clientId: clientId || "" },
            fields: repairFields(),
            onSubmit: function (v) {
                var id = AppData.addReparation({ appareilId: v.appareilId, technicienId: v.technicienId, panne: v.panne.trim() })
                Qt.callLater(function () { UI.openRepair(id) })
                return { ok: true, message: "Réparation " + Fmt.repairId(id) + " enregistrée." }
            }
        })
    }

    function editRepair(id) {
        var r = AppData.reparation(id)
        if (!r) return
        var ap = AppData.appareil(r.appareilId)
        UI.openForm({
            title: "Modifier la réparation", subtitle: Fmt.repairId(id), icon: "pencil", submitText: "Enregistrer",
            values: { clientId: ap ? ap.clientId : "", appareilId: r.appareilId, technicienId: r.technicienId, panne: r.panne },
            fields: repairFields(),
            onSubmit: function (v) {
                AppData.updateReparation(id, { appareilId: v.appareilId, technicienId: v.technicienId, panne: v.panne.trim() })
                return { ok: true, message: "Réparation mise à jour." }
            }
        })
    }

    function deleteRepair(id, after) {
        var r = AppData.reparation(id)
        if (!r) return
        if (r.statut >= 3) {
            UI.toast("Une réparation terminée est facturée : elle ne peut plus être supprimée.", "danger")
            return
        }
        UI.confirm({
            title: "Supprimer cette réparation ?",
            message: Fmt.repairId(id) + " et ses interventions seront supprimées. Cette action est définitive.",
            confirmText: "Supprimer",
            onConfirm: function () {
                AppData.removeReparation(id)
                UI.toast("Réparation supprimée.")
                if (after) after()
            }
        })
    }

    // ── Interventions ───────────────────────────────────────────────────────
    function newIntervention(repId) {
        UI.openForm({
            title: "Nouvelle intervention", subtitle: Fmt.repairId(repId) + " · le coût s'ajoute au total de la réparation.", icon: "hammer", submitText: "Ajouter l'intervention",
            fields: [
                { key: "description", label: "Travail effectué", type: "text", required: true, icon: "wrench", placeholder: "Ex. Remplacement de l'écran", minLength: 3 },
                { key: "cout", label: "Coût", type: "number", required: true, suffix: "Ar", placeholder: "Minimum 5 000 Ar, ex. 45000", min: 5000, max: 5000000 }
            ],
            onSubmit: function (v) {
                var res = AppData.addIntervention(repId, v.description.trim(), parseInt(v.cout, 10))
                return res
            }
        })
    }

    function deleteIntervention(id) {
        var res = AppData.removeIntervention(id)
        UI.toast(res.message, res.ok ? "success" : "danger")
    }
}
