import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TechFix

// Squelette commun des pages : en-tête (titre, sous-titre, actions) + zone défilante
// dont le contenu est centré avec une largeur maximale (utile sur grand écran).
Flickable {
    id: root

    property string title: ""
    property string subtitle: ""
    property bool showBack: false
    property real maxContentWidth: 1560
    readonly property real margin: UI.compact ? 20 : 32
    default property alias content: body.data
    property alias actions: actionRow.data
    signal backClicked()

    clip: true
    contentWidth: width
    contentHeight: column.implicitHeight + 64
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.VerticalFlick
    ScrollBar.vertical: AppScrollBar {}

    ColumnLayout {
        id: column
        y: 8
        width: Math.min(root.maxContentWidth, root.width - root.margin * 2)
        x: (root.width - width) / 2
        spacing: 24

        RowLayout {
            Layout.fillWidth: true
            spacing: 14

            IconButton {
                visible: root.showBack
                icon: "arrow-left"
                variant: "surface"
                tip: "Retour"
                size: 42
                Layout.alignment: Qt.AlignVCenter
                onClicked: root.backClicked()
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3
                Txt { text: root.title; variant: "h1"; Layout.fillWidth: true; elide: Text.ElideRight }
                Txt {
                    visible: root.subtitle !== ""
                    text: root.subtitle
                    variant: "muted"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }

            Row {
                id: actionRow
                spacing: 10
                Layout.alignment: Qt.AlignVCenter
            }
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            spacing: 22
        }
    }
}
