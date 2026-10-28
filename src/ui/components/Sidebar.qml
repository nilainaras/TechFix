import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root

    property string currentPage: "dashboard"
    property bool isDarkMode: true

    signal pageChanged(string page)

    width: 260
    color: isDarkMode ? "#0f172a" : "#ffffff"

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: isDarkMode ? "#1e293b" : "#e2e8f0"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        // Logo
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "transparent"

            RowLayout {
                anchors.centerIn: parent
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 12
                    gradient: Gradient {
                        orientation: Gradient.Diagonal
                        GradientStop { position: 0.0; color: "#00d4ff" }
                        GradientStop { position: 1.0; color: "#00ff88" }
                    }

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/assets/images/logo.svg"
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Text {
                    text: "TechFix"
                    font.pixelSize: 22
                    font.bold: true
                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#1e293b" : "#e2e8f0"
        }

        Text {
            text: "NAVIGATION"
            font.pixelSize: 11
            font.bold: true
            color: isDarkMode ? "#64748b" : "#94a3b8"
            font.letterSpacing: 1
            Layout.topMargin: 12
        }

        // Items de navigation avec icônes SVG
        Repeater {
            model: [
                { id: "dashboard", label: "Dashboard", icon: "qrc:/assets/icons/dashboard.svg" },
                { id: "clients", label: "Clients", icon: "qrc:/assets/icons/users.svg" },
                { id: "appareils", label: "Appareils", icon: "qrc:/assets/icons/laptop.svg" },
                { id: "reparations", label: "Réparations", icon: "qrc:/assets/icons/wrench.svg" },
                { id: "techniciens", label: "Techniciens", icon: "qrc:/assets/icons/user-cog.svg" },
                { id: "interventions", label: "Interventions", icon: "qrc:/assets/icons/clipboard-list.svg" }
            ]

            delegate: Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                radius: 10
                color: {
                    if (root.currentPage === modelData.id)
                        return isDarkMode ? Qt.rgba(0, 212, 255, 0.15) : Qt.rgba(0, 102, 255, 0.1)
                    return "transparent"
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    radius: 2
                    color: "#00d4ff"
                    visible: root.currentPage === modelData.id
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    Image {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        source: modelData.icon
                        fillMode: Image.PreserveAspectFit

                        // Couleur de l'icône
                        layer.enabled: true
                        layer.effect: ColorOverlay {
                            color: root.currentPage === modelData.id
                                ? "#00d4ff"
                                : (isDarkMode ? "#94a3b8" : "#64748b")
                        }
                    }

                    Text {
                        text: modelData.label
                        font.pixelSize: 14
                        font.weight: root.currentPage === modelData.id ? Font.DemiBold : Font.Normal
                        color: root.currentPage === modelData.id
                            ? "#00d4ff"
                            : (isDarkMode ? "#94a3b8" : "#475569")
                        Layout.fillWidth: true
                    }
                }

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: if (root.currentPage !== modelData.id) parent.color = isDarkMode ? "#1e293b" : "#f1f5f9"
                    onExited: if (root.currentPage !== modelData.id) parent.color = "transparent"
                    onClicked: root.pageChanged(modelData.id)
                }
            }
        }

        Item { Layout.fillHeight: true }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#1e293b" : "#e2e8f0"
        }

        Text {
            text: "v1.0.0"
            font.pixelSize: 11
            color: isDarkMode ? "#64748b" : "#94a3b8"
            Layout.alignment: Qt.AlignHCenterCenter
        }
    }
}