import QtQuick

Rectangle {
    id: root

    property string status: "Reçu"
    property bool isDarkMode: true

    // Mapping des couleurs par statut
    readonly property var statusColors: ({
        "Reçu": "#64748b",
        "Diagnostiqué": "#00d4ff",
        "En réparation": "#ffaa00",
        "Terminé": "#00ff88",
        "Livré": "#a855f7"
    })

    readonly property var statusIcons: ({
        "Reçu": "📥",
        "Diagnostiqué": "🔍",
        "En réparation": "🔧",
        "Terminé": "✅",
        "Livré": "🚚"
    })

    implicitWidth: contentRow.implicitWidth + 20
    implicitHeight: 28
    radius: 14

    color: Qt.rgba(
        statusColor.r, statusColor.g, statusColor.b,
        isDarkMode ? 0.2 : 0.15
    )
    border.color: statusColor
    border.width: 1

    readonly property color statusColor: statusColors[status] || "#64748b"

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: statusIcons[status] || "●"
            font.pixelSize: 12
        }

        Text {
            text: root.status
            font.pixelSize: 12
            font.bold: true
            color: statusColor
            font.family: "Segoe UI"
        }
    }
}