#include "db.h"

#include <QDebug>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QStringList>

#include <QHash>
#include <QtSql/QSqlRecord>

// Connexion par défaut de Qt : tous les « QSqlQuery q; » l'utilisent automatiquement.
const QString Db::CONNECTION_NAME =
    QString::fromLatin1(QSqlDatabase::defaultConnection);

Db::Db(QObject *parent)
    : QObject{parent}
{}

Db::~Db()
{
    disconnectFromDatabase();
}

bool Db::connected() const
{
    return m_connected;
}

QString Db::lastError() const
{
    return m_lastError;
}

QStringList Db::availableDrivers() const
{
    return QSqlDatabase::drivers();
}

bool Db::isDriverAvailable(const QString &driver) const
{
    return QSqlDatabase::isDriverAvailable(driver);
}

// ── Outils ──────────────────────────────────────────────────────────────────
// Exécute une requête préparée (valeurs liées : pas d'injection SQL).
// Si insertId est fourni, il reçoit l'identifiant généré par l'INSERT.
static bool ecrire(const QString &sql, const QVariantList &args = {}, QVariant *insertId = nullptr)
{
    QSqlQuery q;
    q.prepare(sql);
    for (const QVariant &a : args)
        q.addBindValue(a);
    if (!q.exec()) {
        qWarning() << "SQL :" << q.lastError().text() << "|" << sql;
        return false;
    }

    if (insertId) {
        // QODBC ne gère pas lastInsertId() : on interroge MySQL directement.
        // La 2e requête doit passer par la MÊME connexion que l'INSERT
        // (ici la connexion par défaut, celle de « QSqlQuery q; »).
        q.finish();
        QSqlQuery idQuery(QSqlDatabase::database());
        if (!idQuery.exec(QStringLiteral("SELECT LAST_INSERT_ID()")) || !idQuery.next()) {
            qWarning() << "SQL : LAST_INSERT_ID :" << idQuery.lastError().text();
            return false;
        }
        *insertId = idQuery.value(0).toInt();
    }

    return true;
}

// Lit une requête SELECT : une ligne = un objet {nomColonne: valeur} (les alias SQL donnent les clés).
static QVariantList lire(const QString &sql)
{
    QVariantList list;
    QSqlQuery q;
    if (!q.exec(sql)) {
        qWarning() << "SQL :" << q.lastError().text() << "|" << sql;
        return list;
    }
    const QSqlRecord rec = q.record();
    while (q.next()) {
        QVariantMap m;
        for (int i = 0; i < rec.count(); ++i)
            m[rec.fieldName(i)] = q.value(i);
        list << m;
    }
    return list;
}

