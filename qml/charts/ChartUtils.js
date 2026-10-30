.pragma library

// Petites fonctions utilitaires partagées par les graphiques (QML pur, sans Qt Charts).

function f(n) { return (Math.round(n * 100) / 100).toString() }

function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)) }

// Échelle « propre » : max et pas arrondis (1, 2, 2.5, 5, 10 × 10^k) pour `ticks` graduations.
function niceScale(maxValue, ticks) {
    if (!(maxValue > 0)) return { max: ticks, step: 1 }
    var raw = maxValue / ticks
    var p = Math.pow(10, Math.floor(Math.log(raw) / Math.LN10))
    var n = raw / p
    var step = (n <= 1 ? 1 : n <= 2 ? 2 : n <= 2.5 ? 2.5 : n <= 5 ? 5 : 10) * p
    if (step * ticks < maxValue) step *= 2
    return { max: step * ticks, step: step }
}

function maxOf(values) {
    var m = 0
    for (var i = 0; i < values.length; i++) m = Math.max(m, values[i])
    return m
}

// Courbe lissée (Bézier) passant par les points, sans dépassement vertical.
function smoothPath(p) {
    var n = p.length
    if (n === 0) return ""
    var d = "M" + f(p[0].x) + " " + f(p[0].y)
    for (var i = 0; i < n - 1; i++) {
        var p0 = p[Math.max(0, i - 1)], p1 = p[i], p2 = p[i + 1], p3 = p[Math.min(n - 1, i + 2)]
        var lo = Math.min(p1.y, p2.y), hi = Math.max(p1.y, p2.y)
        var c1y = clamp(p1.y + (p2.y - p0.y) / 6, lo, hi)
        var c2y = clamp(p2.y - (p3.y - p1.y) / 6, lo, hi)
        d += " C" + f(p1.x + (p2.x - p0.x) / 6) + " " + f(c1y) + " " + f(p2.x - (p3.x - p1.x) / 6) + " " + f(c2y) + " " + f(p2.x) + " " + f(p2.y)
    }
    return d
}

// Même courbe, refermée vers le bas (pour le remplissage dégradé).
function areaPath(p, baseline) {
    if (p.length === 0) return ""
    return smoothPath(p) + " L" + f(p[p.length - 1].x) + " " + f(baseline) + " L" + f(p[0].x) + " " + f(baseline) + " Z"
}
