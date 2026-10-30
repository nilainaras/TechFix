import QtQuick
import QtQuick.Layouts
import TechFix

// Boîte de confirmation (suppression, action irréversible…).
//   UI.confirm({ title, message, confirmText, tone: "danger"|"primary", icon, onConfirm: function () {...} })
Item {
    id: root

    property bool opened: false
    property var spec: ({})
    readonly property string tone: spec.tone || "danger"

    visible: scrim.opacity > 0.01

    function open(options) { spec = options; opened = true }
    function close() { opened = false }

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: Theme.scrim
        opacity: root.opened ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Theme.durNormal } }
        MouseArea { anchors.fill: parent; enabled: root.opened; onClicked: root.close() }
    }

    Shortcut { sequence: "Escape"; enabled: root.opened; onActivated: root.close() }

    Rectangle {
        id: card
        width: Math.min(440, root.width - 40)
        height: content.implicitHeight + 56
        anchors.centerIn: parent
        radius: Theme.rXl
        color: Theme.surface
        border.width: 1
        border.color: Theme.border
        opacity: root.opened ? 1 : 0
        scale: root.opened ? 1 : 0.92
        Behavior on opacity { NumberAnimation { duration: Theme.durNormal } }
        Behavior on scale { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }

        MouseArea { anchors.fill: parent }

        ColumnLayout {
            id: content
            x: 28
            y: 28
            width: parent.width - 56
            spacing: 14

            Rectangle {
                Layout.preferredWidth: 54
                Layout.preferredHeight: 54
                radius: 27
                color: root.tone === "danger" ? Theme.dangerSoft : Theme.primarySoft
                Icon {
                    anchors.centerIn: parent
                    name: root.spec.icon || (root.tone === "danger" ? "trash-2" : "circle-alert")
                    size: 26
                    color: root.tone === "danger" ? Theme.danger : Theme.primary
                }
            }
            Txt { text: root.spec.title || ""; variant: "h2"; Layout.fillWidth: true; wrapMode: Text.WordWrap }
            Txt { text: root.spec.message || ""; variant: "muted"; Layout.fillWidth: true; wrapMode: Text.WordWrap; lineHeight: 1.25 }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10
                spacing: 10
                Item { Layout.fillWidth: true }
                AppButton { text: "Annuler"; variant: "secondary"; onClicked: root.close() }
                AppButton {
                    text: root.spec.confirmText || "Confirmer"
                    variant: root.tone === "danger" ? "danger" : "primary"
                    onClicked: {
                        root.close()
                        if (root.spec.onConfirm) root.spec.onConfirm()
                    }
                }
            }
        }
    }
}
