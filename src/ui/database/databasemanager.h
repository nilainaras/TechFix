// #ifndef DATABASEMANAGER_H
// #define DATABASEMANAGER_H

// #include <QObject>
// #include <QString>
// #include <QStringList>

// class DatabaseManager : public QObject
// {
//     Q_OBJECT

//     Q_PROPERTY(bool connected READ connected NOTIFY statusChanged)
//     Q_PROPERTY(QString lastError READ lastError NOTIFY statusChanged)
//     Q_PROPERTY(QStringList avaliableDrivers READ avaliableDrivers  NOTIFY statusChanged)
// public:
//     explicit DatabaseManager(QObject *parent = nullptr);

// signals:
// };

// #endif // DATABASEMANAGER_H



#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QString>
#include <QStringList>

class DatabaseManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool connected READ connected NOTIFY statusChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY statusChanged)
    Q_PROPERTY(QStringList availableDrivers READ availableDrivers CONSTANT)

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager() override;

    bool connected() const;
    QString lastError() const;
    QStringList availableDrivers() const;

    // fonction a appeler au cpp.
    Q_INVOKABLE bool connectToDatabase();
    Q_INVOKABLE void disconnectFromDatabase();
    Q_INVOKABLE bool isDriverAvailable(const QString &driver) const;

signals:
    void statusChanged();

private:
    bool m_connected = false;
    QString m_lastError;

    static const QString CONNECTION_NAME;
};

#endif // DATABASEMANAGER_H
