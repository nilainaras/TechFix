import QtQuick

QtObject {
    // Mode Sombre (Défaut)
    readonly property color backgroundPrimaryDark: "#0a0e1a"
    readonly property color backgroundSecondaryDark: "#111827"
    readonly property color backgroundTertiaryDark: "#1e293b"

    // Mode Clair
    readonly property color backgroundPrimaryLight: "#f0f4f8"
    readonly property color backgroundSecondaryLight: "#ffffff"
    readonly property color backgroundTertiaryLight: "#e2e8f0"

    // Accents Néon
    readonly property color accentPrimary: "#00d4ff"
    readonly property color accentSecondary: "#00ff88"
    readonly property color accentWarning: "#ffaa00"
    readonly property color accentDanger: "#ff3366"
    readonly property color accentPurple: "#a855f7"

    // Texte
    readonly property color textPrimary: "#f1f5f9"
    readonly property color textSecondary: "#94a3b8"
    readonly property color textMuted: "#64748b"

    // Glassmorphism
    readonly property color glassBackground: "rgba(30, 41, 59, 0.7)"
    readonly property color glassBorder: "rgba(0, 212, 255, 0.2)"

    // Statuts
    readonly property color statusRecu: "#64748b"
    readonly property color statusDiagnostique: "#00d4ff"
    readonly property color statusEnReparation: "#ffaa00"
    readonly property color statusTermine: "#00ff88"
    readonly property color statusLivré: "#a855f7"
}