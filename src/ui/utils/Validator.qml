import QtQuick

QtObject {
    // Validation d'email
    function isValidEmail(email) {
        if (!email) return false
        var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        return re.test(email)
    }

    // Validation de téléphone
    function isValidPhone(phone) {
        if (!phone) return false
        var re = /^[\d\s\+\-\(\)]{10,}$/
        return re.test(phone)
    }

    // Validation de numéro de série
    function isValidSerial(serial) {
        if (!serial) return false
        return serial.length >= 5 && serial.length <= 50
    }

    // Validation de nom (non vide)
    function isValidName(name) {
        if (!name) return false
        return name.trim().length >= 2
    }

    // Validation de coût (positif)
    function isValidCost(cost) {
        if (cost === undefined || cost === null) return false
        return cost >= 0
    }
}