import QtQuick
import QtQuick.Controls
import TechFix

// Notifications éphémères (« Réparation enregistrée », erreurs de règle métier…).
//   UI.toast("Message", "success" | "danger" | "info")
Item {
    id: root

    // Décalage à droite quand un panneau de formulaire est ouvert (évite de masquer ses boutons)
    property real rightInset: 0
    Behavior on rightInset { NumberAnimation { duration: Theme.durNormal; easing.type: Easing.OutCubic } }

    function show(message, kind) {
        if (toasts.count > 3) toasts.remove(0)
        toasts.append({ message: message, kind: kind || "success" })
    }

    ListModel { id: toasts }

    ListView {
        id: list
        anchors { right: parent.right; bottom: parent.bottom; rightMargin: 24 + root.rightInset; bottomMargin: 24 }
        width: 380
        height: Math.min(parent.height - 48, contentHeight)
        model: toasts
        spacing: 10
        interactive: false
        verticalLayoutDirection: ListView.BottomToTop

        add: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220 }
                NumberAnimation { property: "x"; from: 60; to: 0; duration: 320; easing.type: Easing.OutCubic }
            }
        }
        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 200 }
                NumberAnimation { property: "x"; to: 60; duration: 240; easing.type: Easing.InCubic }
            }
        }
        displaced: Transition { NumberAnimation { property: "y"; duration: 240; easing.type: Easing.OutCubic } }

        delegate: Item {
            id: toast
            required property int index
            required property string message
            required property string kind
            readonly property color tone: kind === "danger" ? Theme.danger : kind === "info" ? Theme.primary : Theme.success

            width: list.width
            height: card.height

            Rectangle {
                id: card
                width: parent.width
                height: Math.max(56, msg.implicitHeight + 28)
                radius: Theme.rMd
                color: Theme.surface
                border.width: 1
                border.color: Theme.border

                Rectangle {
                    width: 4
                    height: parent.height - 20
                    radius: 2
                    color: toast.tone
                    anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                }

                Rectangle {
                    id: badge
                    width: 30; height: 30; radius: 15
                    color: Theme.tint(toast.tone)
                    anchors { left: parent.left; leftMargin: 26; verticalCenter: parent.verticalCenter }
                    Icon {
                        anchors.centerIn: parent
                        name: toast.kind === "danger" ? "circle-alert" : toast.kind === "info" ? "info" : "circle-check"
                        size: 17
                        color: toast.tone
                    }
                }
                Txt {
                    id: msg
                    anchors { left: badge.right; leftMargin: 12; right: closeBtn.left; rightMargin: 8; verticalCenter: parent.verticalCenter }
                    text: toast.message
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fsMd
                    font.weight: Font.Medium
                }
                Item {
                    id: closeBtn
                    width: 28; height: 28
                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
                    Icon { anchors.centerIn: parent; name: "x"; size: 14; color: Theme.textSubtle }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: toasts.remove(toast.index) }
                }
            }

            // ombre
            Rectangle { z: -1; anchors.fill: card; anchors.topMargin: 5; radius: Theme.rMd; color: Theme.shadow; opacity: 0.45 }

            Timer {
                interval: toast.kind === "danger" ? 5200 : 3600
                running: true
                onTriggered: if (toast.index >= 0 && toast.index < toasts.count) toasts.remove(toast.index)
            }
        }
    }
}
