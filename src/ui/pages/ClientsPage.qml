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

            // ============ HEADER ============
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

            // ============ LISTE DES CLIENTS ============
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 16
                columnSpacing: 16

                Repeater {
                    model: [
                        { nom: "Jean Dupont", email: "jean.dupont@email.com", tel: "06 12 34 56 78", appareils: 2, totalDepense: 275000, dateInscription: "15/09/2026", couleur: "#00d4ff" },
                        { nom: "Marie Martin", email: "marie.martin@email.com", tel: "07 98 76 54 32", appareils: 1, totalDepense: 95000, dateInscription: "22/08/2026", couleur: "#a855f7" },
                        { nom: "TechCorp SARL", email: "contact@techcorp.fr", tel: "01 23 45 67 89", appareils: 1, totalDepense: 165000, dateInscription: "10/07/2026", couleur: "#00ff88" }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 280
                        Layout.preferredHeight: 240
                        radius: 16
                        color: isDarkMode ? "#151f2e" : "#ffffff"
                        border.width: 1
                        border.color: Qt.rgba(0, 212, 255, 0.2)

                        // Barre verticale style sidebar
                        Rectangle {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: 4
                            height: parent.height - 80
                            radius: 2
                            color: modelData.couleur
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 24
                            anchors.rightMargin: 20
                            anchors.topMargin: 20
                            anchors.bottomMargin: 20
                            spacing: 12

                            // Header : Avatar + Nom + Email
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Rectangle {
                                    Layout.preferredWidth: 52
                                    Layout.preferredHeight: 52
                                    radius: 26
                                    color: Qt.rgba(
                                        parseInt(modelData.couleur.slice(1, 3), 16) / 255,
                                        parseInt(modelData.couleur.slice(3, 5), 16) / 255,
                                        parseInt(modelData.couleur.slice(5, 7), 16) / 255,
                                        0.15
                                    )

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.nom.charAt(0)
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: modelData.couleur
                                    }
                                }

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        text: modelData.nom
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    }
                                    Text {
                                        text: modelData.email
                                        font.pixelSize: 11
                                        color: isDarkMode ? "#94a3b8" : "#64748b"
                                        elide: Text.ElideRight
                                        Layout.maximumWidth: 180
                                    }
                                }
                            }

                            // Infos : Téléphone + Appareils
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
                                        text: modelData.appareils + " appareil" + (modelData.appareils > 1 ? "s" : "")
                                        font.pixelSize: 12
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                    }
                                }
                            }

                            // Stats : Total dépensé + Date inscription
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Column {
                                    spacing: 2

                                    Text {
                                        text: "Total dépensé"
                                        font.pixelSize: 10
                                        color: isDarkMode ? "#64748b" : "#94a3b8"
                                    }
                                    Text {
                                        text: modelData.totalDepense.toLocaleString(Qt.locale("fr_FR")) + " Ar"
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: "#00ff88"
                                    }
                                }

                                Column {
                                    spacing: 2

                                    Text {
                                        text: "Inscrit le"
                                        font.pixelSize: 10
                                        color: isDarkMode ? "#64748b" : "#94a3b8"
                                    }
                                    Text {
                                        text: modelData.dateInscription
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    }
                                }
                            }

                            // Actions
                            Row {
                                spacing: 12

                                Button {
                                    text: "Modifier"
                                    flat: true
                                    font.pixelSize: 12
                                    contentItem: Text {
                                        text: parent.text
                                        color: "#00d4ff"
                                        font: parent.font
                                    }
                                }
                                Button {
                                    text: "Supprimer"
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