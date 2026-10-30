pragma Singleton
import QtQuick

// Fonctions de mise en forme (dates en français, montants en Ariary, initiales…).
// Écrites à la main pour ne pas dépendre de la langue du système.
QtObject {
    readonly property var months: ["janv.", "févr.", "mars", "avr.", "mai", "juin", "juil.", "août", "sept.", "oct.", "nov.", "déc."]
    readonly property var monthsLong: ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
    readonly property var daysLong: ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]

    function pad(n, w) {
        var s = String(Math.floor(Math.abs(n)))
        while (s.length < (w || 2))
            s = "0" + s
        return s
    }

    // 125000 → "125 000 Ar"
    function num(n) {
        var s = String(Math.round(Math.abs(n)))
        var out = ""
        for (var i = 0; i < s.length; i++) {
            if (i > 0 && (s.length - i) % 3 === 0)
                out += " "
            out += s[i]
        }
        return (n < 0 ? "-" : "") + out
    }

    function ar(n) { return num(n) + " Ar" }

    // 1 250 000 → "1,25 M" ; 350 000 → "350 k" (axes des graphiques)
    function compact(n) {
        var a = Math.abs(n)
        if (a >= 1000000) {
            var m = Math.round(a / 10000) / 100
            return String(m).replace(".", ",") + " M"
        }
        if (a >= 1000)
            return Math.round(a / 1000) + " k"
        return String(Math.round(a))
    }

    function date(d) { return d.getDate() + " " + months[d.getMonth()] + " " + d.getFullYear() }
    function dateShort(d) { return d.getDate() + " " + months[d.getMonth()] }
    function dateLong(d) {
        return daysLong[d.getDay()] + " " + d.getDate() + " " + monthsLong[d.getMonth()] + " " + d.getFullYear()
    }
    function time(d) { return pad(d.getHours()) + ":" + pad(d.getMinutes()) }
    function dateTime(d) { return dateShort(d) + " · " + time(d) }

    function startOfDay(d) {
        var x = new Date(d.getTime())
        x.setHours(0, 0, 0, 0)
        return x
    }

    function daysBetween(a, b) {
        return Math.round((startOfDay(b).getTime() - startOfDay(a).getTime()) / 86400000)
    }

    // « Aujourd'hui », « Hier », « Il y a 3 jours »
    function relativeDay(d) {
        var n = daysBetween(d, new Date())
        if (n <= 0) return "Aujourd'hui"
        if (n === 1) return "Hier"
        if (n < 7) return "Il y a " + n + " jours"
        return date(d)
    }

    function relativeTime(d) {
        var diff = Math.max(0, (new Date()).getTime() - d.getTime())
        var min = Math.floor(diff / 60000)
        if (min < 1) return "À l'instant"
        if (min < 60) return "Il y a " + min + " min"
        var h = Math.floor(min / 60)
        if (h < 24) return "Il y a " + h + " h"
        var days = daysBetween(d, new Date())
        if (days === 1) return "Hier, " + time(d)
        if (days < 7) return "Il y a " + days + " j"
        return dateShort(d)
    }

    function initials(name) {
        if (!name) return "?"
        var parts = String(name).trim().split(/\s+/)
        if (parts.length === 1) return parts[0].substring(0, 2).toUpperCase()
        return (parts[0][0] + parts[1][0]).toUpperCase()
    }

    // Teinte stable (0‑359) calculée à partir d'un texte : sert aux avatars.
    function hue(name) {
        var h = 0
        var s = String(name)
        for (var i = 0; i < s.length; i++)
            h = (h * 31 + s.charCodeAt(i)) % 360
        return h
    }

    function repairId(id) { return "R-" + pad(id, 4) }

    // Minuscules sans accents, pour la recherche.
    function norm(s) {
        var t = String(s === undefined || s === null ? "" : s).toLowerCase()
        try { t = t.normalize("NFD").replace(/[̀-ͯ]/g, "") } catch (e) {}
        return t
    }
}
