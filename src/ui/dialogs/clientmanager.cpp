#include "clientmanager.h"

// ClientManager::ClientManager(QObject *parent)
//     : QObject{parent}
// {}

#include <QDebug>

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantMap>

static const QString CONNECTION_NAME =
    "TechFixMySQLConnection";

ClientManager::ClientManager(QObject *parent)
    : QObject(parent)
{
}

QVariantList ClientManager::clients() const
{
    return m_clients;
}

bool ClientManager::loadClients()
{
    QSqlDatabase db =
        QSqlDatabase::database(CONNECTION_NAME);

    if (!db.isOpen()) {
        emit erreur("La base MySQL n'est pas connectée.");
        return false;
    }

    QSqlQuery query(db);

    if (!query.exec(
            "SELECT id_client, nom, telephone "
            "FROM client ORDER BY id_client DESC")) {
        emit erreur(query.lastError().text());
        return false;
    }

    QVariantList liste;

    while (query.next()) {
        QVariantMap client;
        client["id_client"] = query.value(0);
        client["nom"] = query.value(1);
        client["telephone"] = query.value(2);

        liste.append(client);
    }

    m_clients = liste;
    emit clientsChanged();

    return true;
}

bool ClientManager::ajouterClient(
    const QString &nom,
    const QString &telephone)
{
    if (nom.trimmed().isEmpty()) {
        emit erreur("Le nom est obligatoire.");
        return false;
    }

    QSqlDatabase db =
        QSqlDatabase::database(CONNECTION_NAME);

    if (!db.isOpen()) {
        emit erreur("MySQL n'est pas connecté.");
        return false;
    }
    else {
        qDebug()<< "connexion reussie";
    }

    QSqlQuery query(db);
    query.prepare(
        "INSERT INTO client (nom_client, tel_client) "
        "VALUES (:nom, :telephone)");

    query.bindValue(":nom", nom.trimmed());
    query.bindValue(":telephone", telephone.trimmed());

    if (!query.exec()) {
        emit erreur(query.lastError().text());
        qDebug()<< query.lastError().text();
        return false;
    }
    else {
        qDebug()<< "Ajout reusi";
    }

    return loadClients();
}

bool ClientManager::modifierClient(
    int id,
    const QString &nom,
    const QString &telephone)
{
    if (id <= 0 || nom.trimmed().isEmpty()) {
        emit erreur("Sélection ou nom de client invalide.");
        return false;
    }

    QSqlDatabase db =
        QSqlDatabase::database(CONNECTION_NAME);

    if (!db.isOpen()) {
        emit erreur("MySQL n'est pas connecté.");
        return false;
    }

    QSqlQuery query(db);
    query.prepare(
        "UPDATE client SET nom_client = :nom, "
        "tel_client = :telephone "
        "WHERE id_client = :id");

    query.bindValue(":nom", nom.trimmed());
    query.bindValue(":telephone", telephone.trimmed());
    query.bindValue(":id", id);

    if (!query.exec()) {
        emit erreur(query.lastError().text());
        return false;
    }

    if (query.numRowsAffected() == 0) {
        emit erreur("Aucune modification effectuée.");
        return false;
    }

    return loadClients();
}

bool ClientManager::supprimerClient(int id)
{
    if (id <= 0) {
        emit erreur("Client invalide.");
        return false;
    }

    QSqlDatabase db =
        QSqlDatabase::database(CONNECTION_NAME);

    if (!db.isOpen()) {
        emit erreur("MySQL n'est pas connecté.");
        return false;
    }

    QSqlQuery query(db);
    query.prepare(
        "DELETE FROM client WHERE id_client = :id");

    query.bindValue(":id", id);

    if (!query.exec()) {
        emit erreur(query.lastError().text());
        return false;
    }

    if (query.numRowsAffected() == 0) {
        emit erreur("Client introuvable.");
        return false;
    }

    return loadClients();
}