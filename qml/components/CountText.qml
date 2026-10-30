import QtQuick
import TechFix

// Nombre qui « compte » de 0 jusqu'à sa valeur (animation à l'ouverture et à chaque changement).
//     CountText { value: 1250000; format: function (v) { return Fmt.ar(v) } }
Txt {
    id: root

    property real value: 0
    property real shown: 0
    property var format: function (v) { return String(Math.round(v)) }

    text: format(shown)

    Behavior on shown {
        NumberAnimation { duration: Theme.durChart * 0.7; easing.type: Easing.OutCubic }
    }

    onValueChanged: shown = value
    Component.onCompleted: Qt.callLater(function () { root.shown = root.value })
}
