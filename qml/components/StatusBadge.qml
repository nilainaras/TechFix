import QtQuick
import TechFix

// Badge de statut d'une réparation (0 = Reçu … 4 = Livré), avec sa couleur propre.
Tag {
    property int status: 0

    text: Theme.statusLabels[status]
    fg: Theme.statusColor(status)
    bg: Theme.statusSoft(status)
    dot: true
}
