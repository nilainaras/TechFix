import QtQuick

QtObject {
    // Statuts de réparation
    readonly property var STATUTS: [
        "Reçu",
        "Diagnostiqué",
        "En réparation",
        "Terminé",
        "Livré"
    ]

    // Couleurs des statuts
    readonly property var STATUT_COLORS: ({
        "Reçu": "#64748b",
        "Diagnostiqué": "#00d4ff",
        "En réparation": "#ffaa00",
        "Terminé": "#00ff88",
        "Livré": "#a855f7"
    })

    // Icônes des statuts
    readonly property var STATUT_ICONS: ({
        "Reçu": "📥",
        "Diagnostiqué": "🔍",
        "En réparation": "🔧",
        "Terminé": "✅",
        "Livré": "🚚"
    })

    // Types d'appareils
    readonly property var APPAREIL_TYPES: [
        "Ordinateur portable",
        "Ordinateur de bureau",
        "Smartphone",
        "Tablette",
        "Serveur",
        "Imprimante",
        "Autre"
    ]

    // Types d'intervention
    readonly property var INTERVENTION_TYPES: [
        "Pièce",
        "Main d'œuvre",
        "Diagnostic",
        "Autre"
    ]

    // Délai d'alerte (jours)
    readonly property int DELAI_ALERTE_JOURS: 7

    // Devise
    readonly property string DEVISE: "€"

    // Nom de l'application
    readonly property string APP_NAME: "TechFix"
    readonly property string APP_VERSION: "1.0.0"
}