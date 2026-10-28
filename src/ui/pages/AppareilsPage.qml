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
            spacing: 22

            RowLayout {
                Layout.fillWidth: true

                Column {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Gestion des Appareils"
                        font.pixelSize: 24
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    Text {
                        text: "4 appareils enregistrés"
                        font.pixelSize: 13
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "+ Nouvel Appareil"
                    font.pixelSize: 14
                    font.bold: true

                    background: Rectangle {
                        radius: 12
                        gradient: Gradient {
                            orientation: Qt.Horizontal
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

            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 16
                columnSpacing: 16

                Repeater {
                    model: [
                        { type: "Ordinateur portable", marque: "Dell", modele: "XPS 15 9530", serial: "DL-XPS15-2024-001", client: "Jean Dupont" },
                        { type: "Smartphone", marque: "Samsung", modele: "Galaxy S24 Ultra", serial: "SM-S928B-2024-042", client: "Marie Martin" },
                        { type: "Serveur", marque: "HP", modele: "ProLiant DL380", serial: "HP-DL380-2023-156", client: "TechCorp SARL" },
                        { type: "Tablette", marque: "Apple", modele: "iPad Pro 12.9", serial: "AP-IPAD-2024-089", client: "Jean Dupont" }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        Layout.preferredWidth: 320
                        radius: 20
                        color: isDarkMode ? "#1e293b" : "#ffffff"
                        border.color: isDarkMode ? Qt.rgba(0, 212, 255, 0.15) : Qt.rgba(0, 102, 255, 0.1)
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 12

                            RowLayout {
                                Layout.fillWidth: true

                                Rectangle {
                                    Layout.preferredWidth: 56
                                    Layout.preferredHeight: 56
                                    radius: 16
                                    color: Qt.rgba(0, 212, 255, 0.15)

                                    Image {
                                        anchors.centerIn: parent
                                        source: "qrc:/assets/icons/laptop.svg"
                                        width: 28
                                        height: 28
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: modelData.marque + " " + modelData.modele
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    }

                                    Text {
                                        text: modelData.type
                                        font.pixelSize: 12
                                        color: "#00d4ff"
                                        font.bold: true
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                RowLayout {
                                    spacing: 8
                                    Image {
                                        source: "qrc:/assets/icons/users.svg"
                                        width: 14
                                        height: 14
                                    }
                                    Text {
                                        text: modelData.client
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                    }
                                }

                                RowLayout {
                                    spacing: 8
                                    Image {
                                        source: "qrc:/assets/icons/clipboard-list.svg"
                                        width: 14
                                        height: 14
                                    }
                                    Text {
                                        text: "S/N: " + modelData.serial
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                        font.family: "Consolas"
                                    }
                                }
                            }

                            Row {
                                spacing: 8

                                Button {
                                    text: "✏️ Modifier"
                                    flat: true
                                    font.pixelSize: 12
                                    contentItem: Text {
                                        text: parent.text
                                        color: "#00d4ff"
                                        font: parent.font
                                    }
                                }

                                Button {
                                    text: "🗑️ Supprimer"
                                    flat: true
                                    font.pixelSize: 12
                                    contentItem: Text {
                                        text: parent.text
                                        color: "#ff3366"
                                        font: parent.font
                                    }
                                }
                            }
                        }

                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 200 } }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.scale = 1.02
                            onExited: parent.scale = 1.0
                        }
                    }
                }
            }
        }
    }
}