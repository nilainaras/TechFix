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
            spacing: 32

            // CARTES KPI
            RowLayout {
                spacing: 24
                Layout.fillWidth: true

                // Carte 1 - Total
                Rectangle {
                    Layout.preferredWidth: 235
                    Layout.preferredHeight: 160
                    radius: 20
                    color: isDarkMode ? "#1e293b" : "#ffffff"
                    border.color: isDarkMode ? Qt.rgba(0, 212, 255, 0.2) : Qt.rgba(0, 102, 255, 0.15)
                    border.width: 1

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 4
                        radius: 2
                        color: "#00d4ff"
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 20

                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: 16
                            color: Qt.rgba(0, 212, 255, 0.15)

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/assets/icons/wrench.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Total Réparations"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                            }

                            Text {
                                text: "12"
                                font.pixelSize: 36
                                font.bold: true
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                            }

                            Text {
                                text: "+12% ce mois"
                                font.pixelSize: 12
                                font.bold: true
                                color: "#00ff88"
                            }
                        }
                    }

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.scale = 1.03
                        onExited: parent.scale = 1.0
                    }
                }

                // Carte 2 - En cours
                Rectangle {
                    Layout.preferredWidth: 235
                    Layout.preferredHeight: 160
                    radius: 20
                    color: isDarkMode ? "#1e293b" : "#ffffff"
                    border.color: isDarkMode ? Qt.rgba(255, 170, 0, 0.2) : Qt.rgba(255, 136, 0, 0.15)
                    border.width: 1

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 4
                        radius: 2
                        color: "#ffaa00"
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 20

                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: 16
                            color: Qt.rgba(255, 170, 0, 0.15)

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/assets/icons/loader.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "En cours"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                            }

                            Text {
                                text: "5"
                                font.pixelSize: 36
                                font.bold: true
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                            }

                            Text {
                                text: "À traiter"
                                font.pixelSize: 12
                                font.bold: true
                                color: "#ffaa00"
                            }
                        }
                    }

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.scale = 1.03
                        onExited: parent.scale = 1.0
                    }
                }

                // Carte 3 - Terminées
                Rectangle {
                    Layout.preferredWidth: 235
                    Layout.preferredHeight: 160
                    radius: 20
                    color: isDarkMode ? "#1e293b" : "#ffffff"
                    border.color: isDarkMode ? Qt.rgba(0, 255, 136, 0.2) : Qt.rgba(0, 204, 102, 0.15)
                    border.width: 1

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 4
                        radius: 2
                        color: "#00ff88"
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 20

                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: 16
                            color: Qt.rgba(0, 255, 136, 0.15)

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/assets/icons/check-circle.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Terminées"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                            }

                            Text {
                                text: "3"
                                font.pixelSize: 36
                                font.bold: true
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                            }

                            Text {
                                text: "+8 vs mois dernier"
                                font.pixelSize: 12
                                font.bold: true
                                color: "#00ff88"
                            }
                        }
                    }

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.scale = 1.03
                        onExited: parent.scale = 1.0
                    }
                }

                // Carte 4 - CA
                Rectangle {
                    Layout.preferredWidth: 235
                    Layout.preferredHeight: 160
                    radius: 20
                    color: isDarkMode ? "#1e293b" : "#ffffff"
                    border.color: isDarkMode ? Qt.rgba(168, 85, 247, 0.2) : Qt.rgba(124, 58, 237, 0.15)
                    border.width: 1

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 4
                        radius: 2
                        color: "#a855f7"
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 20

                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: 16
                            color: Qt.rgba(168, 85, 247, 0.15)

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/assets/icons/dollar-sign.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "CA du mois"
                                font.pixelSize: 13
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                            }

                            Text {
                                text: "1 240 €"
                                font.pixelSize: 36
                                font.bold: true
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                            }

                            Text {
                                text: "+15%"
                                font.pixelSize: 12
                                font.bold: true
                                color: "#00ff88"
                            }
                        }
                    }

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.scale = 1.03
                        onExited: parent.scale = 1.0
                    }
                }
            }

            // SECTION ALERTES
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                radius: 20
                color: isDarkMode ? "#1e293b" : "#ffffff"
                border.color: "#ff3366"
                border.width: 2

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 28
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true

                        Row {
                            spacing: 10

                            Image {
                                source: "qrc:/assets/icons/alert-triangle.svg"
                                width: 22
                                height: 22
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                text: "Réparations en retard"
                                font.pixelSize: 18
                                font.bold: true
                                color: "#ff3366"
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            radius: 20
                            color: Qt.rgba(255, 51, 102, 0.15)

                            Text {
                                anchors.centerIn: parent
                                text: "2"
                                font.pixelSize: 18
                                font.bold: true
                                color: "#ff3366"
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: isDarkMode ? "#334155" : "#e2e8f0"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Rectangle {
                                Layout.preferredWidth: 8
                                Layout.preferredHeight: 8
                                radius: 4
                                color: "#ff3366"
                            }

                            Text {
                                text: "#1 Serveur HP - 8 jours"
                                font.pixelSize: 14
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.preferredWidth: 80
                                Layout.preferredHeight: 24
                                radius: 12
                                color: Qt.rgba(255, 51, 102, 0.15)

                                Text {
                                    anchors.centerIn: parent
                                    text: "URGENT"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: "#ff3366"
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Rectangle {
                                Layout.preferredWidth: 8
                                Layout.preferredHeight: 8
                                radius: 4
                                color: "#ffaa00"
                            }

                            Text {
                                text: "#3 Dell XPS - 6 jours"
                                font.pixelSize: 14
                                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 24
                                radius: 12
                                color: Qt.rgba(255, 170, 0, 0.15)

                                Text {
                                    anchors.centerIn: parent
                                    text: "ATTENTION"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: "#ffaa00"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}