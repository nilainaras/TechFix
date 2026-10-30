.pragma library

// ─────────────────────────────────────────────────────────────────────────────
//  DemoData — génère des données fictives réalistes (Madagascar, Ariary).
//  Les dates sont relatives à aujourd'hui : le tableau de bord paraît toujours
//  « vivant ». Le générateur est déterministe (même graine = mêmes données).
//
//  Montants : toujours des multiples de 5 000 Ar (le diagnostic coûte 5 000 Ar).
//  Pour changer les prix, modifier les tableaux PANNES_* ci-dessous.
// ─────────────────────────────────────────────────────────────────────────────

var DAY = 86400000

function rng(seed) {
    var a = seed >>> 0
    return function () {
        a = (a + 0x6D2B79F5) >>> 0
        var t = a
        t = Math.imul(t ^ (t >>> 15), t | 1)
        t ^= t + Math.imul(t ^ (t >>> 7), t | 61)
        return ((t ^ (t >>> 14)) >>> 0) / 4294967296
    }
}

var CLIENT_NAMES = [
    "Rakoto Jean", "Randrianarisoa Hery", "Rasoanaivo Lalaina", "Andrianaivo Tahina",
    "Ravelonarivo Miora", "Razafindrakoto Faly", "Rabemananjara Toky", "Rakotomalala Fanja",
    "Ramanantsoa Nirina", "Randriamampionona Vola", "Razanamahefa Haja", "Rasolofonirina Mialy",
    "Andriamanalina Tsiory", "Ratsimbazafy Njaka", "Rakotonirina Soa", "Raharimalala Zo",
    "Rasamoelina Aina", "Ravoavy Sitraka", "Randrianasolo Feno", "Razafimahatratra Kanto",
    "Rakotoarisoa Mamy", "Rabarison Tiana", "Andrianjafy Fidy", "Ravaoarisoa Lova",
    "Rafanomezantsoa Anja", "Ramaroson Hanitra", "Randriambololona Dina", "Rakotovao Seheno",
    "Raveloson Mirana", "Andriantsoa Rado",
    "Collège Saint-Joseph", "Pharmacie Tsiky", "Cabinet Ravo & Associés"
]

var TECHNICIANS = [
    { nom: "Rakotoarivelo Hasina", specialite: "Matériel & soudure" },
    { nom: "Randrianantenaina Mickaël", specialite: "Écrans & smartphones" },
    { nom: "Rasoloarimanana Lanto", specialite: "Logiciel & systèmes" },
    { nom: "Ramiaramanana Fenitra", specialite: "Cartes mères & composants" },
    { nom: "Andrianirina Safidy", specialite: "Données & sauvegardes" },
    { nom: "Rakotozafy Voahirana", specialite: "Tablettes & smartphones" }
]

// type d'appareil, groupe (pc / mobile), poids de tirage, marques → modèles
var DEVICES = [
    { type: "Ordinateur portable", groupe: "pc", poids: 38, marques: [
        ["HP", ["Pavilion 15", "ProBook 450 G8", "250 G8", "EliteBook 840"]],
        ["Dell", ["Latitude 5420", "Inspiron 15 3520", "Vostro 3510"]],
        ["Lenovo", ["ThinkPad T480", "IdeaPad 3", "ThinkPad E14"]],
        ["Asus", ["VivoBook 15", "TUF Gaming F15", "ZenBook 14"]],
        ["Acer", ["Aspire 5", "Swift 3"]] ] },
    { type: "Ordinateur de bureau", groupe: "pc", poids: 10, marques: [
        ["HP", ["ProDesk 400 G7", "Pavilion TP01"]],
        ["Dell", ["OptiPlex 3080", "Vostro 3888"]],
        ["Lenovo", ["ThinkCentre M70s"]] ] },
    { type: "Smartphone", groupe: "mobile", poids: 42, marques: [
        ["Samsung", ["Galaxy A14", "Galaxy A34", "Galaxy S21"]],
        ["Tecno", ["Spark 10", "Camon 19", "Pova 4"]],
        ["Infinix", ["Hot 30", "Note 12", "Smart 7"]],
        ["Xiaomi", ["Redmi Note 11", "Redmi 12"]],
        ["Apple", ["iPhone 11", "iPhone 12"]],
        ["Huawei", ["Y9 Prime"]] ] },
    { type: "Tablette", groupe: "mobile", poids: 10, marques: [
        ["Samsung", ["Galaxy Tab A8"]],
        ["Apple", ["iPad 9e génération"]],
        ["Lenovo", ["Tab M10"]] ] }
]

