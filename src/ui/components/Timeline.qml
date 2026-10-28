import QtQuick
import QtQuick.Controls

Item {
    id: root

    property var steps: []  // [{label, date, description, done, current}]
    property bool isDarkMode: true

    implicitWidth: 400
    implicitHeight: steps.length * 90

    Repeater {
        model: root.steps
        delegate: Item {
            width: root.width
            height: 80

            property bool isDone: modelData.done || false
            property bool isCurrent: modelData.current || false

            // Ligne verticale
            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.bottom: parent.bottom
                width: 2
                color: {
                    if (isDone) return "#00ff88"
                    if (isCurrent) return "#00d4ff"
                    return isDarkMode ? "#334155" : "#e2e8f0"
                }
            }

            // Point
            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -10
                width: 20
                height: 20
                radius: 10

                color: {
                    if (isDone) return "#00ff88"
                    if (isCurrent) return "#00d4ff"
                    return isDarkMode ? "#334155" : "#e2e8f0"
                }

                border.width: isCurrent ? 3 : 0
                border.color: "#0a0e1a"

                // Animation pulse pour l'étape courante
                SequentialAnimation on scale {
                    running: isCurrent
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.2; duration: 800 }
                    NumberAnimation { to: 1.0; duration: 800 }
                }
            }

            // Contenu
            Column {
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.top: parent.top
                anchors.topMargin: 8
                spacing: 4

                Row {
                    spacing: 8

                    Text {
                        text: modelData.label
                        font.pixelSize: 15
                        font.bold: true
                        color: {
                            if (isDone) return "#00ff88"
                            if (isCurrent) return "#00d4ff"
                            return isDarkMode ? "#f1f5f9" : "#0f172a"
                        }
                    }

                    Text {
                        text: modelData.date || ""
                        font.pixelSize: 12
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }
                }

                Text {
                    text: modelData.description || ""
                    font.pixelSize: 12
                    color: isDarkMode ? "#94a3b8" : "#64748b"
                    wrapMode: Text.Wrap
                    width: root.width - 70
                }
            }
        }
    }
}