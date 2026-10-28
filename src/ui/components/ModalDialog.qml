import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root

    property string dialogTitle: "Titre"
    property bool isDarkMode: true

    modal: true
    anchors.centerIn: Overlay.overlay
    padding: 0

    background: Rectangle {
        radius: 20
        color: isDarkMode ? "#1e293b" : "#ffffff"
        border.color: isDarkMode ? "#334155" : "#e2e8f0"
        border.width: 1
    }

    Overlay.modal: Rectangle {
        color: "rgba(0, 0, 0, 0.6)"
        Behavior on color { ColorAnimation { duration: 300 } }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 16

                Text {
                    text: root.dialogTitle
                    font.pixelSize: 18
                    font.bold: true
                    color: isDarkMode ? "#f1f5f9" : "#0f172a"
                    Layout.fillWidth: true
                }

                Rectangle {
                    implicitWidth: 32
                    implicitHeight: 32
                    radius: 8
                    color: isDarkMode ? "#334155" : "#f1f5f9"

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        font.pixelSize: 14
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: isDarkMode ? "#334155" : "#e2e8f0"
        }

        Item {
            id: contentArea
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Button {
                    text: "Annuler"
                    flat: true
                    font.pixelSize: 14
                    contentItem: Text {
                        text: parent.text
                        color: isDarkMode ? "#94a3b8" : "#64748b"
                        font: parent.font
                    }
                    onClicked: root.close()
                }

                Button {
                    text: "Confirmer"
                    font.pixelSize: 14
                    font.bold: true

                    background: Rectangle {
                        radius: 10
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
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: 200
            easing.type: Easing.InCubic
        }
    }
}