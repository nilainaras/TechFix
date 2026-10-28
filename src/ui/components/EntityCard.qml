import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string title: ""
    property string subtitle: ""
    property string description: ""
    property string icon: ""
    property string status: ""
    property bool isDarkMode: true

    signal clicked()
    signal editClicked()
    signal deleteClicked()

    implicitWidth: 340
    implicitHeight: 140

    // Ombre simulée
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 3
        radius: 16
        color: isDarkMode ? "rgba(0, 0, 0, 0.3)" : "rgba(0, 0, 0, 0.06)"
        z: 0
    }

    // Carte principale
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: isDarkMode ? "#1e293b" : "#ffffff"
        border.color: isDarkMode ? "#334155" : "#e2e8f0"
        border.width: 1
        z: 1

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            Row {
                spacing: 12

                Rectangle {
                    width: 44
                    height: 44
                    radius: 12
                    color: isDarkMode ? "rgba(0, 212, 255, 0.15)" : "rgba(0, 102, 255, 0.1)"

                    Text {
                        anchors.centerIn: parent
                        text: root.icon
                        font.pixelSize: 20
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: root.title
                        font.pixelSize: 16
                        font.bold: true
                        color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    }

                    Text {
                        text: root.subtitle
                        font.pixelSize: 12
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }
                }

                Item { width: 1; height: 1 }
            }

            Text {
                text: root.description
                font.pixelSize: 13
                color: isDarkMode ? "#94a3b8" : "#475569"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 2
            }

            Row {
                spacing: 8
                Layout.topMargin: 4

                Button {
                    text: "✏️ Modifier"
                    flat: true
                    font.pixelSize: 12
                    contentItem: Text {
                        text: parent.text
                        color: "#00d4ff"
                        font: parent.font
                    }
                    onClicked: root.editClicked()
                }

                Button {
                    text: "🗑️ Supprimer"
                    flat: true
                    font.pixelSize: 12
                    contentItem: Text {
                        text: parent.text
                        color: "#ff3366"
                        font: parent.font
                    }
                    onClicked: root.deleteClicked()
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
        onEntered: root.scale = 1.02
        onExited: root.scale = 1.0
        onClicked: root.clicked()
    }
}