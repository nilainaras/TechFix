import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../viewmodels"
import "../components"

Page {
    id: root

    property bool isDarkMode: true
    property int reparationId: 0

    background: Rectangle {
        color: isDarkMode ? "#0a0e1a" : "#f0f4f8"
    }

    ReparationViewModel {
        id: reparationVM
    }

    InterventionViewModel {
        id: interventionVM
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // Header avec retour
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "← Retour"
                flat: true
                font.pixelSize: 14
                contentItem: Text {
                    text: parent.text
                    color: "#00d4ff"
                    font: parent.font
                }
                onClicked: console.log("Retour")
            }

            Column {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "Réparation #" + root.reparationId
                    font.pixelSize: 24
                    font.bold: true
                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                }

                Text {
                    text: "Détails et suivi de la réparation"
                    font.pixelSize: 13
                    color: isDarkMode ? "#94a3b8" : "#64748b"
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                width: parent.width
                spacing: 20

                // Carte principale
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    radius: 16
                    color: isDarkMode ? "#1e293b" : "#ffffff"
                    border.color: isDarkMode ? "#334155" : "#e2e8f0"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16

                        RowLayout {
                            Layout.fillWidth: true

                            Column {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    text: " Dell XPS 15 9530"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                }

                                Text {
                                    text: " Jean Dupont • 📞 06 12 34 56 78"
                                    font.pixelSize: 13
                                    color: isDarkMode ? "#94a3b8" : "#64748b"
                                }

                                Text {
                                    text: "Écran ne s'allume plus, possible problème de dalle LCD"
                                    font.pixelSize: 13
                                    color: isDarkMode ? "#94a3b8" : "#475569"
                                    wrapMode: Text.Wrap
                                    Layout.preferredWidth: 500
                                }
                            }

                            Column {
                                spacing: 8
                                Layout.alignment: Qt.AlignRight

                                StatusBadge {
                                    status: "En réparation"
                                    isDarkMode: root.isDarkMode
                                    Layout.alignment: Qt.AlignRight
                                }

                                Text {
                                    text: "👷 Paul Tech"
                                    font.pixelSize: 13
                                    color: isDarkMode ? "#94a3b8" : "#64748b"
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 24

                            Column {
                                spacing: 4

                                Text {
                                    text: "Date dépôt"
                                    font.pixelSize: 11
                                    color: isDarkMode ? "#64748b" : "#94a3b8"
                                }

                                Text {
                                    text: "20 oct 2026"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    font.family: "Consolas"
                                }
                            }

                            Column {
                                spacing: 4

                                Text {
                                    text: "Coût total"
                                    font.pixelSize: 11
                                    color: isDarkMode ? "#64748b" : "#94a3b8"
                                }

                                Text {
                                    text: "225.00 €"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: "#00ff88"
                                    font.family: "Consolas"
                                }
                            }
                        }
                    }
                }

                // Timeline
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 320
                    radius: 16
                    color: isDarkMode ? "#1e293b" : "#ffffff"
                    border.color: isDarkMode ? "#334155" : "#e2e8f0"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16

                        Text {
                            text: " Timeline des étapes"
                            font.pixelSize: 18
                            font.bold: true
                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                        }

                        Timeline {
                            Layout.fillWidth: true
                            isDarkMode: root.isDarkMode
                            steps: [
                                { label: "Reçu", date: "20 oct 2026 14:30", description: "Appareil reçu à l'atelier", done: true, current: false },
                                { label: "Diagnostiqué", date: "21 oct 2026 10:15", description: "Dalle LCD HS, remplacement nécessaire", done: true, current: false },
                                { label: "En réparation", date: "22 oct 2026 09:00", description: "Commande pièce en cours", done: false, current: true },
                                { label: "Terminé", date: "", description: "", done: false, current: false },
                                { label: "Livré", date: "", description: "", done: false, current: false }
                            ]
                        }
                    }
                }

                // Interventions
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 250
                    radius: 16
                    color: isDarkMode ? "#1e293b" : "#ffffff"
                    border.color: isDarkMode ? "#334155" : "#e2e8f0"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: "🔧 Interventions (2)"
                                font.pixelSize: 18
                                font.bold: true
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                            }

                            Item { Layout.fillWidth: true }

                            Button {
                                text: "+ Ajouter intervention"
                                font.pixelSize: 13
                                font.bold: true

                                background: Rectangle {
                                    radius: 8
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position: 0.0; color: "#00d4ff" }
                                        GradientStop { position: 1.0; color: "#00ff88" }
                                    }
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: "#0a0e1a"
                                    font: parent.font
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Repeater {
                                model: [
                                    { type: "Pièce", desc: "Remplacement dalle LCD 4K", cout: 180.00, date: "22 oct" },
                                    { type: "Main d'œuvre", desc: "Démontage et remontage", cout: 45.00, date: "22 oct" }
                                ]

                                delegate: RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 16

                                    Rectangle {
                                        Layout.preferredWidth: 40
                                        Layout.preferredHeight: 40
                                        radius: 10
                                        color: isDarkMode ? "rgba(0, 212, 255, 0.15)" : "rgba(0, 102, 255, 0.1)"

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.type === "Pièce" ? "🔩" : "🔧"
                                            font.pixelSize: 18
                                        }
                                    }

                                    Column {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        Text {
                                            text: modelData.desc
                                            font.pixelSize: 14
                                            font.bold: true
                                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                        }

                                        Text {
                                            text: modelData.type + " • " + modelData.date
                                            font.pixelSize: 11
                                            color: isDarkMode ? "#94a3b8" : "#64748b"
                                        }
                                    }

                                    Text {
                                        text: modelData.cout.toFixed(2) + " €"
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "#00ff88"
                                        font.family: "Consolas"
                                    }
                                }
                            }
                        }
                    }
                }

                // Actions
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Button {
                        text: "🗑️ Supprimer"
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: 10
                            color: "#ff3366"
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "#ffffff"
                            font: parent.font
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    Button {
                        text: "✏️ Modifier"
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: 10
                            color: isDarkMode ? "#1e293b" : "#f1f5f9"
                            border.color: isDarkMode ? "#334155" : "#e2e8f0"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                            font: parent.font
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Button {
                        text: "✅ Marquer comme Terminé →"
                        font.pixelSize: 14
                        font.bold: true

                        background: Rectangle {
                            radius: 10
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: "#00d4ff" }
                                GradientStop { position: 1.0; color: "#00ff88" }
                            }
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "#0a0e1a"
                            font: parent.font
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}