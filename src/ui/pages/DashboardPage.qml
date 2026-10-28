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

                // Carte 1 - Total Réparations
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
                                text: "Total Réparations"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            height: 42
                            text: "12"
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
                                spacing: 5
                                Text { text: "↑"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                                Text { text: "+12% ce mois"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
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

                // Carte 2 - En cours
                Rectangle {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 230
                    Layout.preferredHeight: 170
                    radius: 16
                    color: isDarkMode ? "#151f2e" : "#ffffff"
                    border.width: 1
                    border.color: Qt.rgba(255, 170, 0, 0.25)

                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 4
                        height: parent.height - 56
                        radius: 2
                        color: "#ffaa00"
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
                                color: Qt.rgba(255, 170, 0, 0.15)

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: "qrc:/assets/icons/loader.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "En cours"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            height: 42
                            text: "5"
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
                            color: Qt.rgba(255, 170, 0, 0.12)

                            Row {
                                id: trendRow2
                                anchors.centerIn: parent
                                Text { text: "À traiter"; font.pixelSize: 11; font.bold: true; color: "#ffaa00" }
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

                // Carte 3 - Terminées
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
                                text: "Terminées"
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
                            color: Qt.rgba(0, 255, 136, 0.12)

                            Row {
                                id: trendRow3
                                anchors.centerIn: parent
                                spacing: 5
                                Text { text: "↑"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                                Text { text: "+8 vs mois dernier"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
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

                // Carte 4 - CA du mois (Ariary)
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
                                    source: "qrc:/assets/icons/dollar-sign.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "CA du mois"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: isDarkMode ? "#94a3b8" : "#64748b"
                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            height: 42
                            text: "535 000 Ar"
                            font.pixelSize: 34
                            font.bold: true
                            fontSizeMode: Text.HorizontalFit
                            minimumPixelSize: 16
                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignLeft
                            implicitWidth: trendRow4.implicitWidth + 20
                            implicitHeight: 24
                            radius: 12
                            color: Qt.rgba(0, 255, 136, 0.12)

                            Row {
                                id: trendRow4
                                anchors.centerIn: parent
                                spacing: 5
                                Text { text: "↑"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                                Text { text: "+15%"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
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

            // ============ SECTION ALERTES ============
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                radius: 16
                color: isDarkMode ? "#151f2e" : "#ffffff"
                border.color: Qt.rgba(255, 51, 102, 0.4)
                border.width: 1

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: 4
                    height: parent.height - 80
                    radius: 2
                    color: "#ff3366"
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 28
                    anchors.rightMargin: 28
                    anchors.topMargin: 24
                    anchors.bottomMargin: 24
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true

                        Rectangle {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            radius: 10
                            color: Qt.rgba(255, 51, 102, 0.15)

                            Image {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                source: "qrc:/assets/icons/alert-triangle.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            text: "Réparations en retard"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#ff3366"
                            Layout.fillWidth: true
                        }

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