import QtQuick

QtObject {
    // Effets de lueur (Glow)
    readonly property string glowPrimary: "0 0 20px rgba(0, 212, 255, 0.5)"
    readonly property string glowSecondary: "0 0 20px rgba(0, 255, 136, 0.5)"
    readonly property string glowWarning: "0 0 20px rgba(255, 170, 0, 0.5)"
    readonly property string glowDanger: "0 0 20px rgba(255, 51, 102, 0.5)"

    // Ombres
    readonly property string shadowSm: "0 1px 2px rgba(0,0,0,0.1)"
    readonly property string shadowMd: "0 4px 6px rgba(0,0,0,0.1)"
    readonly property string shadowLg: "0 10px 15px rgba(0,0,0,0.1)"
    readonly property string shadowXl: "0 20px 25px rgba(0,0,0,0.15)"

    // Durations d'animation
    readonly property int durationFast: 150
    readonly property int durationNormal: 300
    readonly property int durationSlow: 500
}