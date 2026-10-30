# TechFix — Gestion d'un atelier de réparation informatique

Interface de bureau en **Qt Quick / QML** (Qt 6.8, CMake, style Basic).
Pour l'instant : **interface uniquement**, avec des données fictives gardées en mémoire (rien n'est enregistré sur le disque, tout revient à zéro à la fermeture).

## Ouvrir le projet

1. Qt Creator → *Fichier > Ouvrir un fichier ou un projet…* → choisir `CMakeLists.txt`.
2. Sélectionner le kit **Desktop Qt 6.8.x MinGW 64-bit** puis *Configurer le projet*.
3. `Ctrl+R` pour lancer.

Qt 6.8 minimum. Aucun module supplémentaire : seuls `Qt Quick` et `Qt Quick Controls 2` sont utilisés.

## Organisation du dossier

```
TechFix/
├── CMakeLists.txt          Déclare le module QML « TechFix », ses fichiers et ses ressources
├── .gitignore              Exclut build/, CMakeLists.txt.user, fichiers générés Qt…
├── README.md
├── src/
│   └── main.cpp            Seul fichier C++ : démarre Qt, charge polices + style Basic + Main.qml
├── assets/
│   ├── fonts/              Inter (texte) et Plus Jakarta Sans (titres), licences incluses
│   ├── logo/               Logo TechFix (SVG + PNG)
│   ├── icons/              Licence de la police d'icônes Lucide
│   └── windows/            Icône .ico de l'exécutable
└── qml/
    ├── Main.qml            Fenêtre : menu latéral + barre du haut + page courante
    ├── theme/              Theme (couleurs clair/sombre, polices), UI (navigation, toasts),
    │                       Fmt (dates, Ariary), Icons (police d'icônes)
    ├── data/               AppData (données en mémoire + règles métier), Forms (formulaires),
    │                       DemoData.js (génère les fausses données)
    ├── components/         Briques réutilisables : boutons, cartes, badges, champs, Stepper (frise)…
    ├── charts/             Graphiques en QML pur : courbe, barres, anneau, mini-courbe
    ├── layout/             Sidebar, TopBar, recherche globale, notifications
    └── pages/              Une page = un fichier (Dashboard, Repairs, RepairDetail, Clients,
                            Devices, Technicians, Invoices, Stats, History, Settings, About)
```

**Principe :** les pages ne contiennent que de l'affichage. Elles lisent et modifient les données uniquement via `AppData`, et passent par `UI` pour naviguer ou afficher une notification. Le jour où le vrai backend (SQLite) arrive, on remplace `qml/data/AppData.qml` sans toucher aux pages.

## Règles métier déjà appliquées

- Statuts : **Reçu → Diagnostic → En réparation → Terminé → Livré**, sans saut d'étape ni retour en arrière.
- Le coût d'une réparation = somme de ses interventions (calculé, jamais saisi). Une intervention coûte au minimum 5 000 Ar.
- Pour terminer une réparation, il faut au moins une intervention.
- Les interventions ne se saisissent qu'aux étapes Diagnostic et En réparation ; une fois la réparation terminée, elles sont figées.
- Une réparation terminée ou livrée est facturée : elle ne peut plus être supprimée.
- Un client ne peut pas être supprimé s'il possède des appareils ; un appareil non plus s'il a des réparations.

## Brancher la base de données (plus tard)

Les données fictives sont isolées dans **un seul fichier** (`qml/data/DemoData.js`) et chargées à **un seul endroit** : la fonction `load()` de `qml/data/AppData.qml`. Les pages ne savent pas d'où viennent les données.

**Tester l'application sans aucune donnée** (états vides) : dans `AppData.qml`, passer `demoMode` à `false`.

**Retirer définitivement les données fictives :**
1. Supprimer `qml/data/DemoData.js` et sa ligne dans `CMakeLists.txt`.
2. Dans `AppData.qml`, retirer les 3 lignes marquées `// DEMO` (l'import, `demoMode`, et le `demoMode ? Demo.build() :`).
3. Dans `load()`, remplacer les 5 listes vides par le résultat des requêtes SQL.

**Ce que le backend doit fournir** (les 5 tables de votre sujet) :

| Liste dans `AppData` | Champs |
|---|---|
| `clients` | `id, nom, telephone` |
| `appareils` | `id, clientId, type, marque, modele, numeroSerie` |
| `techniciens` | `id, nom, specialite` |
| `reparations` | `id, appareilId, technicienId, panne, dateDepot, statut (0 à 4), timeline` |
| `interventions` | `id, reparationId, description, cout, date` |

Les fonctions d'écriture (`addClient`, `updateReparation`, `advanceStatus`, `addIntervention`, `removeXxx`…) sont les seuls endroits où les pages modifient les données : c'est là qu'il faudra appeler la base (INSERT, UPDATE, DELETE) avant de mettre à jour la liste en mémoire. Les règles métier (ordre des statuts, coût minimum) y sont déjà.

## Raccourcis

`Ctrl+K` recherche globale · `Alt+←` retour · bascule clair/sombre dans la barre du haut.

## Changer les données de démonstration

Les noms, pannes et prix sont dans `qml/data/DemoData.js` (montants en multiples de 5 000 Ar, minimum 5 000 Ar par intervention).

## Licences

Polices Inter et Plus Jakarta Sans : SIL OFL 1.1. Icônes Lucide : ISC. Voir `assets/`.
