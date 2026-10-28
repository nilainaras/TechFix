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
            width: scrollview.availableWidth - (scrollview.availableWidth / 50)
            spacing: 28

            // ============ CARTES KPI ============
            RowLayout {
                spacing: 20
                Layout.fillWidth: true

                // KPI 1 - Total Interventions
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
                                    source: "qrc:/assets/icons/clipboard-list.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Total Interventions"
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
                            implicitWidth: trendRow1.implicitWidth + 20
                            implicitHeight: 24
                            radius: 12
                            color: Qt.rgba(0, 255, 136, 0.12)

                            Row {
                                id: trendRow1
                                anchors.centerIn: parent
                                spacing: 5
                                Text { text: "↑"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                                Text { text: "+40% ce mois"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
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

                // KPI 2 - Coût total (Ariary)
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
                                    source: "qrc:/assets/icons/dollar-sign.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Coût total"
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
                            implicitWidth: trendRow2.implicitWidth + 20
                            implicitHeight: 24
                            radius: 12
                            color: Qt.rgba(0, 255, 136, 0.12)

                            Row {
                                id: trendRow2
                                anchors.centerIn: parent
                                spacing: 5
                                Text { text: "↑"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
                                Text { text: "+18% vs mois dernier"; font.pixelSize: 11; font.bold: true; color: "#00ff88" }
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

                // KPI 3 - Types
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
                                    source: "qrc:/assets/icons/wrench.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Types d'intervention"
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
                            color: Qt.rgba(255, 170, 0, 0.12)

                            Row {
                                id: trendRow3
                                anchors.centerIn: parent
                                Text { text: "Pièce • MO • Diagnostic"; font.pixelSize: 11; font.bold: true; color: "#ffaa00" }
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
                        text: "Gestion des Interventions"
                        font.pixelSize: 24
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }
                    Text {
                        text: "7 interventions enregistrées"
                        font.pixelSize: 13
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "+ Nouvelle Intervention"
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

            // ============ LISTE ============
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12

                Repeater {
                    model: [
                        { id: 1, type: "Pièce", desc: "Remplacement dalle LCD 4K", cout: 180000, date: "22/10/2026", rep: 1 },
                        { id: 2, type: "Main d'œuvre", desc: "Démontage et remontage", cout: 45000, date: "22/10/2026", rep: 1 },
                        { id: 3, type: "Pièce", desc: "Remplacement batterie", cout: 65000, date: "20/10/2026", rep: 2 },
                        { id: 4, type: "Main d'œuvre", desc: "Installation batterie", cout: 30000, date: "20/10/2026", rep: 2 },
                        { id: 5, type: "Diagnostic", desc: "Diagnostic RAID complet", cout: 80000, date: "19/10/2026", rep: 3 },
                        { id: 6, type: "Pièce", desc: "Clavier Dell original", cout: 95000, date: "12/10/2026", rep: 5 },
                        { id: 7, type: "Main d'œuvre", desc: "Remplacement clavier", cout: 40000, date: "13/10/2026", rep: 5 }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 84
                        radius: 14
                        color: isDarkMode ? "#151f2e" : "#ffffff"
                        border.width: 1
                        border.color: isDarkMode ? "#263447" : "#e2e8f0"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            anchors.topMargin: 16
                            anchors.bottomMargin: 16
                            spacing: 16

                            Rectangle {
                                Layout.preferredWidth: 48
                                Layout.preferredHeight: 48
                                radius: 12
                                color: {
                                    if (modelData.type === "Pièce") return Qt.rgba(0, 212, 255, 0.15)
                                    if (modelData.type === "Main d'œuvre") return Qt.rgba(0, 255, 136, 0.15)
                                    return Qt.rgba(168, 85, 247, 0.15)
                                }

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: modelData.type === "Pièce" ? "qrc:/assets/icons/wrench.svg" : "qrc:/assets/icons/clipboard-list.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: modelData.desc
                                    font.pixelSize: 15
                                    font.bold: true
                                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Row {
                                    spacing: 10

                                    Rectangle {
                                        implicitWidth: typeText.implicitWidth + 16
                                        implicitHeight: 20
                                        radius: 10
                                        color: isDarkMode ? "#0f172a" : "#f1f5f9"

                                        Text {
                                            id: typeText
                                            anchors.centerIn: parent
                                            text: modelData.type
                                            font.pixelSize: 10
                                            font.bold: true
                                            color: "#00d4ff"
                                        }
                                    }

                                    Text {
                                        text: "Réparation #" + modelData.rep
                                        font.pixelSize: 11
                                        color: isDarkMode ? "#64748b" : "#94a3b8"
                                    }
                                }
                            }

                            Column {
                                Layout.preferredWidth: 110
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

                            Column {
                                Layout.preferredWidth: 130
                                spacing: 2

                                Text {
                                    text: "Coût"
                                    font.pixelSize: 10
                                    color: isDarkMode ? "#64748b" : "#94a3b8"
                                }
                                Text {
                                    text: modelData.cout.toLocaleString(Qt.locale("fr_FR")) + " Ar"
                                    font.pixelSize: 15
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
                            onEntered: parent.scale = 1.01
                            onExited: parent.scale = 1.0
                        }
                    }
                }
            }
        }
    }
}