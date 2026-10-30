import QtQuick
import TechFix

// Champ de saisie d'un formulaire : libellé, zone de texte, message d'erreur.
//   multiline → zone de texte sur plusieurs lignes     numeric → chiffres seulement
// `initial` n'est lu qu'à la création ; `edited(value)` est émis à chaque frappe.
Item {
    id: root

    property string label: ""
    property string placeholder: ""
    property string icon: ""
    property string suffix: ""
    property string error: ""
    property string initial: ""
    property bool multiline: false
    property bool numeric: false
    property bool required: false
    readonly property alias input: single
    signal edited(string value)

    implicitHeight: col.implicitHeight
    implicitWidth: 300

    Column {
        id: col
        width: parent.width
        spacing: 7

        Row {
            spacing: 4
            visible: root.label !== ""
            Txt { text: root.label; variant: "label"; color: Theme.text; font.pixelSize: Theme.fsMd; font.weight: Font.DemiBold }
            Txt { visible: root.required; text: "*"; color: Theme.danger; font.pixelSize: Theme.fsMd; font.weight: Font.Bold }
        }

        Rectangle {
            id: box
            width: parent.width
            height: root.multiline ? 104 : 44
            radius: Theme.rMd
            color: Theme.surface
            border.width: (single.activeFocus || multi.activeFocus || root.error !== "") ? 2 : 1
            border.color: root.error !== "" ? Theme.danger
                        : (single.activeFocus || multi.activeFocus) ? Theme.primary
                        : hover.hovered ? Theme.borderStrong : Theme.border
            Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

            HoverHandler { id: hover }

            Icon {
                id: lead
                visible: root.icon !== ""
                name: root.icon
                size: 17
                color: (single.activeFocus || multi.activeFocus) ? Theme.primary : Theme.textSubtle
                anchors { left: parent.left; leftMargin: 14; top: root.multiline ? parent.top : undefined; topMargin: 14; verticalCenter: root.multiline ? undefined : parent.verticalCenter }
            }

            TextInput {
                id: single
                visible: !root.multiline
                anchors {
                    left: lead.visible ? lead.right : parent.left
                    leftMargin: lead.visible ? 10 : 14
                    right: suffixText.visible ? suffixText.left : parent.right
                    rightMargin: suffixText.visible ? 8 : 14
                    verticalCenter: parent.verticalCenter
                }
                color: Theme.text
                selectionColor: Theme.primary
                selectedTextColor: Theme.textOnPrimary
                font.family: Theme.fontBody
                font.pixelSize: Theme.fsBase
                clip: true
                selectByMouse: true
                inputMethodHints: root.numeric ? Qt.ImhDigitsOnly : Qt.ImhNone
                validator: root.numeric ? digits : null
                onTextEdited: { root.edited(text) }

                RegularExpressionValidator { id: digits; regularExpression: /^[0-9]{0,9}$/ }

                Text {
                    visible: single.text.length === 0 && single.preeditText.length === 0
                    text: root.placeholder
                    color: Theme.textSubtle
                    font: single.font
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Txt {
                id: suffixText
                visible: root.suffix !== "" && !root.multiline
                text: root.suffix
                variant: "muted"
                anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
            }

            TextEdit {
                id: multi
                visible: root.multiline
                anchors { fill: parent; margins: 14; leftMargin: lead.visible ? 40 : 14 }
                color: Theme.text
                selectionColor: Theme.primary
                selectedTextColor: Theme.textOnPrimary
                font.family: Theme.fontBody
                font.pixelSize: Theme.fsBase
                wrapMode: TextEdit.Wrap
                clip: true
                selectByMouse: true
                onTextChanged: if (activeFocus) root.edited(text)

                Text {
                    visible: multi.text.length === 0 && multi.preeditText.length === 0
                    text: root.placeholder
                    color: Theme.textSubtle
                    font: multi.font
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

            MouseArea {
                anchors.fill: parent
                z: -1
                cursorShape: Qt.IBeamCursor
                onClicked: (root.multiline ? multi : single).forceActiveFocus()
            }
        }

        Row {
            spacing: 6
            visible: root.error !== ""
            Icon { name: "circle-alert"; size: 14; color: Theme.danger; anchors.verticalCenter: parent.verticalCenter }
            Txt { text: root.error; color: Theme.danger; font.pixelSize: Theme.fsSm; anchors.verticalCenter: parent.verticalCenter }
        }
    }

    Component.onCompleted: {
        if (multiline) multi.text = initial
        else single.text = initial
    }
}
