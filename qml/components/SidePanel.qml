import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TechFix

// Panneau latéral qui glisse depuis la droite (formulaires d'ajout / modification).
// À placer en plein écran au-dessus de l'interface (voir Main.qml).
Item {
    id: root

    property bool opened: false
    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property real panelWidth: Math.min(500, width - 24)
    default property alias content: body.data
    property alias footer: footerRow.data
    signal closeRequested()

    visible: scrim.opacity > 0.01 || panel.x < width - 1

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: Theme.scrim
        opacity: root.opened ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Theme.durNormal } }
        MouseArea { anchors.fill: parent; enabled: root.opened; onClicked: root.closeRequested() }
    }

    Shortcut { sequence: "Escape"; enabled: root.opened; onActivated: root.closeRequested() }

    Rectangle {
        id: panel
        width: root.panelWidth
        height: parent.height
        x: root.opened ? parent.width - width : parent.width + 30
        color: Theme.surface
        Behavior on x { NumberAnimation { duration: Theme.durSlow; easing.type: Easing.OutCubic } }

        Rectangle { anchors.left: parent.left; width: 1; height: parent.height; color: Theme.border }

        MouseArea { anchors.fill: parent }   // absorbe les clics

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // ── en-tête ──
            RowLayout {
                Layout.fillWidth: true
                Layout.margins: 24
                Layout.bottomMargin: 18
                spacing: 14

                Rectangle {
                    visible: root.icon !== ""
                    Layout.preferredWidth: 44
                    Layout.preferredHeight: 44
                    radius: Theme.rMd
                    color: Theme.primarySoft
                    Icon { anchors.centerIn: parent; name: root.icon; size: 22; color: Theme.primary }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Txt { text: root.title; variant: "h2"; Layout.fillWidth: true; elide: Text.ElideRight }
                    Txt { visible: root.subtitle !== ""; text: root.subtitle; variant: "muted"; Layout.fillWidth: true; elide: Text.ElideRight; font.pixelSize: Theme.fsMd }
                }
                IconButton { icon: "x"; tip: "Fermer"; onClicked: root.closeRequested() }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }

            // ── contenu défilant ──
            Flickable {
                id: flick
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: width
                contentHeight: body.implicitHeight + 48
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: AppScrollBar {}

                ColumnLayout {
                    id: body
                    x: 24
                    y: 24
                    width: flick.width - 48
                    spacing: 18
                }
            }

            // ── pied ──
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
            Row {
                id: footerRow
                Layout.alignment: Qt.AlignRight
                Layout.margins: 18
                spacing: 10
            }
        }
    }
}
