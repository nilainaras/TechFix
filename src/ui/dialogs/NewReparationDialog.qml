import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Popup {
    id: newReparation

    property bool isDarkMode: true
    property int currentStep: 1
    readonly property int totalSteps: 4

    modal: true
    anchors.centerIn: Overlay.overlay
    width: 600
    height: 550
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
                    text: "🔧 Nouvelle Réparation"
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
                        onClicked: newReparation.close()
                    }
                }
            }
        }

        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            color: isDarkMode ? "#111827" : "#e2e8f0"

            Rectangle {
                width: parent.width * (newReparation.currentStep / newReparation.totalSteps)
                height: parent.height
                radius: 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#00d4ff" }
                    GradientStop { position: 1.0; color: "#00ff88" }
                }
                Behavior on width {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }
        }

        // Indicateurs d'étapes
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: "transparent"

            RowLayout {
                anchors.centerIn: parent
                spacing: 40

                Repeater {
                    model: ["Appareil", "Technicien", "Panne", "Confirmation"]

                    delegate: Column {
                        spacing: 6

                        Rectangle {
                            width: 32
                            height: 32
                            radius: 16
                            color: {
                                if (newReparation.currentStep > index + 1) return "#00ff88"
                                if (newReparation.currentStep === index + 1) return "#00d4ff"
                                return isDarkMode ? "#334155" : "#e2e8f0"
                            }

                            Text {
                                anchors.centerIn: parent
                                text: newReparation.currentStep > index + 1 ? "✓" : (index + 1)
                                font.pixelSize: 14
                                font.bold: true
                                color: newReparation.currentStep > index + 1 ? "#0a0e1a" : (newReparation.currentStep === index + 1 ? "#0a0e1a" : (isDarkMode ? "#94a3b8" : "#64748b"))
                            }
                        }

                        Text {
                            text: modelData
                            font.pixelSize: 11
                            color: newReparation.currentStep === index + 1 ? "#00d4ff" : (isDarkMode ? "#94a3b8" : "#64748b")
                            font.bold: newReparation.currentStep === index + 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#334155" : "#e2e8f0"
        }

        // Contenu des étapes
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            StackLayout {
                width: parent.width
                currentIndex: newReparation.currentStep - 1

                // Étape 1 : Appareil
                ColumnLayout {
                    anchors.margins: 24
                    spacing: 16

                    Text {
                        text: "Sélectionnez l'appareil à réparer"
                        font.pixelSize: 16
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    FormField {
                        label: "Client"
                        placeholderText: "Sélectionner un client..."
                        required: true
                        isDarkMode: newReparation.isDarkMode
                    }

                    FormField {
                        label: "Appareil"
                        placeholderText: "Sélectionner un appareil..."
                        required: true
                        isDarkMode: newReparation.isDarkMode
                    }
                }

                // Étape 2 : Technicien
                ColumnLayout {
                    anchors.margins: 24
                    spacing: 16

                    Text {
                        text: "Assignez un technicien"
                        font.pixelSize: 16
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    FormField {
                        label: "Technicien"
                        placeholderText: "Sélectionner un technicien..."
                        required: true
                        isDarkMode: newReparation.isDarkMode
                    }

                    FormField {
                        label: "Date de dépôt"
                        placeholderText: "27/10/2026"
                        required: true
                        isDarkMode: newReparation.isDarkMode
                    }
                }

                // Étape 3 : Panne
                ColumnLayout {
                    anchors.margins: 24
                    spacing: 16

                    Text {
                        text: "Décrivez la panne"
                        font.pixelSize: 16
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    FormField {
                        label: "Description de la panne"
                        placeholderText: "Écran ne s'allume plus..."
                        required: true
                        isTextArea: true
                        isDarkMode: newReparation.isDarkMode
                    }

                    FormField {
                        label: "Notes supplémentaires"
                        placeholderText: "Informations additionnelles..."
                        isTextArea: true
                        isDarkMode: newReparation.isDarkMode
                    }
                }

                // Étape 4 : Confirmation
                ColumnLayout {
                    anchors.margins: 24
                    spacing: 16

                    Text {
                        text: "Confirmation"
                        font.pixelSize: 16
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        radius: 12
                        color: isDarkMode ? "#111827" : "#f1f5f9"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "Récapitulatif de la réparation"
                                font.pixelSize: 14
                                font.bold: true
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                            }

                            Text {
                                text: "• Appareil: Dell XPS 15"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#475569"
                            }

                            Text {
                                text: "• Client: Jean Dupont"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#475569"
                            }

                            Text {
                                text: "• Technicien: Paul Tech"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#475569"
                            }

                            Text {
                                text: "• Panne: Écran ne s'allume plus"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#475569"
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#334155" : "#e2e8f0"
        }

        // Footer avec navigation
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24

                Button {
                    text: "← Précédent"
                    flat: true
                    font.pixelSize: 14
                    visible: newReparation.currentStep > 1
                    contentItem: Text {
                        text: parent.text
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                        font: parent.font
                    }
                    onClicked: newReparation.currentStep--
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: newReparation.currentStep === newReparation.totalSteps ? "Créer la réparation" : "Suivant →"
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
                        if (newReparation.currentStep < newReparation.totalSteps) {
                            newReparation.currentStep++
                        } else {
                            newReparation.close()
                        }
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