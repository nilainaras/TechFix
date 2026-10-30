import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../dialogs"

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
                        text: "Gestion des Techniciens"
                        font.pixelSize: 24
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    Text {
                        text: "3 techniciens actifs"
                        font.pixelSize: 13
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "+ Nouveau Technicien"
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
                    onClicked: {
                        newTecnicien.open()
                    }
                }
                NewTechnicienDialog{
                    id: newTecnicien
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 16
                columnSpacing: 16

                Repeater {
                    model: [
                        { nom: "Paul Tech", specialite: "Ordinateurs & Serveurs", email: "paul.tech@atelier.fr", tel: "06 11 22 33 44", actif: true },
                        { nom: "Lucie Mobile", specialite: "Smartphones & Tablettes", email: "lucie.mobile@atelier.fr", tel: "06 55 66 77 88", actif: true },
                        { nom: "Marc Réseau", specialite: "Réseau & Infrastructure", email: "marc.reseau@atelier.fr", tel: "06 99 88 77 66", actif: true }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 250
                        Layout.preferredWidth: 260
                        radius: 20
                        color: isDarkMode ? "#1e293b" : "#ffffff"
                        border.color: isDarkMode ? "rgba(0, 212, 255, 0.15)" : "rgba(0, 102, 255, 0.1)"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 25

                            RowLayout {
                                Layout.fillWidth: true

                                Rectangle {
                                    Layout.preferredWidth: 64
                                    Layout.preferredHeight: 64
                                    radius: 32
                                    gradient: Gradient {
                                        orientation: Qt.Horizontal
                                        GradientStop { position: 0.0; color: "#a855f7" }
                                        GradientStop { position: 1.0; color: "#00d4ff" }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.nom.charAt(0)
                                        font.pixelSize: 28
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

                                    Rectangle {
                                        implicitWidth: 70
                                        implicitHeight: 22
                                        radius: 11
                                        color: modelData.actif ? "rgba(0, 255, 136, 0.15)" : "rgba(255, 51, 102, 0.15)"

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.actif ? "Actif" : "Inactif"
                                            font.pixelSize: 11
                                            font.bold: true
                                            color: modelData.actif ? "#00ff88" : "#ff3366"
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6

                                Text {
                                    text: modelData.specialite
                                    font.pixelSize: 13
                                    color: "#00d4ff"
                                    font.bold: true
                                }

                                RowLayout {
                                    spacing: 6
                                    Image {
                                        source: "qrc:/assets/icons/users.svg"
                                        width: 10
                                        height: 10
                                    }
                                    Text {
                                        text: modelData.email
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                    }
                                }

                                RowLayout {
                                    spacing: 6
                                    Image {
                                        source: "qrc:/assets/icons/phone.svg"
                                        width: 10
                                        height: 10
                                    }
                                    Text {
                                        text: modelData.tel
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#475569"
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