// panne → interventions plausibles [description, coût en Ar]
var PANNES_PC = [
    ["Ne s'allume plus", [["Réparation du connecteur de charge", 40000], ["Remplacement de la batterie", 85000]]],
    ["Écran noir au démarrage", [["Remplacement de l'écran", 180000], ["Nettoyage des contacts mémoire RAM", 15000]]],
    ["Surchauffe et extinction brutale", [["Nettoyage interne et pâte thermique", 20000], ["Remplacement du ventilateur", 35000]]],
    ["Système très lent, virus suspectés", [["Suppression de virus et optimisation", 15000], ["Remplacement du disque par un SSD 256 Go", 95000], ["Extension mémoire RAM 8 Go", 70000]]],
    ["Disque dur défectueux", [["Remplacement du disque par un SSD 256 Go", 95000], ["Formatage et réinstallation de Windows", 30000]]],
    ["Bruit anormal du ventilateur", [["Remplacement du ventilateur", 35000], ["Nettoyage interne et pâte thermique", 20000]]],
    ["Clavier partiellement défaillant", [["Remplacement du clavier", 60000]]],
    ["La batterie ne tient plus la charge", [["Remplacement de la batterie", 85000]]],
    ["Windows bloqué au démarrage", [["Sauvegarde des données", 10000], ["Formatage et réinstallation de Windows", 30000]]],
    ["Charnière cassée", [["Réparation de la charnière", 45000]]]
]

var PANNES_MOBILE = [
    ["Écran cassé", [["Remplacement de l'écran", 120000]]],
    ["Ne charge plus", [["Remplacement du connecteur de charge", 30000], ["Remplacement de la batterie", 50000]]],
    ["La batterie se vide trop vite", [["Remplacement de la batterie", 50000]]],
    ["Dégât des eaux", [["Désoxydation après dégât des eaux", 40000], ["Remplacement de la batterie", 50000]]],
    ["Bloqué sur le logo au démarrage", [["Sauvegarde des données", 10000], ["Réinstallation du système (flash)", 20000]]],
    ["Caméra arrière défaillante", [["Remplacement du module caméra", 45000]]],
    ["Haut-parleur sans son", [["Remplacement du haut-parleur", 25000]]],
    ["Écran tactile qui ne répond plus", [["Remplacement de la vitre tactile", 65000], ["Réinstallation du système (flash)", 20000]]]
]

function startOfDay(d) {
    var x = new Date(d.getTime())
    x.setHours(0, 0, 0, 0)
    return x
}

function pick(r, list) { return list[Math.floor(r() * list.length)] }

function weighted(r, list) {
    var total = 0
    for (var i = 0; i < list.length; i++) total += list[i].poids
    var x = r() * total
    for (var j = 0; j < list.length; j++) {
        x -= list[j].poids
        if (x <= 0) return list[j]
    }
    return list[list.length - 1]
}

function phone(r) {
    var pre = pick(r, ["032", "033", "034", "034", "038"])
    function d(n) { var s = ""; for (var i = 0; i < n; i++) s += Math.floor(r() * 10); return s }
    return pre + " " + d(2) + " " + d(3) + " " + d(2)
}

function serial(r) {
    var chars = "ABCDEFGHJKLMNPQRSTUVWXYZ0123456789"
    var s = ""
    for (var i = 0; i < 10; i++) s += chars[Math.floor(r() * chars.length)]
    return s
}

