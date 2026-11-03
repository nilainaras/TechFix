# TechFix

**Application de bureau pour gérer un atelier de réparation informatique** : dépôt des appareils, suivi des réparations étape par étape, affectation des techniciens et calcul automatique des coûts.

Construite avec **Qt Quick (QML)**, Qt 6.8+, CMake et une base **MySQL**. Projet 4 de L1, réalisé en groupe.

> **État actuel : interface terminée, base de données MySQL branchée.**
> L'application lit et écrit dans une base MySQL locale (voir [Base de données](#base-de-données)). Chaque membre du groupe travaille avec sa propre copie de la base.

![Tableau de bord, thème clair](docs/screenshots/tableau-de-bord-clair.png)

<table>
  <tr>
    <td><img src="docs/screenshots/tableau-de-bord-sombre.png" alt="Tableau de bord, thème sombre"></td>
    <td><img src="docs/screenshots/detail-reparation.png" alt="Détail d'une réparation avec la frise des étapes"></td>
  </tr>
  <tr>
    <td><img src="docs/screenshots/reparations.png" alt="Liste des réparations"></td>
    <td><img src="docs/screenshots/statistiques.png" alt="Statistiques"></td>
  </tr>
</table>

## Fonctionnalités

- **Clients et appareils** : enregistrement, modification, suppression ; chaque appareil appartient à un client (type, marque, modèle, numéro de série).
- **Réparations** : dépôt d'un appareil avec sa panne et sa date, affectation d'un technicien (réaffectable en un clic), vues en cartes, en liste ou en kanban, recherche et filtres par statut.
- **Frise des étapes** : *Reçu → Diagnostic → En réparation → Terminé → Livré*, étape par étape, sans saut ni retour en arrière.
- **Interventions et coûts** : chaque intervention a une description et un coût (5 000 Ar minimum) ; le coût final de la réparation est la somme de ses interventions, calculé automatiquement.
- **Techniciens** : charge de travail et réparations en cours.
- **Factures** : générées dès qu'une réparation est terminée.
- **Tableau de bord, statistiques et historique** : indicateurs, graphiques (dessinés en QML pur), réparations en retard, journal des événements.
- **Confort** : thème clair et sombre, interface adaptée à la taille de la fenêtre, recherche globale (`Ctrl+K`), notifications, animations, formulaires en panneau latéral.

## Règles métier appliquées

- Une réparation suit les étapes dans l'ordre : pas de saut, pas de retour en arrière.
- Le coût final = somme des coûts des interventions (jamais saisi à la main).
- Pour terminer une réparation, il faut au moins une intervention.
- Les interventions ne se saisissent qu'aux étapes *Diagnostic* et *En réparation* ; une fois terminée, elles sont figées.
- Une réparation terminée ou livrée est facturée : elle ne peut plus être supprimée.
- Un client ne peut pas être supprimé s'il a des appareils ; un appareil non plus s'il a des réparations.

## Démarrer

**Prérequis** : Qt 6.8 ou plus récent (kit *MinGW 64-bit* sous Windows) avec le module *Qt Sql*, CMake 3.21+, **MySQL Server 8.0** et **MySQL Connector/ODBC 64 bits**. L'application fonctionne hors ligne (la base est locale).

