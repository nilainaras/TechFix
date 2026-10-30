#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlDriver>
#include <QtSql/QSqlQuery>
#include <QDebug>

#include "src/ui/database/databasemanager.h"
#include "src/ui/dialogs/clientmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("TechFix");
    app.setOrganizationName("TechFix Corp");
    app.setApplicationVersion("1.0.0");

    // qmlRegisterType<ClientManager>("TechFix", 1, 0,"ClientManager");

    QQuickStyle::setStyle("Material");

    DatabaseManager databaseManager;
    ClientManager clientManager;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(
        "databaseManager",&databaseManager);
    engine.rootContext()->setContextProperty(
        "clientManager", &clientManager);

    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));

    qDebug() << QSqlDatabase::drivers();

    bool ok=databaseManager.connectToDatabase();
    qDebug() << "Resultat de connexion a MySQL :" << ok;


    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}