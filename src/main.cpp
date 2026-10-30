// TechFix — point d'entrée.
// Interface uniquement : tout le contenu visuel vit dans le module QML "TechFix" (dossier qml/).
// Aucun backend pour l'instant : les données de démonstration sont dans qml/data/.

#include <QDirIterator>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSurfaceFormat>

int main(int argc, char *argv[])
{
    // Anti-crénelage (MSAA) : lisse les icônes vectorielles, les graphiques et les arrondis.
    QSurfaceFormat format;
    format.setSamples(4);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("TechFix"));
    app.setOrganizationName(QStringLiteral("TechFix"));
    app.setApplicationVersion(QStringLiteral("1.0.0"));
    app.setWindowIcon(QIcon(QStringLiteral(":/assets/logo/techfix-icon.png")));

    QQuickStyle::setStyle(QStringLiteral("Basic"));

    // Polices embarquées (Inter + Plus Jakarta Sans)
    QDirIterator fonts(QStringLiteral(":/assets/fonts"), {QStringLiteral("*.ttf")}, QDir::Files);
    while (fonts.hasNext())
        QFontDatabase::addApplicationFont(fonts.next());

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(QStringLiteral("TechFix"), QStringLiteral("Main"));

    return app.exec();
}
