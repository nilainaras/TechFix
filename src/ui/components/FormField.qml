import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string label: "Champ"
    property string placeholderText: ""
    property string value: ""
    property string errorText: ""
    property bool required: false
    property bool isDarkMode: true
    property bool isTextArea: false

    spacing: 6

    // Label
    Row {
        spacing: 4
        Layout.fillWidth: true

        Text {
            text: root.label
            font.pixelSize: 13
            font.bold: true
            color: isDarkMode ? "#f1f5f9" : "#0f172a"
        }

        Text {
            text: "*"
            color: "#ff3366"
            font.pixelSize: 13
            font.bold: true
            visible: root.required
        }
    }

    // Champ de saisie
    Loader {
        Layout.fillWidth: true
        sourceComponent: root.isTextArea ? textAreaComponent : textFieldComponent
    }

    // Message d'erreur
    Text {
        text: root.errorText
        font.pixelSize: 11
        color: "#ff3366"
        visible: root.errorText !== ""
        Layout.fillWidth: true
    }

    Component {
        id: textFieldComponent
        TextField {
            placeholderText: root.placeholderText
            text: root.value
            font.pixelSize: 14
            color: isDarkMode ? "#f1f5f9" : "#0f172a"
            placeholderTextColor: isDarkMode ? "#64748b" : "#94a3b8"
            background: Rectangle {
                radius: 10
                color: isDarkMode ? "#111827" : "#ffffff"
                border.color: root.errorText !== "" ? "#ff3366" : (isDarkMode ? "#334155" : "#e2e8f0")
                border.width: 1
            }
            onTextChanged: root.value = text
        }
    }

    Component {
        id: textAreaComponent
        TextArea {
            placeholderText: root.placeholderText
            text: root.value
            font.pixelSize: 14
            color: isDarkMode ? "#f1f5f9" : "#0f172a"
            placeholderTextColor: isDarkMode ? "#64748b" : "#94a3b8"
            wrapMode: TextArea.Wrap
            background: Rectangle {
                radius: 10
                color: isDarkMode ? "#111827" : "#ffffff"
                border.color: root.errorText !== "" ? "#ff3366" : (isDarkMode ? "#334155" : "#e2e8f0")
                border.width: 1
            }
            onTextChanged: root.value = text
        }
    }
}