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

            // Header
            RowLayout {
                Layout.fillWidth: true

                Column {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Gestion des Clients"
                        font.pixelSize: 24
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    Text {
                        text: "3 clients enregistrés"
                        font.pixelSize: 13
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "+ Nouveau Client"
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

            // Liste des clients
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 16
                columnSpacing: 16

                Repeater {
                    model: [
                        { nom: "Jean Dupont", email: "jean.dupont@email.com", tel: "06 12 34 56 78", appareils: 2 },
                        { nom: "Marie Martin", email: "marie.martin@email.com", tel: "07 98 76 54 32", appareils: 1 },
                        { nom: "TechCorp SARL", email: "contact@techcorp.fr", tel: "01 23 45 67 89", appareils: 1 }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 180
                        Layout.preferredWidth: 300
                        radius: 20
                        color: isDarkMode ? "#1e293b" : "#ffffff"
                        border.color: isDarkMode ? "rgba(0, 212, 255, 0.15)" : "rgba(0, 102, 255, 0.1)"
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
                                    radius: 28
                                    gradient: Gradient {
                                        orientation: Qt.Horizontal
                                        GradientStop { position: 0.0; color: "#00d4ff" }
                                        GradientStop { position: 1.0; color: "#00ff88" }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.nom.charAt(0)
                                        font.pixelSize: 22
                                        font.bold: true
                                        color: "#0a0e1a"
                                    }
                                }

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: modelData.nom
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    }

                                    Text {
                                        text: modelData.email
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#64748b"
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Row {
                                    spacing: 6
                                    Image {
                                        source: "qrc:/assets/icons/phone.svg"
                                        width: 14
                                        height: 14
                                    }
                                    Text {
                                        text: modelData.tel
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                    }
                                }

                                Row {
                                    spacing: 6
                                    Image {
                                        source: "qrc:/assets/icons/laptop.svg"
                                        width: 14
                                        height: 14
                                    }
                                    Text {
                                        text: modelData.appareils + " appareils"
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                    }
                                }
                            }

                            Row {
                                spacing: 8
                                Layout.topMargin: 4

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