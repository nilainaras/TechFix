import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string title: "Titre"
    property string value: "0"
    property string icon: ""
    property color accentColor: "#00d4ff"
    property string trend: ""
    property bool trendPositive: true
    property bool isDarkMode: true

    width: 240
    height: 130

    // Ombre simulée
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        radius: 16
        color: isDarkMode ? "rgba(0, 0, 0, 0.3)" : "rgba(0, 0, 0, 0.08)"
        z: 0
    }

    // Carte principale
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: isDarkMode ? "#1e293b" : "#ffffff"
        border.color: isDarkMode ? "rgba(0, 212, 255, 0.1)" : "rgba(0, 102, 255, 0.1)"
        border.width: 1
        z: 1

        // Barre d'accent en haut
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 3
            radius: 2
            color: root.accentColor
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            Rectangle {
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                radius: 12
                color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.15)

                Text {
                    anchors.centerIn: parent
                    text: root.icon
                    font.pixelSize: 24
                }
            }

            Column {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: root.title
                    font.pixelSize: 12
                    color: isDarkMode ? "#94a3b8" : "#64748b"
                }

                Text {
                    text: root.value
                    font.pixelSize: 32
                    font.bold: true
                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                }

                Text {
                    text: root.trend
                    font.pixelSize: 11
                    color: root.trendPositive ? "#00ff88" : "#ff3366"
                    font.bold: true
                    visible: root.trend !== ""
                }
            }
        }
    }

    scale: 1.0
    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: root.scale = 1.03
        onExited: root.scale = 1.0
    }
}