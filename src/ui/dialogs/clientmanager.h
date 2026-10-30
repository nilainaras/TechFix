#ifndef CLIENTMANAGER_H
#define CLIENTMANAGER_H

// #include <QObject>

// class ClientManager : public QObject
// {
//     Q_OBJECT

// public:
//     explicit ClientManager(QObject *parent = nullptr);

//     Q_INVOKABLE

// signals:
// };

// #endif // CLIENTMANAGER_H


// #ifndef CLIENTVIEWMODEL_H
// #define CLIENTVIEWMODEL_H

#include <QObject>
#include <QVariantList>
#include <QString>

class ClientManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList clients
                   READ clients
                       NOTIFY clientsChanged)

public:
    explicit ClientManager(QObject *parent = nullptr);

    QVariantList clients() const;

    Q_INVOKABLE bool loadClients();
    Q_INVOKABLE bool ajouterClient(
        const QString &nom,
        const QString &telephone);
    Q_INVOKABLE bool modifierClient(
        int id,
        const QString &nom,
        const QString &telephone);
    Q_INVOKABLE bool supprimerClient(int id);

signals:
    void clientsChanged();
    void erreur(const QString &message);

private:
    QVariantList m_clients;
};

#endif