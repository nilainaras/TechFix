pragma Singleton
import QtQuick

// ─────────────────────────────────────────────────────────────────────────────
//  Theme — la seule source de vérité du design (couleurs, polices, tailles).
//  Changer `Theme.dark` bascule tout l'interface avec une transition douce.
//  Aucune couleur n'est du blanc ou du noir pur : tout est légèrement teinté
//  de bleu pour un rendu professionnel et reposant.
// ─────────────────────────────────────────────────────────────────────────────
QtObject {
    id: root

    // ── Mode ────────────────────────────────────────────────────────────────
    property bool dark: false
    property bool animations: true

    // ── Polices (embarquées dans assets/fonts) ──────────────────────────────
    readonly property string fontBody: "Inter"
    readonly property string fontHeading: "Plus Jakarta Sans"

    readonly property int fsXs: 11
    readonly property int fsSm: 12
    readonly property int fsMd: 13
    readonly property int fsBase: 14
    readonly property int fsLg: 16
    readonly property int fsXl: 20
    readonly property int fs2xl: 26
    readonly property int fs3xl: 32

    // ── Formes ──────────────────────────────────────────────────────────────
    readonly property int rXs: 6
    readonly property int rSm: 9
    readonly property int rMd: 12
    readonly property int rLg: 16
    readonly property int rXl: 22

    readonly property int sidebarWidth: 272
    readonly property int sidebarRail: 84
    readonly property int topbarHeight: 72

    // ── Durées d'animation (0 si les animations sont désactivées) ───────────
    readonly property int durFast: animations ? 140 : 0
    readonly property int durNormal: animations ? 240 : 0
    readonly property int durSlow: animations ? 420 : 0
    readonly property int durChart: animations ? 950 : 0
    readonly property int easeOut: Easing.OutCubic

    // ── Couleurs de surface ─────────────────────────────────────────────────
    property color bg: dark ? "#0F1623" : "#E9EEF5"
    property color surface: dark ? "#161F31" : "#F7F9FC"
    property color surfaceAlt: dark ? "#1C2740" : "#EDF1F7"
    property color surfaceHover: dark ? "#223050" : "#E3E9F2"
    property color border: dark ? "#263450" : "#D7DFEA"
    property color borderStrong: dark ? "#34466C" : "#C0CBDB"
    property color scrim: dark ? "#B0070C16" : "#8C0E1626"
    property color shadow: dark ? "#70000000" : "#331A2740"

    // ── Texte ───────────────────────────────────────────────────────────────
    property color text: dark ? "#E3E9F3" : "#1A2433"
    property color textMuted: dark ? "#A0AEC4" : "#56657A"
    property color textSubtle: dark ? "#71819B" : "#8593A8"
    property color textOnPrimary: "#F4F8FF"

    // ── Couleurs sémantiques (bleu / vert / rouge + ambre, violet, ardoise) ─
    property color primary: dark ? "#4F86EE" : "#2E6BE6"
    property color primaryHover: dark ? "#6A9BF2" : "#2559C7"
    property color primarySoft: dark ? "#1D3158" : "#DAE6FB"

    property color success: dark ? "#34C08A" : "#17996A"
    property color successSoft: dark ? "#14392E" : "#D5EFE4"

    property color danger: dark ? "#F07A83" : "#D6454F"
    property color dangerSoft: dark ? "#47222A" : "#F7DADC"

    property color warning: dark ? "#EDB04A" : "#CC8217"
    property color warningSoft: dark ? "#453417" : "#F6E7C8"

    property color violet: dark ? "#9585EA" : "#6B5BD2"
    property color violetSoft: dark ? "#2C2850" : "#E4E0F7"

    property color slate: dark ? "#8DA2C4" : "#5E7BA6"
    property color slateSoft: dark ? "#222E47" : "#DEE6F1"

    property color teal: dark ? "#37C5C5" : "#12A3A3"

    // ── Barre latérale (toujours sombre, marine) ────────────────────────────
    property color sidebar: dark ? "#0B1220" : "#14203A"
    property color sidebarHover: dark ? "#141E33" : "#1D2B4D"
    property color sidebarActive: dark ? "#1B2C52" : "#263F74"
    property color sidebarText: "#D3DCEC"
    property color sidebarMuted: "#7F8FAC"
    property color sidebarBorder: dark ? "#18233B" : "#223256"
    property color sidebarAccent: "#6C9CF7"

    // ── Dégradé de marque (bleu → vert, comme le logo) ──────────────────────
    readonly property color brandA: "#2F6BFF"
    readonly property color brandB: "#12B886"

    // ── Palette des graphiques ──────────────────────────────────────────────
    readonly property var chart: dark
        ? ["#5C93F5", "#34C08A", "#EDB04A", "#9585EA", "#F07A83", "#37C5C5"]
        : ["#2E6BE6", "#17996A", "#CC8217", "#6B5BD2", "#D6454F", "#12A3A3"]

    // ── Transitions de couleur (le changement de thème se fait en fondu) ────
    Behavior on bg { ColorAnimation { duration: root.durNormal } }
    Behavior on surface { ColorAnimation { duration: root.durNormal } }
    Behavior on surfaceAlt { ColorAnimation { duration: root.durNormal } }
    Behavior on surfaceHover { ColorAnimation { duration: root.durNormal } }
    Behavior on border { ColorAnimation { duration: root.durNormal } }
    Behavior on borderStrong { ColorAnimation { duration: root.durNormal } }
    Behavior on text { ColorAnimation { duration: root.durNormal } }
    Behavior on textMuted { ColorAnimation { duration: root.durNormal } }
    Behavior on textSubtle { ColorAnimation { duration: root.durNormal } }
    Behavior on primary { ColorAnimation { duration: root.durNormal } }
    Behavior on primarySoft { ColorAnimation { duration: root.durNormal } }
    Behavior on success { ColorAnimation { duration: root.durNormal } }
    Behavior on successSoft { ColorAnimation { duration: root.durNormal } }
    Behavior on danger { ColorAnimation { duration: root.durNormal } }
    Behavior on dangerSoft { ColorAnimation { duration: root.durNormal } }
    Behavior on warning { ColorAnimation { duration: root.durNormal } }
    Behavior on warningSoft { ColorAnimation { duration: root.durNormal } }
    Behavior on violet { ColorAnimation { duration: root.durNormal } }
    Behavior on violetSoft { ColorAnimation { duration: root.durNormal } }
    Behavior on slate { ColorAnimation { duration: root.durNormal } }
    Behavior on slateSoft { ColorAnimation { duration: root.durNormal } }
    Behavior on sidebar { ColorAnimation { duration: root.durNormal } }
    Behavior on sidebarHover { ColorAnimation { duration: root.durNormal } }
    Behavior on sidebarActive { ColorAnimation { duration: root.durNormal } }
    Behavior on sidebarBorder { ColorAnimation { duration: root.durNormal } }

    // ── Statuts d'une réparation : reçu → diagnostic → en réparation → terminé → livré
    readonly property var statusLabels: ["Reçu", "Diagnostic", "En réparation", "Terminé", "Livré"]
    readonly property var statusIcons: ["inbox", "stethoscope", "wrench", "circle-check", "package-check"]

    function statusColor(i) {
        switch (i) {
        case 0: return slate
        case 1: return warning
        case 2: return primary
        case 3: return success
        default: return violet
        }
    }

    function statusSoft(i) {
        switch (i) {
        case 0: return slateSoft
        case 1: return warningSoft
        case 2: return primarySoft
        case 3: return successSoft
        default: return violetSoft
        }
    }

    // Couleur douce d'un fond à partir d'une couleur d'accent quelconque.
    function tint(c, amount) {
        return Qt.rgba(c.r, c.g, c.b, amount === undefined ? (dark ? 0.18 : 0.14) : amount)
    }
}
