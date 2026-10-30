import QtQuick
import QtQuick.Layouts
import TechFix

// Grille responsive : le nombre de colonnes s'adapte à la largeur disponible.
// Les enfants doivent avoir Layout.fillWidth: true.
GridLayout {
    id: root

    property real minCell: 300
    property int maxColumns: 6

    Layout.fillWidth: true
    columnSpacing: 18
    rowSpacing: 18
    uniformCellWidths: true
    columns: Math.max(1, Math.min(maxColumns, Math.floor((width + columnSpacing) / (minCell + columnSpacing))))
}
