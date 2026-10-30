import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

// import TechFix 1.0

Popup {
    id: newClient

    property bool isDarkMode: true

    modal: true
    anchors.centerIn: Overlay.overlay
    width: 500
    height: 450
    padding: 0

    background: Item {
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 12
            anchors.leftMargin: 4
            anchors.rightMargin: -4
            anchors.bottomMargin: -12

            radius: 24
            color: "#10000000"
        }

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 6
            anchors.leftMargin: 2
            anchors.rightMargin: -2
            anchors.bottomMargin: -6

            radius: 22
            color: "#18000000"
        }

        Rectangle {
            anchors.fill: parent

            radius: 20
            color: isDarkMode ? "#1e293b" : "#ffffff"
            border.color: isDarkMode ? "#334155" : "#e2e8f0"
            border.width: 1
        }
    }

    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.6)
        Behavior on color { ColorAnimation { duration: 300 } }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 16

                Text {
                    text: "👥 Nouveau Client"
                    font.pixelSize: 20
                    font.bold: true
                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    Layout.fillWidth: true
                }

                Rectangle {
                    implicitWidth: 32
                    implicitHeight: 32
                    radius: 8
                    color: isDarkMode ? "#334155" : "#f1f5f9"

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        font.pixelSize: 16
                        font.bold: true
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: newClient.close()
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#334155" : "#e2e8f0"
        }

        // Contenu formulaire
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                width: parent.width
                anchors.margins: 24
                spacing: 16

                FormField {
                    label: "Nom complet"
                    placeholderText: "Jean Dupont"
                    required: true
                    isDarkMode: newClient.isDarkMode
                    id: fieldName
                }

                FormField {
                    label: "Téléphone"
                    placeholderText: "06 12 34 56 78"
                    required: true
                    isDarkMode: newClient.isDarkMode
                    id: fieldPhone
                }

                FormField {
                    label: "Email"
                    placeholderText: "jean.dupont@email.com"
                    isDarkMode: newClient.isDarkMode
                    id: fieldEmail
                }

                FormField {
                    label: "Adresse"
                    placeholderText: "123 rue de la Paix, 75001 Paris"
                    isTextArea: true
                    isDarkMode: newClient.isDarkMode
                    id: fieldAddress
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#334155" : "#e2e8f0"
        }

        // Footer
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Button {
                    text: "Annuler"
                    flat: true
                    font.pixelSize: 14
                    contentItem: Text {
                        text: parent.text
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                        font: parent.font
                    }
                    onClicked: {

                        newClient.close()
                    }
                }

                Button {
                    text: "Créer le client"
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

                    onClicked: {
                        const nom = fieldName.value.trim()
                        const telephone = fieldPhone.value.trim()

                       //         // Vérifier les champs obligatoires
                       //         if (nom === "") {
                       //             fieldName.errorText = "Le nom est obligatoire."
                       //             return
                       //         }

                       //         if (telephone === "") {
                       //             fieldPhone.errorText = "Le téléphone est obligatoire."
                       //             return
                       //         }

                        // Enregistrer dans la base de données
                        const succes = clientManager.ajouterClient(
                            nom,
                            telephone
                        )

                        // if (succes) {
                        //     fieldName.value = ""
                        //     fieldPhone.value = ""
                        //     fieldEmail.value = ""
                        //     fieldAddress.value = ""

                        //     newClient.close()
                        // }
                        newClient.close()
                    }
                }
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200; easing.type: Easing.InCubic }
    }
}