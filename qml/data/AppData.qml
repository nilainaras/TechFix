pragma Singleton
import QtQuick
import "DemoData.js" as Demo   // DEMO (1/3) : à supprimer avec DemoData.js
import TechFix

// ─────────────────────────────────────────────────────────────────────────────
//  AppData — données EN MÉMOIRE (aucun backend pour l'instant).
//
//  Les 5 tables du sujet sont des tableaux JavaScript :
//    clients      { id, nom, telephone }
//    appareils    { id, clientId, type, marque, modele, numeroSerie }
//    techniciens  { id, nom, specialite }
//    reparations  { id, appareilId, technicienId, panne, dateDepot, statut, timeline }
//    interventions{ id, reparationId, description, cout, date }
//
//  Règles métier appliquées ici :
//    • une réparation suit : reçu → diagnostic → en réparation → terminé → livré
//      (pas de saut d'étape, pas de retour en arrière) ;
//    • le coût final = somme des interventions (jamais stocké, toujours calculé) ;
//    • pour terminer une réparation, il faut au moins une intervention.
//
//  Le jour où le vrai backend arrivera, seul ce fichier sera remplacé :
//  les pages appellent uniquement ces fonctions.
// ─────────────────────────────────────────────────────────────────────────────
QtObject {
    id: root

    property var clients: []
    property var appareils: []
    property var techniciens: []
    property var reparations: []
    property var interventions: []

    // Horloge interne (mise à jour chaque minute) : sert aux retards et aux dates relatives.
    property date now: new Date()
    property Timer clock: Timer {
        interval: 60000; running: true; repeat: true
        onTriggered: root.now = new Date()
    }

    // ── Source des données ──────────────────────────────────────────────────
    //  demoMode = true  : données fictives générées par DemoData.js
    //  demoMode = false : listes vides, prêt pour la vraie base de données.
    //  Voir « Brancher la base de données » dans le README (3 lignes marquées DEMO à retirer).
    readonly property bool demoMode: true   // DEMO (2/3)

    Component.onCompleted: load()

    // POINT D'ENTRÉE UNIQUE : charge les 5 tables en mémoire.
    // Avec une base de données, c'est ici qu'on remplace les tableaux par le résultat des requêtes.
    function load() {
        var d = demoMode ? Demo.build()   // DEMO (3/3)
                         : { clients: [], appareils: [], techniciens: [], reparations: [], interventions: [] }
        clients = d.clients
        appareils = d.appareils
        techniciens = d.techniciens
        reparations = d.reparations
        interventions = d.interventions
        now = new Date()
    }
    function reset() { load() }   // utilisé par Paramètres > « Restaurer les données d'exemple »

    // ── Accès par identifiant ───────────────────────────────────────────────
    function byId(list, id) {
        for (var i = 0; i < list.length; i++)
            if (list[i].id === id) return list[i]
        return null
    }
    function nextId(list) {
        var m = 0
        for (var i = 0; i < list.length; i++) m = Math.max(m, list[i].id)
        return m + 1
    }

    function client(id) { return byId(clients, id) }
    function appareil(id) { return byId(appareils, id) }
    function technicien(id) { return byId(techniciens, id) }
    function reparation(id) { return byId(reparations, id) }

    function clientName(id) { var c = byId(clients, id); return c ? c.nom : "—" }
    function technicienName(id) { var t = byId(techniciens, id); return t ? t.nom : "—" }
    function deviceLabel(ap) { return ap ? ap.marque + " " + ap.modele : "—" }
    function deviceIcon(type) {
        switch (type) {
        case "Ordinateur portable": return "laptop"
        case "Ordinateur de bureau": return "monitor"
        case "Tablette": return "tablet"
        }
        return "smartphone"
    }

    // ── Vues enrichies (jointures prêtes à afficher) ────────────────────────
    function ageDays(rep) { return Math.max(0, Fmt.daysBetween(rep.dateDepot, now)) }
    function isLate(rep) { return rep.statut < 3 && ageDays(rep) > 7 }

    function repairView(rep) {
        var ap = byId(appareils, rep.appareilId)
        var cl = ap ? byId(clients, ap.clientId) : null
        var te = byId(techniciens, rep.technicienId)
        return {
            id: rep.id,
            code: Fmt.repairId(rep.id),
            appareilId: rep.appareilId,
            clientId: cl ? cl.id : -1,
            technicienId: rep.technicienId,
            label: deviceLabel(ap),
            type: ap ? ap.type : "",
            marque: ap ? ap.marque : "",
            icon: deviceIcon(ap ? ap.type : ""),
            clientName: cl ? cl.nom : "—",
            clientPhone: cl ? cl.telephone : "",
            technicienName: te ? te.nom : "—",
            panne: rep.panne,
            statut: rep.statut,
            dateDepot: rep.dateDepot,
            timeline: rep.timeline,
            cout: coutTotal(rep.id),
            late: isLate(rep),
            age: ageDays(rep),
            search: Fmt.norm(Fmt.repairId(rep.id) + " " + deviceLabel(ap) + " " + (cl ? cl.nom : "") + " " + rep.panne + " " + (te ? te.nom : ""))
        }
    }

    function repairViews() {
        var out = []
        for (var i = reparations.length - 1; i >= 0; i--)    // récentes d'abord
            out.push(repairView(reparations[i]))
        return out
    }

    function interventionsOf(repId) {
        var out = []
        for (var i = 0; i < interventions.length; i++)
            if (interventions[i].reparationId === repId) out.push(interventions[i])
        out.sort(function (a, b) { return a.date.getTime() - b.date.getTime() })
        return out
    }

    // Le coût final est TOUJOURS calculé à partir des interventions.
    function coutTotal(repId) {
        var sum = 0
        for (var i = 0; i < interventions.length; i++)
            if (interventions[i].reparationId === repId) sum += interventions[i].cout
        return sum
    }

    function appareilsOf(clientId) {
        return appareils.filter(function (a) { return a.clientId === clientId })
    }
    function repairsOfClient(clientId) {
        var ids = appareilsOf(clientId).map(function (a) { return a.id })
        return repairViews().filter(function (v) { return ids.indexOf(v.appareilId) >= 0 })
    }
    function repairsOfDevice(deviceId) {
        return repairViews().filter(function (v) { return v.appareilId === deviceId })
    }
    function repairsOfTechnician(techId) {
        return repairViews().filter(function (v) { return v.technicienId === techId })
    }

    // ── Règles de statut ────────────────────────────────────────────────────
    function nextStatusInfo(repId) {
        var rep = byId(reparations, repId)
        if (!rep) return { ok: false, next: -1, reason: "Réparation introuvable." }
        if (rep.statut >= 4)
            return { ok: false, next: -1, reason: "Cette réparation est déjà livrée : le dossier est clos." }
        var next = rep.statut + 1
        if (next === 3 && interventionsOf(repId).length === 0)
            return { ok: false, next: next, reason: "Ajoutez au moins une intervention avant de terminer la réparation." }
        return { ok: true, next: next, reason: "" }
    }

    function advanceStatus(repId) {
        var info = nextStatusInfo(repId)
        if (!info.ok) return { ok: false, message: info.reason }
        var d = new Date()
        reparations = reparations.map(function (r) {
            if (r.id !== repId) return r
            var tl = r.timeline.concat([{ statut: info.next, date: d }])
            return Object.assign({}, r, { statut: info.next, timeline: tl })
        })
        return { ok: true, message: "Statut mis à jour : « " + Theme.statusLabels[info.next] + " »." }
    }

    // Tentative de passer directement à une étape donnée (clic sur la frise).
    function tryGoTo(repId, target) {
        var rep = byId(reparations, repId)
        if (!rep) return { ok: false, message: "Réparation introuvable." }
        if (target === rep.statut)
            return { ok: false, message: "La réparation est déjà à l'étape « " + Theme.statusLabels[target] + " »." }
        if (target < rep.statut)
            return { ok: false, message: "Impossible de revenir en arrière : une étape franchie est définitive." }
        if (target > rep.statut + 1)
            return { ok: false, message: "Étape à respecter : « " + Theme.statusLabels[rep.statut + 1] + " » doit précéder « " + Theme.statusLabels[target] + " »." }
        return advanceStatus(repId)
    }

    // ── Clients ─────────────────────────────────────────────────────────────
    function addClient(o) {
        var id = nextId(clients)
        clients = clients.concat([{ id: id, nom: o.nom, telephone: o.telephone }])
        return id
    }
    function updateClient(id, o) {
        clients = clients.map(function (c) { return c.id === id ? Object.assign({}, c, { nom: o.nom, telephone: o.telephone }) : c })
    }
    function removeClient(id) {
        var devs = appareilsOf(id)
        for (var i = 0; i < devs.length; i++) removeAppareil(devs[i].id)
        clients = clients.filter(function (c) { return c.id !== id })
    }

    // ── Appareils ───────────────────────────────────────────────────────────
    function addAppareil(o) {
        var id = nextId(appareils)
        appareils = appareils.concat([{ id: id, clientId: o.clientId, type: o.type, marque: o.marque, modele: o.modele, numeroSerie: o.numeroSerie }])
        return id
    }
    function updateAppareil(id, o) {
        appareils = appareils.map(function (a) {
            return a.id === id ? Object.assign({}, a, { clientId: o.clientId, type: o.type, marque: o.marque, modele: o.modele, numeroSerie: o.numeroSerie }) : a
        })
    }
    function removeAppareil(id) {
        var reps = reparations.filter(function (r) { return r.appareilId === id })
        for (var i = 0; i < reps.length; i++) removeReparation(reps[i].id)
        appareils = appareils.filter(function (a) { return a.id !== id })
    }

    // ── Techniciens ─────────────────────────────────────────────────────────
    function addTechnicien(o) {
        var id = nextId(techniciens)
        techniciens = techniciens.concat([{ id: id, nom: o.nom, specialite: o.specialite }])
        return id
    }
    function updateTechnicien(id, o) {
        techniciens = techniciens.map(function (t) { return t.id === id ? Object.assign({}, t, { nom: o.nom, specialite: o.specialite }) : t })
    }
    function removeTechnicien(id) {
        var used = reparations.some(function (r) { return r.technicienId === id })
        if (used) return { ok: false, message: "Ce technicien est rattaché à des réparations : réaffectez-les avant de le supprimer." }
        techniciens = techniciens.filter(function (t) { return t.id !== id })
        return { ok: true, message: "Technicien supprimé." }
    }

    // ── Réparations ─────────────────────────────────────────────────────────
    function addReparation(o) {
        var id = nextId(reparations)
        var d = new Date()
        reparations = reparations.concat([{ id: id, appareilId: o.appareilId, technicienId: o.technicienId, panne: o.panne,
                                            dateDepot: d, statut: 0, timeline: [{ statut: 0, date: d }] }])
        return id
    }
    function updateReparation(id, o) {
        reparations = reparations.map(function (r) {
            return r.id === id ? Object.assign({}, r, { appareilId: o.appareilId, technicienId: o.technicienId, panne: o.panne }) : r
        })
    }
    function removeReparation(id) {
        interventions = interventions.filter(function (i) { return i.reparationId !== id })
        reparations = reparations.filter(function (r) { return r.id !== id })
    }

    // ── Interventions ───────────────────────────────────────────────────────
    readonly property int coutMinIntervention: 5000   // Ar — coût minimum d'une intervention

    function addIntervention(repId, description, cout) {
        if (!(cout >= coutMinIntervention))
            return { ok: false, message: "Le coût d'une intervention est d'au moins " + Fmt.ar(coutMinIntervention) + "." }
        var rep = byId(reparations, repId)
        if (!rep) return { ok: false, message: "Réparation introuvable." }
        if (rep.statut < 1) return { ok: false, message: "Passez d'abord la réparation en « Diagnostic » avant de saisir des interventions." }
        if (rep.statut > 2) return { ok: false, message: "La réparation est terminée : ses interventions sont figées." }
        interventions = interventions.concat([{ id: nextId(interventions), reparationId: repId, description: description, cout: cout, date: new Date() }])
        return { ok: true, message: "Intervention ajoutée." }
    }
    function removeIntervention(id) {
        var it = byId(interventions, id)
        if (!it) return { ok: false, message: "Intervention introuvable." }
        var rep = byId(reparations, it.reparationId)
        if (rep && rep.statut >= 3)
            return { ok: false, message: "La réparation est terminée : ses interventions sont figées." }
        interventions = interventions.filter(function (i) { return i.id !== id })
        return { ok: true, message: "Intervention supprimée." }
    }

    // ═════════════════════════ Indicateurs et statistiques ═════════════════════════
    function countByStatus(status) {
        var n = 0
        for (var i = 0; i < reparations.length; i++) if (reparations[i].statut === status) n++
        return n
    }
    function enCours() {
        var n = 0
        for (var i = 0; i < reparations.length; i++) if (reparations[i].statut < 3) n++
        return n
    }
    function aLivrer() { return countByStatus(3) }
    function enRetard() {
        var n = 0
        for (var i = 0; i < reparations.length; i++) if (isLate(reparations[i])) n++
        return n
    }

    function monthIndex(d) { return d.getFullYear() * 12 + d.getMonth() }

    // Les n derniers mois, du plus ancien au mois courant.
    function lastMonths(n) {
        var out = []
        var cur = monthIndex(now)
        for (var i = n - 1; i >= 0; i--) {
            var idx = cur - i
            var y = Math.floor(idx / 12), m = idx % 12
            out.push({ key: idx, month: m, year: y, label: Fmt.months[m].replace(".", "") })
        }
        return out
    }

    // Date de facturation = date à laquelle la réparation passe à « Terminé ».
    function invoiceDate(rep) {
        for (var i = 0; i < rep.timeline.length; i++)
            if (rep.timeline[i].statut === 3) return rep.timeline[i].date
        return null
    }
    function deliveryDate(rep) {
        for (var i = 0; i < rep.timeline.length; i++)
            if (rep.timeline[i].statut === 4) return rep.timeline[i].date
        return null
    }

    function factures() {
        var list = []
        for (var i = 0; i < reparations.length; i++) {
            var r = reparations[i]
            var d = invoiceDate(r)
            if (!d) continue
            var v = repairView(r)
            list.push({ repId: r.id, date: d, montant: v.cout, payee: r.statut === 4,
                        clientName: v.clientName, label: v.label, code: v.code, clientId: v.clientId })
        }
        list.sort(function (a, b) { return a.date.getTime() - b.date.getTime() })
        var perYear = {}
        for (var k = 0; k < list.length; k++) {
            var y = list[k].date.getFullYear()
            perYear[y] = (perYear[y] || 0) + 1
            list[k].numero = "F-" + y + "-" + Fmt.pad(perYear[y], 4)
        }
        list.reverse()
        return list
    }

    function revenueSeries(n) {
        var ms = lastMonths(n)
        var inv = factures()
        return ms.map(function (m) {
            var sum = 0
            for (var i = 0; i < inv.length; i++)
                if (monthIndex(inv[i].date) === m.key) sum += inv[i].montant
            return { label: m.label, value: sum }
        })
    }

    function repairsSeries(n) {
        var ms = lastMonths(n)
        return ms.map(function (m) {
            var c = 0
            for (var i = 0; i < reparations.length; i++)
                if (monthIndex(reparations[i].dateDepot) === m.key) c++
            return { label: m.label, value: c }
        })
    }

    // Dépôts par jour sur les n derniers jours (sparklines).
    function dailyDeposits(n) {
        var out = []
        var today = Fmt.startOfDay(now)
        for (var i = n - 1; i >= 0; i--) {
            var c = 0
            for (var j = 0; j < reparations.length; j++)
                if (Fmt.daysBetween(reparations[j].dateDepot, today) === i) c++
            out.push(c)
        }
        return out
    }

    function dailyRevenue(n) {
        var out = []
        var today = Fmt.startOfDay(now)
        var inv = factures()
        for (var i = n - 1; i >= 0; i--) {
            var s = 0
            for (var j = 0; j < inv.length; j++)
                if (Fmt.daysBetween(inv[j].date, today) === i) s += inv[j].montant
            out.push(s)
        }
        return out
    }

    function revenueOfMonth(offset) {
        var s = revenueSeries(offset + 1)
        return s[0].value
    }

    function statusCounts(sinceDays) {
        var out = []
        for (var s = 0; s < 5; s++) out.push({ statut: s, label: Theme.statusLabels[s], value: 0 })
        for (var i = 0; i < reparations.length; i++) {
            var r = reparations[i]
            if (sinceDays > 0 && Fmt.daysBetween(r.dateDepot, now) > sinceDays) continue
            out[r.statut].value++
        }
        return out
    }

    function inPeriod(rep, months) {
        if (!months || months <= 0) return true
        var first = lastMonths(months)[0].key
        return monthIndex(rep.dateDepot) >= first
    }

    function countBy(fn, months, limit) {
        var map = {}
        for (var i = 0; i < reparations.length; i++) {
            var r = reparations[i]
            if (!inPeriod(r, months)) continue
            var key = fn(r)
            map[key] = (map[key] || 0) + 1
        }
        var arr = []
        for (var k in map) arr.push({ label: k, value: map[k] })
        arr.sort(function (a, b) { return b.value - a.value })
        return limit ? arr.slice(0, limit) : arr
    }

    function topPannes(months, limit) { return countBy(function (r) { return r.panne }, months, limit) }
    function typeCounts(months) {
        return countBy(function (r) { var a = byId(appareils, r.appareilId); return a ? a.type : "Autre" }, months, 0)
    }
    function brandCounts(months, limit) {
        return countBy(function (r) { var a = byId(appareils, r.appareilId); return a ? a.marque : "Autre" }, months, limit)
    }

    function techLoad() {
        return techniciens.map(function (t) {
            var active = 0, done = 0, rev = 0
            for (var i = 0; i < reparations.length; i++) {
                var r = reparations[i]
                if (r.technicienId !== t.id) continue
                if (r.statut < 3) active++
                else { done++; rev += coutTotal(r.id) }
            }
            return { id: t.id, nom: t.nom, specialite: t.specialite, enCours: active, terminees: done, revenu: rev }
        })
    }

    function techPerformance(months) {
        return techniciens.map(function (t) {
            var n = 0, rev = 0
            for (var i = 0; i < reparations.length; i++) {
                var r = reparations[i]
                if (r.technicienId !== t.id || r.statut < 3 || !inPeriod(r, months)) continue
                n++; rev += coutTotal(r.id)
            }
            return { id: t.id, nom: t.nom, count: n, revenue: rev }
        }).sort(function (a, b) { return b.revenue - a.revenue })
    }

    function avgDelayByType(months) {
        var sum = {}, cnt = {}
        for (var i = 0; i < reparations.length; i++) {
            var r = reparations[i]
            if (r.statut < 4 || !inPeriod(r, months)) continue
            var a = byId(appareils, r.appareilId)
            var t = a ? a.type : "Autre"
            var days = Math.max(0.5, (deliveryDate(r).getTime() - r.dateDepot.getTime()) / 86400000)
            sum[t] = (sum[t] || 0) + days
            cnt[t] = (cnt[t] || 0) + 1
        }
        var out = []
        for (var k in sum) out.push({ label: k, value: Math.round(sum[k] / cnt[k] * 10) / 10 })
        return out.sort(function (a, b) { return b.value - a.value })
    }

    function periodSummary(months) {
        var total = 0, count = 0, invoiced = 0, delivered = 0, delaySum = 0
        for (var i = 0; i < reparations.length; i++) {
            var r = reparations[i]
            if (!inPeriod(r, months)) continue
            count++
            if (r.statut >= 3) { invoiced++; total += coutTotal(r.id) }
            if (r.statut === 4) { delivered++; delaySum += Math.max(0.5, (deliveryDate(r).getTime() - r.dateDepot.getTime()) / 86400000) }
        }
        return {
            revenue: total,
            count: count,
            avgCost: invoiced > 0 ? Math.round(total / invoiced / 5000) * 5000 : 0,
            avgDelay: delivered > 0 ? Math.round(delaySum / delivered * 10) / 10 : 0,
            successRate: count > 0 ? Math.round(delivered / count * 100) : 0
        }
    }

    // ── Fil d'activité et historique ────────────────────────────────────────
    function events(limit) {
        var list = []
        for (var i = 0; i < reparations.length; i++) {
            var r = reparations[i]
            var v = repairView(r)
            for (var j = 0; j < r.timeline.length; j++) {
                var e = r.timeline[j]
                var title, sub
                if (e.statut === 0) { title = "Appareil déposé"; sub = v.label + " · " + v.clientName }
                else { title = "Passée en « " + Theme.statusLabels[e.statut] + " »"; sub = v.label + " · " + v.technicienName }
                list.push({ kind: "statut", date: e.date, repId: r.id, code: v.code, statut: e.statut,
                            icon: Theme.statusIcons[e.statut], title: title, subtitle: sub })
            }
        }
        for (var k = 0; k < interventions.length; k++) {
            var it = interventions[k]
            var rep = byId(reparations, it.reparationId)
            if (!rep) continue
            var rv = repairView(rep)
            list.push({ kind: "intervention", date: it.date, repId: rep.id, code: rv.code, statut: -1, icon: "hammer",
                        title: it.description, subtitle: rv.label + " · " + Fmt.ar(it.cout), cout: it.cout })
        }
        list.sort(function (a, b) { return b.date.getTime() - a.date.getTime() })
        return limit ? list.slice(0, limit) : list
    }

    function notifications() {
        var out = []
        var late = repairViews().filter(function (v) { return v.late })
        for (var i = 0; i < Math.min(2, late.length); i++)
            out.push({ icon: "triangle-alert", kind: "danger", repId: late[i].id,
                       title: late[i].code + " en retard", text: late[i].label + " attend depuis " + late[i].age + " jours.", time: "À traiter" })
        var ready = repairViews().filter(function (v) { return v.statut === 3 })
        for (var j = 0; j < Math.min(2, ready.length); j++)
            out.push({ icon: "package-check", kind: "success", repId: ready[j].id,
                       title: ready[j].code + " prête", text: ready[j].clientName + " peut récupérer son appareil.", time: "À livrer" })
        var pending = factures().filter(function (f) { return !f.payee })
        if (pending.length > 0)
            out.push({ icon: "receipt", kind: "primary", repId: -1,
                       title: pending.length + " facture(s) en attente", text: "Montant à encaisser : " + Fmt.ar(pending.reduce(function (s, f) { return s + f.montant }, 0)) + ".", time: "Finance" })
        return out
    }

    function search(query) {
        var q = Fmt.norm(query).trim()
        if (q.length < 2) return { repairs: [], clients: [], devices: [] }
        var reps = repairViews().filter(function (v) { return v.search.indexOf(q) >= 0 }).slice(0, 5)
        var cls = clients.filter(function (c) { return Fmt.norm(c.nom + " " + c.telephone).indexOf(q) >= 0 }).slice(0, 4)
        var devs = appareils.filter(function (a) { return Fmt.norm(a.marque + " " + a.modele + " " + a.numeroSerie + " " + a.type).indexOf(q) >= 0 }).slice(0, 3)
        return { repairs: reps, clients: cls, devices: devs }
    }
}
