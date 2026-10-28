import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property string pageTitle: "Dashboard"
    property string pageSubtitle: ""
    property bool isDarkMode: true

    signal themeToggled()

    height: 70
    color: isDarkMode ? "#111827" : "#ffffff"

    // Bordure basse
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: isDarkMode ? "#1e293b" : "#e2e8f0"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 16

        // Titre de page
        Column {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.pageTitle
                font.pixelSize: 22
                font.bold: true
                color: isDarkMode ? "#f1f5f9" : "#0f172a"
                font.family: "Segoe UI"
            }

            Text {
                text: root.pageSubtitle
                font.pixelSize: 12
                color: isDarkMode ? "#94a3b8" : "#64748b"
                visible: root.pageSubtitle !== ""
            }
        }

        // Barre de recherche
        Rectangle {
            Layout.preferredWidth: 300
            Layout.preferredHeight: 40
            radius: 10
            color: isDarkMode ? "#1e293b" : "#f1f5f9"
            border.color: isDarkMode ? "#334155" : "#e2e8f0"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                Text {
                    text: "🔍"
                    font.pixelSize: 14
                }

                TextField {
                    Layout.fillWidth: true
                    placeholderText: "Rechercher..."
                    font.pixelSize: 13
                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    background: Rectangle { color: "transparent" }
                }
            }
        }

        // Bouton toggle thème
        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 10
            color: isDarkMode ? "#1e293b" : "#f1f5f9"

            Text {
                anchors.centerIn: parent
                text: isDarkMode ? "☀️" : "🌙"
                font.pixelSize: 18
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.themeToggled()

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: "#ffffff"
                    opacity: 0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                onPressed: parent.children[1].opacity = 0.1
                onReleased: parent.children[1].opacity = 0
            }
        }

        // Avatar utilisateur
        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 20
            gradient: Gradient {
                orientation: Gradient.Diagonal
                GradientStop { position: 0.0; color: "#00d4ff" }
                GradientStop { position: 1.0; color: "#00ff88" }
            }

            Text {
                anchors.centerIn: parent
                text: "A"
                font.pixelSize: 16
                font.bold: true
                color: "#0a0e1a"
            }
        }
    }
}