import QtQuick

QtObject {
    // Formatage de date
    function formatDate(date) {
        if (!date) return ""
        var d = new Date(date)
        var options = { year: 'numeric', month: 'long', day: 'numeric' }
        return d.toLocaleDateString(Qt.locale("fr_FR"), options)
    }

    // Formatage de date courte
    function formatDateShort(date) {
        if (!date) return ""
        var d = new Date(date)
        return d.toLocaleDateString(Qt.locale("fr_FR"), { day: '2-digit', month: '2-digit', year: 'numeric' })
    }

    // Formatage de devise
    function formatCurrency(value) {
        if (value === undefined || value === null) return "0.00 €"
        return value.toFixed(2) + " €"
    }

    // Formatage de numéro de téléphone
    function formatPhone(phone) {
        if (!phone) return ""
        return phone.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5")
    }

    // Tronquer un texte
    function truncate(text, maxLength) {
        if (!text) return ""
        if (text.length <= maxLength) return text
        return text.substring(0, maxLength) + "..."
    }

    // Calculer la différence en jours
    function daysDiff(date1, date2) {
        var d1 = new Date(date1)
        var d2 = new Date(date2)
        var diffTime = Math.abs(d2 - d1)
        return Math.ceil(diffTime / (1000 * 60 * 60 * 24))
    }
}