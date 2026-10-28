import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    property bool isDarkMode: true

    background: Rectangle {
        color: isDarkMode ? "#0a0e1a" : "#f0f4f8"
    }

    ScrollView {
        id: scrollview
        anchors.fill: parent
        anchors.margins: 32

        ColumnLayout {
            width: scrollview.availableWidth
            spacing: 24

            RowLayout {
                Layout.fillWidth: true

                Column {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Gestion des Réparations"
                        font.pixelSize: 24
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }
                    Text {
                        text: "5 réparations au total"
                        font.pixelSize: 13
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "+ Nouvelle Réparation"
                    font.pixelSize: 14
                    font.bold: true

                    background: Rectangle {
                        radius: 12
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
                spacing: 12

                Repeater {
                    model: [
                        { id: 1, panne: "Écran ne s'allume plus", appareil: "Dell XPS 15", client: "Jean Dupont", tech: "Paul Tech", date: "20/10/2026", statut: "En réparation", statutColor: "#ffaa00" },
                        { id: 2, panne: "Batterie gonflée", appareil: "Samsung S24 Ultra", client: "Marie Martin", tech: "Lucie Mobile", date: "15/10/2026", statut: "Terminé", statutColor: "#00ff88" },
                        { id: 3, panne: "Erreur RAID", appareil: "HP ProLiant DL380", client: "TechCorp SARL", tech: "Marc Réseau", date: "18/10/2026", statut: "Diagnostiqué", statutColor: "#00d4ff" },
                        { id: 4, panne: "Écran fissuré", appareil: "iPad Pro 12.9", client: "Jean Dupont", tech: "Lucie Mobile", date: "25/10/2026", statut: "Reçu", statutColor: "#64748b" },
                        { id: 5, panne: "Clavier bloqué", appareil: "Dell XPS 15", client: "Jean Dupont", tech: "Paul Tech", date: "10/10/2026", statut: "Livré", statutColor: "#a855f7" }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 96
                        radius: 14
                        color: isDarkMode ? "#151f2e" : "#ffffff"
                        border.width: 1
                        border.color: isDarkMode ? "#263447" : "#e2e8f0"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            anchors.topMargin: 18
                            anchors.bottomMargin: 18
                            spacing: 16

                            Rectangle {
                                Layout.preferredWidth: 52
                                Layout.preferredHeight: 52
                                radius: 12
                                color: Qt.rgba(0, 212, 255, 0.15)

                                Text {
                                    anchors.centerIn: parent
                                    text: "#" + modelData.id
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: "#00d4ff"
                                }
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: modelData.panne
                                    font.pixelSize: 15
                                    font.bold: true
                                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: modelData.appareil + " • " + modelData.client
                                    font.pixelSize: 12
                                    color: isDarkMode ? "#94a3b8" : "#64748b"
                                }
                            }

                            Column {
                                Layout.preferredWidth: 120
                                spacing: 2

                                Text {
                                    text: "Technicien"
                                    font.pixelSize: 10
                                    color: isDarkMode ? "#64748b" : "#94a3b8"
                                }
                                Text {
                                    text: modelData.tech
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                }
                            }

                            Column {
                                Layout.preferredWidth: 100
                                spacing: 2

                                Text {
                                    text: "Date"
                                    font.pixelSize: 10
                                    color: isDarkMode ? "#64748b" : "#94a3b8"
                                }
                                Text {
                                    text: modelData.date
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 120
                                Layout.preferredHeight: 32
                                radius: 16
                                color: Qt.rgba(
                                    parseInt(modelData.statutColor.slice(1, 3), 16) / 255,
                                    parseInt(modelData.statutColor.slice(3, 5), 16) / 255,
                                    parseInt(modelData.statutColor.slice(5, 7), 16) / 255,
                                    0.15
                                )

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.statut
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: modelData.statutColor
                                }
                            }

                            Button {
                                text: "Voir →"
                                flat: true
                                font.pixelSize: 13
                                font.bold: true
                                contentItem: Text {
                                    text: parent.text
                                    color: "#00d4ff"
                                    font: parent.font
                                }
                            }
                        }

                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 200 } }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.scale = 1.01
                            onExited: parent.scale = 1.0
                        }
                    }
                }
            }
        }
    }
}