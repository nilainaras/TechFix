import QtQuick
import TechFix

// Texte standard de l'application. Choisir un style avec `variant` :
//   display, h1, h2, h3   → titres (police Plus Jakarta Sans)
//   body, strong, small   → texte courant (police Inter)
//   muted, caption, label → textes secondaires
Text {
    id: root

    property string variant: "body"
    readonly property bool isHeading: variant === "display" || variant === "h1" || variant === "h2" || variant === "h3"

    color: (variant === "muted" || variant === "label") ? Theme.textMuted
         : (variant === "caption") ? Theme.textSubtle
         : Theme.text

    font.family: isHeading ? Theme.fontHeading : Theme.fontBody
    font.pixelSize: {
        switch (variant) {
        case "display": return Theme.fs3xl
        case "h1": return Theme.fs2xl
        case "h2": return Theme.fsXl
        case "h3": return Theme.fsLg
        case "small": return Theme.fsMd
        case "caption": return Theme.fsSm
        case "label": return Theme.fsSm
        }
        return Theme.fsBase
    }
    font.weight: {
        switch (variant) {
        case "display": return Font.ExtraBold
        case "h1": return Font.Bold
        case "h2": return Font.Bold
        case "h3": return Font.DemiBold
        case "strong": return Font.DemiBold
        case "label": return Font.DemiBold
        }
        return Font.Normal
    }
    font.letterSpacing: variant === "label" ? 0.4 : 0

    verticalAlignment: Text.AlignVCenter
    wrapMode: Text.NoWrap
    elide: Text.ElideNone
}
