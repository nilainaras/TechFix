import QtQuick

QtObject {
    // Polices principales
    readonly property string fontFamily: "Segoe UI"
    readonly property string monoFontFamily: "Consolas"

    // Tailles de police
    readonly property int sizeXs: 10
    readonly property int sizeSm: 12
    readonly property int sizeMd: 14
    readonly property int sizeLg: 16
    readonly property int sizeXl: 20
    readonly property int sizeXxl: 24
    readonly property int sizeXxxl: 32

    // Poids
    readonly property int weightRegular: 400
    readonly property int weightMedium: 500
    readonly property int weightSemiBold: 600
    readonly property int weightBold: 700
}