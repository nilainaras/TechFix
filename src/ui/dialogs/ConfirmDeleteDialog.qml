import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Popup {
    id: confirmDelete

    property bool isDarkMode: true
    property string itemName: ""
    property string itemType: "élément"

    signal confirmed()

    modal: true
    anchors.centerIn: Overlay.overlay
    width: 400
    height: 280
    padding: 0

    background: Item {
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 12
            anchors.leftMargin: 4
            anchors.rightMargin: -4
            anchors.bottomMargin: -12

            radius: 24
            color: "#10000000"
        }

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 6
            anchors.leftMargin: 2
            anchors.rightMargin: -2
            anchors.bottomMargin: -6

            radius: 22
            color: "#18000000"
        }

        Rectangle {
            anchors.fill: parent

            radius: 20
            color: isDarkMode ? "#1e293b" : "#ffffff"
            border.color: isDarkMode ? "#334155" : "#e2e8f0"
            border.width: 1
        }
    }

    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.6)
        Behavior on color { ColorAnimation { duration: 300 } }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header avec icône danger
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: "transparent"

            Column {
                anchors.centerIn: parent
                spacing: 12

                Rectangle {
                    width: 60
                    height: 60
                    radius: 30
                    color: isDarkMode ? "rgba(255, 51, 102, 0.15)" : "rgba(230, 57, 70, 0.15)"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "️"
                        font.pixelSize: 28
                    }
                }

                Text {
                    text: "Confirmer la suppression"
                    font.pixelSize: 18
                    font.bold: true
                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#334155" : "#e2e8f0"
        }

        // Message
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "Êtes-vous sûr de vouloir supprimer " + (confirmDelete.itemName ? "\"" + confirmDelete.itemName + "\"" : "cet " + confirmDelete.itemType) + " ?\n\nCette action est irréversible."
                font.pixelSize: 14
                color: isDarkMode ? "#94a3b8" : "#475569"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                width: parent.width - 48
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#334155" : "#e2e8f0"
        }

        // Footer avec boutons
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "transparent"

            RowLayout {
                anchors.centerIn: parent
                spacing: 16

                Button {
                    text: "Annuler"
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 10
                        color: isDarkMode ? "#111827" : "#f1f5f9"
                        border.color: isDarkMode ? "#334155" : "#e2e8f0"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                    }
                    onClicked: confirmDelete.close()
                }

                Button {
                    text: "Supprimer"
                    font.pixelSize: 14
                    font.bold: true

                    background: Rectangle {
                        radius: 10
                        color: "#ff3366"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#ffffff"
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                    }

                    onClicked: {
                        confirmDelete.confirmed()
                        confirmDelete.close()
                    }
                }
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200; easing.type: Easing.InCubic }
    }
}