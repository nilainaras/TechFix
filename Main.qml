import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    visible: true
    width: 1600
    height: 1000
    minimumWidth: 1200
    minimumHeight: 800
    title: "TechFix - Gestion d'Atelier de Réparation"

    property string currentPage: "dashboard"
    property bool isDarkMode: true
    property int pageKey: 0

    color: isDarkMode ? "#0a0e1a" : "#f0f4f8"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // SIDEBAR
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 280
            color: isDarkMode ? "#0f172a" : "#ffffff"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                // Logo
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    spacing: 12

                    Rectangle {
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 44
                        radius: 12
                        gradient: Gradient {
                            orientation: Qt.Horizontal  // CORRECTION ICI
                            GradientStop { position: 0.0; color: "#00d4ff" }
                            GradientStop { position: 1.0; color: "#00ff88" }
                        }

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/assets/icons/dashboard.svg"
                            width: 24
                            height: 24
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Text {
                        text: "TechFix"
                        font.pixelSize: 24
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                        Layout.fillWidth: true
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
                    font.letterSpacing: 1.5
                }

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
                        id: navItem
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        radius: 12
                        color: root.currentPage === modelData.id
                            ? (isDarkMode ? "rgba(0, 212, 255, 0.15)" : "rgba(0, 102, 255, 0.1)")
                            : "transparent"

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 4
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
                                opacity: root.currentPage === modelData.id ? 1.0 : 0.6
                            }

                            Text {
                                text: modelData.label
                                font.pixelSize: 15
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
                            onEntered: if (root.currentPage !== modelData.id) navItem.color = isDarkMode ? "#1e293b" : "#f1f5f9"
                            onExited: if (root.currentPage !== modelData.id) navItem.color = "transparent"
                            onClicked: {
                                root.currentPage = modelData.id
                                root.pageKey++
                            }
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
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // ZONE PRINCIPALE
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // TOPBAR
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: isDarkMode ? "#111827" : "#ffffff"

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: isDarkMode ? "#1e293b" : "#e2e8f0"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 32
                    anchors.rightMargin: 32
                    spacing: 24

                    Column {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: {
                                switch(root.currentPage) {
                                    case "dashboard": return "Tableau de bord"
                                    case "clients": return "Clients"
                                    case "appareils": return "Appareils"
                                    case "reparations": return "Réparations"
                                    case "techniciens": return "Techniciens"
                                    case "interventions": return "Interventions"
                                    default: return "TechFix"
                                }
                            }
                            font.pixelSize: 28
                            font.bold: true
                            color: isDarkMode ? "#f1f5f9" : "#0f172a"
                        }

                        Text {
                            text: "Vue d'ensemble de votre atelier"
                            font.pixelSize: 13
                            color: isDarkMode ? "#94a3b8" : "#64748b"
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // TOGGLE DARK/LIGHT
                    Rectangle {
                        id: themeToggle
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 12
                        color: isDarkMode ? "#1e293b" : "#f1f5f9"

                        Image {
                            anchors.centerIn: parent
                            width: 22
                            height: 22
                            source: isDarkMode ? "qrc:/assets/icons/sun.svg" : "qrc:/assets/icons/moon.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: themeToggle.color = isDarkMode ? "#334155" : "#e2e8f0"
                            onExited: themeToggle.color = isDarkMode ? "#1e293b" : "#f1f5f9"
                            onClicked: root.isDarkMode = !root.isDarkMode
                        }
                    }

                    // AVATAR
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 24
                        gradient: Gradient {
                            orientation: Qt.Horizontal  // CORRECTION ICI
                            GradientStop { position: 0.0; color: "#00d4ff" }
                            GradientStop { position: 1.0; color: "#00ff88" }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "A"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#0a0e1a"
                        }
                    }
                }
            }

            // ZONE DE CONTENU
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                Loader {
                    id: pageLoader
                    anchors.fill: parent
                    active: true
                    source: {
                        switch(root.currentPage) {
                            case "dashboard": return "qrc:/src/ui/pages/DashboardPage.qml"
                            case "clients": return "qrc:/src/ui/pages/ClientsPage.qml"
                            case "appareils": return "qrc:/src/ui/pages/AppareilsPage.qml"
                            case "reparations": return "qrc:/src/ui/pages/ReparationsPage.qml"
                            case "techniciens": return "qrc:/src/ui/pages/TechniciensPage.qml"
                            case "interventions": return "qrc:/src/ui/pages/InterventionsPage.qml"
                            default: return "qrc:/src/ui/pages/DashboardPage.qml"
                        }
                    }
                    onLoaded: {
                        if (item.hasOwnProperty("isDarkMode")) item.isDarkMode = root.isDarkMode
                    }
                }
            }
        }
    }

    onPageKeyChanged: {
        pageLoader.active = false
        pageLoader.active = true
    }

    opacity: 0

    Component.onCompleted: {
        var anim = Qt.createQmlObject('import QtQuick; NumberAnimation {}', root)
        anim.target = root
        anim.property = "opacity"
        anim.from = 0
        anim.to = 1
        anim.duration = 500
        anim.easing.type = Easing.OutCubic
        anim.start()
    }
}