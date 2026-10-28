import QtQuick

QtObject {
    property bool isDarkMode: true

    // Couleurs
    readonly property var colors: ({
        "dark": {
            "backgroundPrimary": "#0a0e1a",
            "backgroundSecondary": "#111827",
            "backgroundTertiary": "#1e293b",
            "accentPrimary": "#00d4ff",
            "accentSecondary": "#00ff88",
            "accentWarning": "#ffaa00",
            "accentDanger": "#ff3366",
            "accentPurple": "#a855f7",
            "textPrimary": "#f1f5f9",
            "textSecondary": "#94a3b8",
            "textMuted": "#64748b",
            "glassBackground": "rgba(30, 41, 59, 0.7)",
            "glassBorder": "rgba(0, 212, 255, 0.2)"
        },
        "light": {
            "backgroundPrimary": "#f0f4f8",
            "backgroundSecondary": "#ffffff",
            "backgroundTertiary": "#e2e8f0",
            "accentPrimary": "#0066ff",
            "accentSecondary": "#00cc66",
            "accentWarning": "#ff8800",
            "accentDanger": "#e63946",
            "accentPurple": "#7c3aed",
            "textPrimary": "#0f172a",
            "textSecondary": "#475569",
            "textMuted": "#94a3b8",
            "glassBackground": "rgba(255, 255, 255, 0.8)",
            "glassBorder": "rgba(0, 102, 255, 0.15)"
        }
    })

    // Typographie
    readonly property var fonts: ({
        "family": "Segoe UI",
        "monoFamily": "Consolas",
        "sizes": {
            "xs": 10,
            "sm": 12,
            "md": 14,
            "lg": 16,
            "xl": 20,
            "xxl": 24,
            "xxxl": 32
        }
    })

    // Espacements
    readonly property var spacing: ({
        "xs": 4,
        "sm": 8,
        "md": 16,
        "lg": 24,
        "xl": 32,
        "xxl": 48
    })

    // Rayons de bordure
    readonly property var radius: ({
        "sm": 6,
        "md": 12,
        "lg": 16,
        "xl": 24,
        "full": 9999
    })

    // Ombres
    readonly property var shadows: ({
        "sm": "0 1px 2px rgba(0,0,0,0.1)",
        "md": "0 4px 6px rgba(0,0,0,0.1)",
        "lg": "0 10px 15px rgba(0,0,0,0.1)",
        "xl": "0 20px 25px rgba(0,0,0,0.15)"
    })

    // Animations
    readonly property var animations: ({
        "duration": {
            "fast": 150,
            "normal": 300,
            "slow": 500
        },
        "easing": {
            "in": "Easing.InCubic",
            "out": "Easing.OutCubic",
            "inOut": "Easing.InOutCubic"
        }
    })
}