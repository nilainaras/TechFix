#include <QVariant>
#include <QDirIterator>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSurfaceFormat>
#include <QtQml>
#include <QDebug>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include "db.h"

int main(int argc, char *argv[])
{
    // Anti-crénelage (MSAA) : lisse les icônes vectorielles, les graphiques et les arrondis.
    QSurfaceFormat format;
    format.setSamples(4);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("TechFix"));
    app.setOrganizationName(QStringLiteral("TechFix"));   // utilisé par QtCore.Settings (thème mémorisé)
    app.setApplicationVersion(QStringLiteral("1.0.0"));
    app.setWindowIcon(QIcon(QStringLiteral(":/assets/logo/techfix-icon.png")));

    // Style "Basic" : le plus simple à personnaliser entièrement en QML.
    QQuickStyle::setStyle(QStringLiteral("Basic"));
    Db db;
    qmlRegisterSingletonInstance("TechFix", 1, 0, "Db", &db);


    // Polices embarquées (Inter + Plus Jakarta Sans) : rendu identique sur tous les PC.
    QDirIterator fonts(QStringLiteral(":/assets/fonts"), {QStringLiteral("*.ttf")}, QDir::Files);
    while (fonts.hasNext())
        QFontDatabase::addApplicationFont(fonts.next());

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    bool ok=db.connecter();
    qDebug() << "Resultat de la connexion a MYSQL : "<< ok;

    engine.loadFromModule(QStringLiteral("TechFix"), QStringLiteral("Main"));

    qDebug () << "Drivers :" << QSqlDatabase::drivers();

    return app.exec();
}