1. Cloner le dépôt.
2. Créer et configurer la base de données : voir [Base de données](#base-de-données).
3. Qt Creator → *Fichier > Ouvrir un fichier ou un projet…* → choisir `CMakeLists.txt`.
4. Sélectionner le kit puis *Configurer le projet*.
5. `Ctrl+R` pour lancer.

La première compilation est la plus longue (Qt compile chaque fichier QML) ; les suivantes sont beaucoup plus rapides.

## Organisation du dossier

```
TechFix/
├── CMakeLists.txt          Module QML « TechFix », fichiers et ressources (Qt Quick + Qt Sql)
├── .gitignore
├── README.md
├── database/
│   └── atelier.sql         Script de création de la base MySQL (structure commune au groupe)
├── src/
│   ├── main.cpp            Démarre Qt, charge polices, style Basic, connecte la base, charge Main.qml
│   ├── db.h / db.cpp       Accès à la base (driver QODBC) : lecture, ajout, modification, suppression
├── assets/
│   ├── fonts/              Inter (texte) et Plus Jakarta Sans (titres), licences incluses
│   ├── logo/               Logo TechFix (SVG + PNG)
│   ├── icons/              Licence de la police d'icônes Lucide
│   └── windows/            Icône .ico de l'exécutable
├── docs/screenshots/       Captures utilisées dans ce README
└── qml/
    ├── Main.qml            Fenêtre : menu latéral + barre du haut + page courante
    ├── theme/              Theme (couleurs clair/sombre, polices), UI (navigation, toasts),
    │                       Fmt (dates, Ariary), Icons (police d'icônes)
    ├── data/               AppData (données chargées depuis la base + règles métier), Forms (formulaires)
    ├── components/         Briques réutilisables : boutons, cartes, badges, champs, frise…
    ├── charts/             Graphiques en QML pur : courbe, barres, anneau, mini-courbe
    ├── layout/             Menu latéral, barre du haut, recherche globale, notifications
    └── pages/              Une page = un fichier : Dashboard, Repairs, RepairDetail, Clients,
                            Devices, Technicians, Invoices, Stats, History, Settings, About
```

**Principe** : les pages ne contiennent que de l'affichage. Elles lisent et modifient les données uniquement via `AppData`, et passent par `UI` pour naviguer ou afficher une notification. `AppData` garde les règles métier et appelle `Db` (C++) pour lire et écrire dans la base : `load()` charge les listes au démarrage, et chaque fonction d'ajout, de modification ou de suppression écrit d'abord dans la base avant de mettre à jour l'affichage.

## Base de données

L'application utilise une base **MySQL** (nommée `atelier`) à travers le driver Qt **QODBC**. Chaque membre du groupe travaille avec **sa propre copie locale** : les données ne sont pas partagées entre les ordinateurs, seule la structure (le script `database/atelier.sql`) est commune.

### 1. Installer

| Outil | Version | Remarque |
|---|---|---|
| MySQL Server | 8.0 | MySQL Workbench est conseillé pour exécuter les scripts |
| MySQL Connector/ODBC | **64 bits** | Choisir la version « x64 », pas la version 32 bits |

MariaDB / XAMPP n'est **pas** utilisé. Si XAMPP est installé, arrêter son module MySQL pour libérer le port 3306.

### 2. Créer la base

1. Ouvrir MySQL Workbench et se connecter à l'instance locale (utilisateur `root`).
2. Ouvrir `database/atelier.sql` et l'exécuter en entier (icône éclair).
3. Vérifier : `SHOW TABLES FROM atelier;` doit afficher `appareil`, `client`, `historique_statut`, `intervention`, `reparation`, `technicien`.

Pour repartir de zéro (**efface toutes les données**) : `DROP DATABASE atelier;` puis ré-exécuter le script. Le script utilise `CREATE TABLE IF NOT EXISTS` : il ne modifie jamais des tables déjà existantes.

### 3. Créer l'utilisateur de l'application

Ne pas utiliser `root` dans l'application. Dans Workbench :

```sql
CREATE USER 'techfix'@'localhost' IDENTIFIED BY 'CHOISIR_UN_MOT_DE_PASSE';
GRANT ALL PRIVILEGES ON atelier.* TO 'techfix'@'localhost';
FLUSH PRIVILEGES;
```

Chacun choisit **son propre mot de passe**. Il ne doit jamais être écrit dans le code, dans ce README ni dans Git.

### 4. Trouver le nom du pilote ODBC

1. Ouvrir **Sources de données ODBC (64 bits)** (recherche Windows : « ODBC »). Le titre de la fenêtre doit contenir « 64 bits ».
2. Onglet **Pilotes ODBC** : repérer la ligne qui commence par `MySQL ODBC`, par exemple `MySQL ODBC 8.0 Unicode Driver`.
3. Retenir ce nom **exactement** (espaces et chiffres compris).

### 5. Variables d'environnement

Dans Qt Creator : **Projets → Exécuter → Environnement**, puis ajouter les variables suivantes. Saisir les valeurs **sans guillemets ni accolades**.

| Variable | Rôle | Valeur par défaut |
|---|---|---|
| `TECHFIX_DB_USER` | Utilisateur MySQL | `root` → mettre `techfix` |
| `TECHFIX_PASSWORD` | Mot de passe de cet utilisateur | (vide) |
| `TECHFIX_ODBC_DRIVER` | Nom exact du pilote ODBC (étape 4) | `MySQL ODBC 26.10 Unicode Driver` |
| `TECHFIX_DB_HOST` | Adresse du serveur | `127.0.0.1` |
| `TECHFIX_DB_NAME` | Nom de la base | `atelier` |

Ces variables sont enregistrées dans `CMakeLists.txt.user`, exclu de Git par `.gitignore` : chaque membre garde ses propres valeurs et aucun mot de passe n'est publié.

### 6. Lancer et vérifier

1. *Compilation > Exécuter CMake*, puis *Nettoyer* et *Recompiler* (après chaque `git pull` qui modifie `CMakeLists.txt`).
2. Lancer avec `Ctrl+R`.
3. Dans « Sortie de l'application », on doit lire : `Connexion MySQL réussie à la base atelier`.
4. Test : ajouter un client dans l'interface, fermer, relancer : le client doit toujours être présent (vérification côté base : `SELECT * FROM atelier.client;`).

### 7. Dépannage

| Message | Cause probable | Solution |
|---|---|---|
| `Data source name not found...` | Nom du pilote ODBC incorrect, ou Connector/ODBC absent ou en 32 bits | Reprendre l'étape 4, corriger `TECHFIX_ODBC_DRIVER` |
| `Access denied for user ...` | Mauvais utilisateur ou mot de passe, ou droits manquants | Revoir l'étape 3 et les variables de l'étape 5 (sans guillemets) |
| `Unknown database 'atelier'` | Script non exécuté | Étape 2 |
| `Unknown column '...' in 'field list'` | Base créée avec une ancienne version du script | `DROP DATABASE atelier;` puis ré-exécuter `database/atelier.sql` |
| `Can't connect to MySQL server` | Service MySQL arrêté, ou port 3306 occupé (XAMPP) | Démarrer le service MySQL80 ; arrêter MySQL dans XAMPP |
| `Le pilote QODBC n'est pas disponible` | Plugin `qsqlodbc.dll` absent du kit Qt | Réinstaller le kit Qt MinGW 64-bit avec ses plugins SQL |
| `undefined reference to QSqlDatabase::...` | Module Qt Sql non lié | Vérifier `Sql` dans `find_package` et `target_link_libraries` de `CMakeLists.txt` |
| `ReferenceError: Db is not defined` | Objet `Db` non exposé au QML | Vérifier l'enregistrement de `Db` (`main.cpp` ou `db.h`) |

### 8. Travail en groupe

- Le fichier `database/atelier.sql` fait foi pour la structure. Toute modification de table se fait **dans ce script**, puis est committée ; les autres membres recréent leur base avec la procédure « repartir de zéro ».
- Ne jamais committer de mot de passe, de fichier `.user` ni de dump contenant des données personnelles.
- Les données de test ne sont pas partagées : chacun saisit les siennes.

## Raccourcis

`Ctrl+K` recherche globale · `Alt+←` retour · bascule clair/sombre dans la barre du haut.

## Équipe

| | Rôle |
|---|---|
| **Nilaina** et **Voary** | Frontend (interface Qt Quick / QML) |
| **Annicha** et **Diary** | Backend (base de données) |

## Licences

- Polices **Inter** et **Plus Jakarta Sans** : SIL Open Font License 1.1.
- Icônes **Lucide** : licence ISC.

MIT
