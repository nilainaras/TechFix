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
        id: scrollView
        anchors.fill: parent
        anchors.margins: 32
        clip: true

        ColumnLayout {
            id: content
            width: scrollView.availableWidth
            spacing: 22

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
                        newIntervention.open()
                    }
                }
                NewInterventionDialog {
                    id: newIntervention
                }

                Item { Layout.fillWidth: true }

                ScrollBar.vertical: ScrollBar {
                    id: verticalBar
                    policy: ScrollBar.AsNeeded
                    Layout.preferredWidth: 6
                    height: scrollView.availableHeight

                    background: Rectangle {
                        radius: 5
                        Layout.preferredWidth: 6
                        color: root.isDarkMode ? "#00E5FF" : verticalBar.hovered ? "#38BDF8" : "#2584D8"
                    }

                    contentItem: Rectangle {
                        radius: 5
                        Layout.preferredWidth: 6
                        color: verticalBar.pressed ? "#00e5ff" : verticalBar.hovered ? "#38bdf8" : "#2584d8"
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12

                Repeater {
                    model: [
                        { id: 1, type: "Pièce", desc: "Remplacement dalle LCD 4K", cout: 180.00, date: "22/10/2026", rep: 1 },
                        { id: 2, type: "Main d'œuvre", desc: "Démontage et remontage", cout: 45.00, date: "22/10/2026", rep: 1 },
                        { id: 3, type: "Pièce", desc: "Remplacement batterie", cout: 65.00, date: "20/10/2026", rep: 2 },
                        { id: 4, type: "Main d'œuvre", desc: "Installation batterie", cout: 30.00, date: "20/10/2026", rep: 2 },
                        { id: 5, type: "Diagnostic", desc: "Diagnostic RAID complet", cout: 80.00, date: "19/10/2026", rep: 3 },
                        { id: 6, type: "Pièce", desc: "Clavier Dell original", cout: 95.00, date: "12/10/2026", rep: 5 },
                        { id: 7, type: "Main d'œuvre", desc: "Remplacement clavier", cout: 40.00, date: "13/10/2026", rep: 5 }
                    ]

                    delegate: Rectangle {
                        width: scrollView.availableWidth - (scrollView.availableWidth / 20)
                        Layout.preferredHeight: 90
                        radius: 16
                        color: isDarkMode ? "#1e293b" : "#ffffff"
                        border.color: isDarkMode ? "#334155" : "#e2e8f0"
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            Rectangle {
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 50
                                radius: 12
                                color: {
                                    if (modelData.type === "Pièce") return Qt.rgba(0, 212, 255, 0.15)
                                    if (modelData.type === "Main d'œuvre") return Qt.rgba(0, 255, 136, 0.15)
                                    return Qt.rgba(168, 85, 247, 0.15)
                                }

                                Image {
                                    anchors.centerIn: parent
                                    source: modelData.type === "Pièce" ? "qrc:/assets/icons/wrench.svg" : "qrc:/assets/icons/clipboard-list.svg"
                                    width: 24
                                    height: 24
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
                                }

                                Row {
                                    spacing: 12

                                    Rectangle {
                                        implicitWidth: 90
                                        implicitHeight: 22
                                        radius: 11
                                        color: isDarkMode ? "#111827" : "#f1f5f9"

                                        Text {
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
                                        color: isDarkMode ? "#94a3b8" : "#64748b"
                                        font.family: "Consolas"
                                    }
                                }
                            }

                            Column {
                                Layout.preferredWidth: 120
                                spacing: 4

                                Text {
                                    text: "Date"
                                    font.pixelSize: 11
                                    color: isDarkMode ? "#64748b" : "#94a3b8"
                                }

                                Text {
                                    text: modelData.date
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                                    font.family: "Consolas"
                                }
                            }

                            Column {
                                Layout.preferredWidth: 120
                                spacing: 4

                                Text {
                                    text: "Coût"
                                    font.pixelSize: 11
                                    color: isDarkMode ? "#64748b" : "#94a3b8"
                                }

                                Text {
                                    text: modelData.cout.toFixed(2) + " €"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#00ff88"
                                    font.family: "Consolas"
                                }
                            }

                            Button {
                                text: "🗑️"
                                flat: true
                                font.pixelSize: 14
                            }
                        }

                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 200 } }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.scale = 1.005
                            onExited: parent.scale = 1.0
                        }
                    }
                }
            }
        }
    }
}