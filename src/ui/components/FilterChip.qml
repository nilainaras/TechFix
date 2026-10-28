import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property string label: "Filtre"
    property bool active: false
    property bool isDarkMode: true

    implicitWidth: contentText.implicitWidth + 24
    implicitHeight: 32
    radius: 16

    color: {
        if (root.active) return isDarkMode ? "rgba(0, 212, 255, 0.2)" : "rgba(0, 102, 255, 0.15)"
        return isDarkMode ? "#1e293b" : "#f1f5f9"
    }
    border.color: root.active ? "#00d4ff" : (isDarkMode ? "#334155" : "#e2e8f0")
    border.width: 1

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Text {
        id: contentText
        anchors.centerIn: parent
        text: root.label
        font.pixelSize: 13
        font.weight: root.active ? Font.DemiBold : Font.Normal
        color: root.active ? "#00d4ff" : (isDarkMode ? "#94a3b8" : "#475569")
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.active = !root.active
    }
}