function build() {
    var r = rng(20261026)
    var now = new Date()
    var today = startOfDay(now)

    // ── Clients ─────────────────────────────────────────────────────────────
    var clients = []
    for (var c = 0; c < CLIENT_NAMES.length; c++)
        clients.push({ id: c + 1, nom: CLIENT_NAMES[c], telephone: phone(r) })

    // ── Techniciens ─────────────────────────────────────────────────────────
    var techniciens = []
    for (var t = 0; t < TECHNICIANS.length; t++)
        techniciens.push({ id: t + 1, nom: TECHNICIANS[t].nom, specialite: TECHNICIANS[t].specialite })

    // ── Appareils (1 à 3 par client) ────────────────────────────────────────
    var appareils = []
    for (var k = 0; k < clients.length; k++) {
        var n = k >= 30 ? 3 : (r() < 0.62 ? 1 : (r() < 0.9 ? 2 : 3))
        for (var q = 0; q < n; q++) {
            var dev = weighted(r, DEVICES)
            var mq = pick(r, dev.marques)
            appareils.push({
                id: appareils.length + 1,
                clientId: clients[k].id,
                type: dev.type,
                marque: mq[0],
                modele: pick(r, mq[1]),
                numeroSerie: serial(r)
            })
        }
    }

    function groupOf(typeName) {
        for (var i = 0; i < DEVICES.length; i++)
            if (DEVICES[i].type === typeName) return DEVICES[i].groupe
        return "pc"
    }

    // ── Réparations : 96 dossiers répartis sur ~12 mois ─────────────────────
    var N = 96
    var plan = []
    for (var i = 0; i < N - 7; i++)
        plan.push({ age: Math.floor(Math.pow(r(), 1.5) * 355), max: -1 })
    // dossiers « scénarios » : 4 réparations en retard et 3 appareils prêts à être récupérés
    var lateAges = [9, 11, 14, 18]
    for (var li = 0; li < lateAges.length; li++)
        plan.push({ age: lateAges[li], max: li % 2 === 0 ? 1 : 2 })      // bloqué en diagnostic / réparation
    var readyAges = [4, 6, 9]
    for (var ra = 0; ra < readyAges.length; ra++)
        plan.push({ age: readyAges[ra], max: 3 })                        // terminé, pas encore livré
    plan.sort(function (a, b) { return b.age - a.age })                  // anciens d'abord → ids croissants
    var ages = plan.map(function (p) { return p.age })
    var scenario = {}
    for (var pi = 0; pi < plan.length; pi++)
        if (plan[pi].max >= 0) scenario[pi] = plan[pi].max

    var reparations = []
    var interventions = []

    for (var ri = 0; ri < N; ri++) {
        var ap = appareils[Math.floor(r() * appareils.length)]
        var grp = groupOf(ap.type)
        var panneEntry = pick(r, grp === "pc" ? PANNES_PC : PANNES_MOBILE)

        // technicien : affinité selon le type d'appareil
        var tid
        if (grp === "mobile") tid = pick(r, [2, 2, 6, 6, 1, 4])
        else tid = pick(r, [1, 3, 3, 4, 5, 1])

        // jours (entiers) écoulés entre les étapes
        var steps = [0, Math.floor(r() * 2), 1 + Math.floor(r() * 3), 1 + Math.floor(r() * 6), Math.floor(r() * 4)]
        var dayOffset = ages[ri]
        var timeline = []
        var lastHour = 7
        var lastDay = -1
        for (var s = 0; s < 5; s++) {
            dayOffset -= steps[s]
            if (dayOffset < 0) break
            var hour
            if (dayOffset === lastDay) hour = Math.min(18, lastHour + 1 + Math.floor(r() * 2))
            else hour = 8 + Math.floor(r() * 9)
            var dt = new Date(today.getTime() - dayOffset * DAY)
            dt.setHours(hour, Math.floor(r() * 60), 0, 0)
            if (dt.getTime() > now.getTime()) {
                if (s === 0) dt = new Date(now.getTime() - (20 + Math.floor(r() * 70)) * 60000)
                else break
            }
            timeline.push({ statut: s, date: dt })
            lastHour = dt.getHours()
            lastDay = dayOffset
            if (scenario[ri] !== undefined && s >= scenario[ri]) break
        }

        var status = timeline.length - 1
        var rep = {
            id: ri + 1,
            appareilId: ap.id,
            technicienId: tid,
            panne: panneEntry[0],
            dateDepot: timeline[0].date,
            statut: status,
            timeline: timeline
        }
        reparations.push(rep)

        // ── Interventions ───────────────────────────────────────────────────
        if (status >= 1) {
            interventions.push({ id: interventions.length + 1, reparationId: rep.id,
                                 description: "Diagnostic complet", cout: 5000, date: timeline[1].date })
        }
        if (status >= 2) {
            var items = panneEntry[1]
            var howMany = status === 2 ? 1 : Math.min(items.length, 1 + Math.floor(r() * 2))
            var t2 = timeline[2].date.getTime()
            var tEnd = status >= 3 ? timeline[3].date.getTime() : now.getTime()
            for (var ii = 0; ii < howMany; ii++) {
                var span = Math.max(60000, tEnd - t2)
                var when = new Date(t2 + span * (0.15 + 0.6 * r()))
                if (when.getTime() > now.getTime()) when = new Date(now.getTime() - 60000)
                interventions.push({ id: interventions.length + 1, reparationId: rep.id,
                                     description: items[ii][0], cout: items[ii][1], date: when })
            }
        }
    }

    return { clients: clients, appareils: appareils, techniciens: techniciens,
             reparations: reparations, interventions: interventions }
}