bool Db::connecter()
{
    // Déjà connecté : ne rien refaire (connecter() peut être appelée plusieurs fois).
    if (QSqlDatabase::contains(CONNECTION_NAME)
        && QSqlDatabase::database(CONNECTION_NAME, false).isOpen()) {
        m_connected = true;
        return true;
    }

    // Paramètres lus depuis les variables d'environnement.
    const QByteArray hostEnv = qgetenv("TECHFIX_DB_HOST");
    const QByteArray nameEnv = qgetenv("TECHFIX_DB_NAME");
    const QByteArray userEnv = qgetenv("TECHFIX_DB_USER");
    const QByteArray passwordEnv = qgetenv("TECHFIX_PASSWORD");

    const QString host = hostEnv.isEmpty()
                             ? QStringLiteral("127.0.0.1")
                             : QString::fromLocal8Bit(hostEnv);

    const QString databaseName = nameEnv.isEmpty()
                                     ? QStringLiteral("atelier")
                                     : QString::fromLocal8Bit(nameEnv);

    const QString username = userEnv.isEmpty()
                                 ? QStringLiteral("root")
                                 : QString::fromLocal8Bit(userEnv);

    const QString password = QString::fromLocal8Bit(passwordEnv);

    const QByteArray driverEnv = qgetenv("TECHFIX_ODBC_DRIVER");
    const QString odbcDriver = driverEnv.isEmpty()
                                   ? QStringLiteral("MySQL ODBC 26.10 Unicode Driver")
                                   : QString::fromLocal8Bit(driverEnv);

    // Vérifier le plugin Qt avant de tenter la connexion.
    if (!QSqlDatabase::isDriverAvailable(QStringLiteral("QODBC"))) {
        m_connected = false;
        m_lastError =
            QStringLiteral(
                "Le pilote QODBC n'est pas disponible. "
                "Vérifiez le plugin qsqlodbc.dll de Qt et l'installation de MySQL Connector/ODBC (64 bits).");
        qWarning().noquote() << m_lastError;
        emit statusChanged();
        return false;
    }

    // Nettoyer une éventuelle ancienne connexion (fermée ou invalide).
    if (QSqlDatabase::contains(CONNECTION_NAME)) {
        {
            QSqlDatabase oldDb =
                QSqlDatabase::database(CONNECTION_NAME, false);
            oldDb.close();
        }
        QSqlDatabase::removeDatabase(CONNECTION_NAME);
    }

    QSqlDatabase db =
        QSqlDatabase::addDatabase(QStringLiteral("QODBC"),
                                  CONNECTION_NAME);

    // Avec QODBC, l'hôte, le port et la base sont dans la chaîne de connexion.
    db.setDatabaseName(
        QStringLiteral("DRIVER={MySQL ODBC 26.10 Unicode Driver};SERVER=%1;PORT=3306;DATABASE=%2;CHARSET=utf8mb4;")
            .arg(host, databaseName));
    db.setUserName(username);
    db.setPassword(password);

    qDebug() << "Driver utilisé :" << db.driverName();

    if (!db.open()) {
        m_lastError = db.lastError().text();
        qWarning().noquote()
            << "Échec de connexion à MySQL :" << m_lastError;

        db = QSqlDatabase();
        QSqlDatabase::removeDatabase(CONNECTION_NAME);

        m_connected = false;
        emit statusChanged();
        return false;
    }

    m_connected = true;
    m_lastError.clear();

    qInfo().noquote()
        << "Connexion MySQL réussie à la base" << databaseName;

    emit statusChanged();
    return true;
}


// ── Chargement complet ──────────────────────────────────────────────────────
QVariantMap Db::loadAll()
{
    connecter();   // ouvre la connexion si besoin (sans effet si elle est déjà ouverte)
    QVariantMap out;
    out["clients"] = lire("SELECT id_client AS id, nom, telephone FROM client ORDER BY id_client");
    out["appareils"] = lire("SELECT id_appareil AS id, client_id_client AS clientId, type, marque, modele, "
                            "numero_serie AS numeroSerie FROM appareil ORDER BY id_appareil");
    out["techniciens"] = lire("SELECT id_technicien AS id, nom, specialite FROM technicien ORDER BY id_technicien");
    out["interventions"] = lire("SELECT id_intervention AS id, reparation_id_reparation AS reparationId, description, cout, "
                                "date_intervention AS date FROM intervention ORDER BY id_intervention");

    // Réparations + leur frise (timeline = historique des statuts)
    QVariantList reps = lire("SELECT id_reparation AS id, appareil_id_appareil AS appareilId, technicien_id_technicien AS technicienId, "
                             "panne, date_depot AS dateDepot, statut FROM reparation ORDER BY id_reparation");
    QHash<int, QVariantList> timelines;
    for (const QVariant &v : lire("SELECT reparation_id_reparation AS repId, statut, date_changement AS date "
                                  "FROM historique_statut ORDER BY date_changement, id_historique")) {
        QVariantMap h = v.toMap();
        timelines[h["repId"].toInt()].append(QVariantMap{{"statut", h["statut"]}, {"date", h["date"]}});
    }
    for (QVariant &v : reps) {
        QVariantMap m = v.toMap();
        m["timeline"] = timelines.value(m["id"].toInt());
        v = m;
    }
    out["reparations"] = reps;
    return out;
}

// ── Clients ─────────────────────────────────────────────────────────────────
int Db::addClient(const QString &nom, const QString &telephone)
{
    QVariant id;
    return ecrire("INSERT INTO client (nom, telephone) VALUES (?, ?)", {nom, telephone}, &id) ? id.toInt() : -1;
}

bool Db::updateClient(int id, const QString &nom, const QString &telephone)
{
    return ecrire("UPDATE client SET nom = ?, telephone = ? WHERE id_client = ?", {nom, telephone, id});
}

bool Db::removeClient(int id)   // appareils, réparations, interventions : supprimés en cascade (clés étrangères)
{
    return ecrire("DELETE FROM client WHERE id_client = ?", {id});
}

