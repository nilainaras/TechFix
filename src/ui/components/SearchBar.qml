import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property alias text: textField.text
    property alias placeholderText: textField.placeholderText
    property bool isDarkMode: true
    property bool focused: false

    implicitWidth: 320
    implicitHeight: 42
    radius: 12

    color: isDarkMode ? "#1e293b" : "#ffffff"
    border.color: focused ? "#00d4ff" : (isDarkMode ? "#334155" : "#e2e8f0")
    border.width: focused ? 2 : 1

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        spacing: 10

        Text {
            text: "🔍"
            font.pixelSize: 14
            opacity: 0.7
        }

        TextField {
            id: textField
            Layout.fillWidth: true
            placeholderText: "Rechercher..."
            font.pixelSize: 13
            color: isDarkMode ? "#f1f5f9" : "#0f172a"
            placeholderTextColor: isDarkMode ? "#64748b" : "#94a3b8"

            background: Rectangle { color: "transparent" }

            onActiveFocusChanged: root.focused = activeFocus
        }

        // Bouton effacer
        Rectangle {
            implicitWidth: 24
            implicitHeight: 24
            radius: 12
            color: "#64748b"
            visible: textField.text !== ""

            Text {
                anchors.centerIn: parent
                text: "×"
                color: "#ffffff"
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: textField.text = ""
            }
        }
    }
}