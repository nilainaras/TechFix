#ifndef DB_H
#define DB_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>


class Db : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY statusChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY statusChanged)
    Q_PROPERTY(QStringList availableDrivers READ availableDrivers CONSTANT)
public:
    explicit Db(QObject *parent = nullptr);

    ~Db() override;

    bool connected() const;
    QString lastError() const;
    QStringList availableDrivers() const;

    // fonction a appeler au cpp.
    Q_INVOKABLE bool connecter();
    Q_INVOKABLE void disconnectFromDatabase();
    Q_INVOKABLE bool isDriverAvailable(const QString &driver) const;

    // Les 5 tableaux attendus par AppData : clients, appareils, techniciens, reparations, interventions
    Q_INVOKABLE QVariantMap loadAll();

    // Clients
    Q_INVOKABLE int  addClient(const QString &nom, const QString &telephone);
    Q_INVOKABLE bool updateClient(int id, const QString &nom, const QString &telephone);
    Q_INVOKABLE bool removeClient(int id);

    // Appareils
    Q_INVOKABLE int  addAppareil(int clientId, const QString &type, const QString &marque,
                                const QString &modele, const QString &numeroSerie);
    Q_INVOKABLE bool updateAppareil(int id, int clientId, const QString &type, const QString &marque,
                                    const QString &modele, const QString &numeroSerie);
    Q_INVOKABLE bool removeAppareil(int id);

    // Techniciens
    Q_INVOKABLE int         addTechnicien(const QString &nom, const QString &specialite);
    Q_INVOKABLE bool        updateTechnicien(int id, const QString &nom, const QString &specialite);
    Q_INVOKABLE QVariantMap removeTechnicien(int id);   // { ok, message }

    // Réparations
    Q_INVOKABLE int  addReparation(int appareilId, int technicienId, const QString &panne);
    Q_INVOKABLE bool updateReparation(int id, int appareilId, int technicienId, const QString &panne);
    Q_INVOKABLE bool removeReparation(int id);
    Q_INVOKABLE bool advanceStatus(int repId, int nouveauStatut);

    // Interventions
    Q_INVOKABLE bool addIntervention(int repId, const QString &description, int cout);
    Q_INVOKABLE bool removeIntervention(int id);

signals:
    void statusChanged();
private:
    bool m_connected = false;
    QString m_lastError;

    static const QString CONNECTION_NAME;
};

#endif // DB_H