// ── Appareils ───────────────────────────────────────────────────────────────
int Db::addAppareil(int clientId, const QString &type, const QString &marque,
                    const QString &modele, const QString &numeroSerie)
{
    QVariant id;
    return ecrire("INSERT INTO appareil (client_id_client, type, marque, modele, numero_serie) VALUES (?, ?, ?, ?, ?)",
                  {clientId, type, marque, modele, numeroSerie}, &id) ? id.toInt() : -1;
}

bool Db::updateAppareil(int id, int clientId, const QString &type, const QString &marque,
                        const QString &modele, const QString &numeroSerie)
{
    return ecrire("UPDATE appareil SET client_id_client = ?, type = ?, marque = ?, modele = ?, numero_serie = ? "
                  "WHERE id_appareil = ?", {clientId, type, marque, modele, numeroSerie, id});
}

bool Db::removeAppareil(int id)
{
    return ecrire("DELETE FROM appareil WHERE id_appareil = ?", {id});
}

// ── Techniciens ─────────────────────────────────────────────────────────────
int Db::addTechnicien(const QString &nom, const QString &specialite)
{
    QVariant id;
    return ecrire("INSERT INTO technicien (nom, specialite) VALUES (?, ?)", {nom, specialite}, &id) ? id.toInt() : -1;
}

bool Db::updateTechnicien(int id, const QString &nom, const QString &specialite)
{
    return ecrire("UPDATE technicien SET nom = ?, specialite = ? WHERE id_technicien = ?", {nom, specialite, id});
}

QVariantMap Db::removeTechnicien(int id)
{
    // ON DELETE RESTRICT : MySQL refuse si le technicien a encore des réparations
    if (!ecrire("DELETE FROM technicien WHERE id_technicien = ?", {id}))
        return QVariantMap{{"ok", false},
                           {"message", "Suppression refusée : ce technicien est rattaché à des réparations."}};
    return QVariantMap{{"ok", true}, {"message", "Technicien supprimé."}};
}

// ── Réparations ─────────────────────────────────────────────────────────────
int Db::addReparation(int appareilId, int technicienId, const QString &panne)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();   // la réparation et sa première étape « Reçu » sont créées ensemble ou pas du tout
    QVariant id;
    if (ecrire("INSERT INTO reparation (appareil_id_appareil, technicien_id_technicien, panne, date_depot, statut) "
               "VALUES (?, ?, ?, NOW(), 0)", {appareilId, technicienId, panne}, &id)
        && ecrire("INSERT INTO historique_statut (reparation_id_reparation, statut, date_changement) VALUES (?, 0, NOW())", {id})) {
        db.commit();
        return id.toInt();
    }
    db.rollback();
    return -1;
}

bool Db::updateReparation(int id, int appareilId, int technicienId, const QString &panne)
{
    return ecrire("UPDATE reparation SET appareil_id_appareil = ?, technicien_id_technicien = ?, panne = ? WHERE id_reparation = ?",
                  {appareilId, technicienId, panne, id});
}

bool Db::removeReparation(int id)   // interventions et historique
{
    return ecrire("DELETE FROM reparation WHERE id_reparation = ?", {id});
}

bool Db::advanceStatus(int repId, int nouveauStatut)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    if (ecrire("UPDATE reparation SET statut = ? WHERE id_reparation = ?", {nouveauStatut, repId})
        && ecrire("INSERT INTO historique_statut (reparation_id_reparation, statut, date_changement) VALUES (?, ?, NOW())",
                  {repId, nouveauStatut}))
        return db.commit();
    db.rollback();
    return false;
}

// ── Interventions ───────────────────────────────────────────────────────────
bool Db::addIntervention(int repId, const QString &description, int cout)
{
    return ecrire("INSERT INTO intervention (reparation_id_reparation, description, cout, date_intervention) "
                  "VALUES (?, ?, ?, NOW())", {repId, description, cout});
}

bool Db::removeIntervention(int id)
{
    return ecrire("DELETE FROM intervention WHERE id_intervention = ?", {id});
}


void Db::disconnectFromDatabase()
{
    if (QSqlDatabase::contains(CONNECTION_NAME)) {
        {
            QSqlDatabase db =
                QSqlDatabase::database(CONNECTION_NAME, false);
            db.close();
        }
        QSqlDatabase::removeDatabase(CONNECTION_NAME);
    }

    m_connected = false;
    emit statusChanged();
}