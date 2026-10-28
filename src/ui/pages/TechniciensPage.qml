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
            spacing: 28

            // ============ CARTES KPI ============
            RowLayout {
                spacing: 20
                Layout.fillWidth: true

                // KPI 1 - Total Techniciens
                Rectangle {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 230
                    Layout.preferredHeight: 170
                    radius: 16
                    color: isDarkMode ? "#151f2e" : "#ffffff"
                    border.width: 1
                    border.color: Qt.rgba(168, 85, 247, 0.25)

                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 4
                        height: parent.height - 56
                        radius: 2
                        color: "#a855f7"
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 24
                        anchors.rightMargin: 18
                        anchors.topMargin: 18
                        anchors.bottomMargin: 18
                        spacing: 10

                        RowLayout {
                            spacing: 12
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.preferredWidth: 44
                                Layout.preferredHeight: 44
                                radius: 12
                                color: Qt.rgba(168, 85, 247, 0.15)

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: "qrc:/assets/icons/user-cog.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Total Techniciens"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            height: 42
                            text: "3"
                            font.pixelSize: 34
                            font.bold: true
                            fontSizeMode: Text.HorizontalFit
                            minimumPixelSize: 16
                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignLeft
                            implicitWidth: trendRow1.implicitWidth + 20
                            implicitHeight: 24
                            radius: 12
                            color: Qt.rgba(0, 255, 136, 0.12)

                            Row {
                                id: trendRow1
                                anchors.centerIn: parent
                                Text { text: "100% actifs"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                            }
                        }
                    }

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.scale = 1.02
                        onExited: parent.scale = 1.0
                    }
                }

                // KPI 2 - Interventions ce mois
                Rectangle {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 230
                    Layout.preferredHeight: 170
                    radius: 16
                    color: isDarkMode ? "#151f2e" : "#ffffff"
                    border.width: 1
                    border.color: Qt.rgba(0, 212, 255, 0.25)

                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 4
                        height: parent.height - 56
                        radius: 2
                        color: "#00d4ff"
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 24
                        anchors.rightMargin: 18
                        anchors.topMargin: 18
                        anchors.bottomMargin: 18
                        spacing: 10

                        RowLayout {
                            spacing: 12
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.preferredWidth: 44
                                Layout.preferredHeight: 44
                                radius: 12
                                color: Qt.rgba(0, 212, 255, 0.15)

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: "qrc:/assets/icons/wrench.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Interventions ce mois"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            height: 42
                            text: "7"
                            font.pixelSize: 34
                            font.bold: true
                            fontSizeMode: Text.HorizontalFit
                            minimumPixelSize: 16
                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignLeft
                            implicitWidth: trendRow2.implicitWidth + 20
                            implicitHeight: 24
                            radius: 12
                            color: Qt.rgba(0, 255, 136, 0.12)

                            Row {
                                id: trendRow2
                                anchors.centerIn: parent
                                spacing: 5
                                Text { text: "↑"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                                Text { text: "+23% vs mois dernier"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                            }
                        }
                    }

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.scale = 1.02
                        onExited: parent.scale = 1.0
                    }
                }

                // KPI 3 - Spécialités
                Rectangle {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 230
                    Layout.preferredHeight: 170
                    radius: 16
                    color: isDarkMode ? "#151f2e" : "#ffffff"
                    border.width: 1
                    border.color: Qt.rgba(0, 255, 136, 0.25)

                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 4
                        height: parent.height - 56
                        radius: 2
                        color: "#00ff88"
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 24
                        anchors.rightMargin: 18
                        anchors.topMargin: 18
                        anchors.bottomMargin: 18
                        spacing: 10

                        RowLayout {
                            spacing: 12
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.preferredWidth: 44
                                Layout.preferredHeight: 44
                                radius: 12
                                color: Qt.rgba(0, 255, 136, 0.15)

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: "qrc:/assets/icons/check-circle.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Spécialités couvertes"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            height: 42
                            text: "3"
                            font.pixelSize: 34
                            font.bold: true
                            fontSizeMode: Text.HorizontalFit
                            minimumPixelSize: 16
                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignLeft
                            implicitWidth: trendRow3.implicitWidth + 20
                            implicitHeight: 24
                            radius: 12
                            color: Qt.rgba(168, 85, 247, 0.12)

                            Row {
                                id: trendRow3
                                anchors.centerIn: parent
                                Text { text: "PC • Mobile • Réseau"; font.pixelSize: 11; font.bold: true; color: "#a855f7" }
                            }
                        }
                    }

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.scale = 1.02
                        onExited: parent.scale = 1.0
                    }
                }
            }

            // ============ HEADER ============
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

            // ============ LISTE DES TECHNICIENS ============
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 16
                columnSpacing: 16

                Repeater {
                    model: [
                        { nom: "Paul Tech", specialite: "Ordinateurs & Serveurs", email: "paul.tech@atelier.fr", tel: "06 11 22 33 44", interventions: 4, rating: 4.8, actif: true },
                        { nom: "Lucie Mobile", specialite: "Smartphones & Tablettes", email: "lucie.mobile@atelier.fr", tel: "06 55 66 77 88", interventions: 2, rating: 4.9, actif: true },
                        { nom: "Marc Réseau", specialite: "Réseau & Infrastructure", email: "marc.reseau@atelier.fr", tel: "06 99 88 77 66", interventions: 1, rating: 4.7, actif: true }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 280
                        Layout.preferredHeight: 220
                        radius: 16
                        color: isDarkMode ? "#151f2e" : "#ffffff"
                        border.width: 1
                        border.color: Qt.rgba(168, 85, 247, 0.2)

                        Rectangle {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: 4
                            height: parent.height - 80
                            radius: 2
                            color: "#a855f7"
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 24
                            anchors.rightMargin: 20
                            anchors.topMargin: 20
                            anchors.bottomMargin: 20
                            spacing: 10

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Rectangle {
                                    Layout.preferredWidth: 52
                                    Layout.preferredHeight: 52
                                    radius: 26
                                    color: Qt.rgba(168, 85, 247, 0.15)

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.nom.charAt(0)
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: "#a855f7"
                                    }
                                }

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: modelData.nom
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    }

                                    Rectangle {
                                        implicitWidth: 60
                                        implicitHeight: 20
                                        radius: 10
                                        color: modelData.actif ? Qt.rgba(0, 255, 136, 0.12) : Qt.rgba(255, 51, 102, 0.12)

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.actif ? "Actif" : "Inactif"
                                            font.pixelSize: 10
                                            font.bold: true
                                            color: modelData.actif ? "#00ff88" : "#ff3366"
                                        }
                                    }
                                }
                            }

                            Text {
                                text: modelData.specialite
                                font.pixelSize: 12
                                font.bold: true
                                color: "#a855f7"
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Row {
                                    spacing: 6
                                    Image {
                                        source: "qrc:/assets/icons/users.svg"
                                        width: 14
                                        height: 14
                                    }
                                    Text {
                                        text: modelData.email
                                        font.pixelSize: 11
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                        elide: Text.ElideRight
                                        Layout.maximumWidth: 150
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
                                        font.pixelSize: 11
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                    }
                                }

                                Row {
                                    spacing: 6
                                    Image {
                                        source: "qrc:/assets/icons/wrench.svg"
                                        width: 14
                                        height: 14
                                    }
                                    Text {
                                        text: modelData.interventions + " interventions"
                                        font.pixelSize: 11
                                        color: isDarkMode ? "#94a3b8" : "#475569"
                                    }
                                }

                                Row {
                                    spacing: 4
                                    Text {
                                        text: "★"
                                        font.pixelSize: 12
                                        color: "#ffaa00"
                                    }
                                    Text {
                                        text: modelData.rating.toFixed(1)
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: "#ffaa00"
                                    }
                                }
                            }

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