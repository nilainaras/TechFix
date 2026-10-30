import QtQuick
import QtQuick.Layouts
import TechFix

// État vide : « Aucune réparation… » avec une icône et une action facultative.
ColumnLayout {
    id: root

    property string icon: "inbox"
    property string title: "Rien à afficher"
    property string text: ""
    property string actionText: ""
    signal action()

    Layout.fillWidth: true
    Layout.topMargin: 28
    Layout.bottomMargin: 28
    spacing: 10

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: 72
        Layout.preferredHeight: 72
        radius: 36
        color: Theme.primarySoft
        Icon { anchors.centerIn: parent; name: root.icon; size: 30; color: Theme.primary }
    }
    Txt { text: root.title; variant: "h3"; Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 6 }
    Txt {
        visible: root.text !== ""
        text: root.text
        variant: "muted"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: 340
    }
    AppButton {
        visible: root.actionText !== ""
        text: root.actionText
        variant: "soft"
        compact: true
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 6
        onClicked: root.action()
    }
}
