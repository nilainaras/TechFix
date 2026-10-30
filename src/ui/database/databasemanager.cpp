// #include "databasemanager.h"

// DatabaseManager::DatabaseManager(QObject *parent)
//     : QObject{parent}
// {}


#include "DatabaseManager.h"

#include <QByteArray>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>

const QString DatabaseManager::CONNECTION_NAME =
    QStringLiteral("TechFixMySQLConnection");

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent)
{
}

DatabaseManager::~DatabaseManager()
{
    disconnectFromDatabase();
}

bool DatabaseManager::connected() const
{
    return m_connected;
}

QString DatabaseManager::lastError() const
{
    return m_lastError;
}

QStringList DatabaseManager::availableDrivers() const
{
    return QSqlDatabase::drivers();
}

bool DatabaseManager::isDriverAvailable(const QString &driver) const
{
    return QSqlDatabase::isDriverAvailable(driver);
}

bool DatabaseManager::connectToDatabase()
{
    // Paramètres lus depuis les variables d'environnement.

    const QByteArray hostEnv = qgetenv("TECHFIX_DB_HOST");
    const QByteArray nameEnv = qgetenv("TECHFIX_DB_NAME");
    const QByteArray userEnv = qgetenv("TECHFIX_DB_USER");
    const QByteArray passwordEnv = qgetenv("TECHFIX_PASSWORD");

    const QString host = hostEnv.isEmpty()
                             ? QStringLiteral("127.0.0.1")
                             : QString::fromLocal8Bit(hostEnv);

    const QString databaseName = nameEnv.isEmpty()
                                     ? QStringLiteral("gestiontechfixdb")
                                     : QString::fromLocal8Bit(nameEnv);

    const QString username = userEnv.isEmpty()
                                 ? QStringLiteral("techfix_app")
                                 : QString::fromLocal8Bit(userEnv);

    const QString password = QString::fromLocal8Bit(passwordEnv);

    // Vérifier le plugin Qt avant de tenter la connexion.
    if (!QSqlDatabase::isDriverAvailable(QStringLiteral("QMYSQL"))) {
        m_connected = false;
        m_lastError =
            QStringLiteral(
                "Le pilote QMYSQL n'est pas disponible. "
                "Installez ou configurez le plugin MySQL de Qt.");
        qWarning().noquote() << m_lastError;
        qDebug() << "Erreur :" << m_lastError;
        emit statusChanged();
        return false;
    }

    // Nettoyer une éventuelle ancienne connexion.
    if (QSqlDatabase::contains(CONNECTION_NAME)) {
        {
            QSqlDatabase oldDb =
                QSqlDatabase::database(CONNECTION_NAME, false);
            oldDb.close();
        }
        QSqlDatabase::removeDatabase(CONNECTION_NAME);
    }

    QSqlDatabase db =
        QSqlDatabase::addDatabase(QStringLiteral("QMYSQL"),
                                  CONNECTION_NAME);

    db.setHostName(host);
    db.setPort(3306);
    db.setDatabaseName(databaseName);
    db.setUserName(username);
    db.setPassword(password);

    if (!db.open()) {
        m_lastError = db.lastError().text();
        qWarning().noquote()
            << "Échec de connexion à MySQL :" << m_lastError;

        db = QSqlDatabase();
        QSqlDatabase::removeDatabase(CONNECTION_NAME);

        qDebug() << "Erreur :" << m_lastError;

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

void DatabaseManager::disconnectFromDatabase()
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

