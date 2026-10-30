import QtQuick
import QtQuick.Layouts
import TechFix

// Carte d'une réparation (vue en grille et colonnes du kanban).
Card {
    id: root

    property var rep: ({})
    property bool showStatus: true       // masqué dans le kanban (la colonne indique déjà le statut)

    padding: 18
    spacing: 14
    clickable: true
    onClicked: UI.openRepair(rep.id)

    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        Rectangle {
            Layout.preferredWidth: 46
            Layout.preferredHeight: 46
            radius: Theme.rMd
            color: Theme.statusSoft(root.rep.statut)
            Icon { anchors.centerIn: parent; name: root.rep.icon || "wrench"; size: 22; color: Theme.statusColor(root.rep.statut) }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1
            Txt { text: root.rep.label; variant: "strong"; font.pixelSize: Theme.fsLg - 1; Layout.fillWidth: true; elide: Text.ElideRight }
            Txt { text: root.rep.code + " · " + root.rep.type; variant: "caption"; Layout.fillWidth: true; elide: Text.ElideRight }
        }
        StatusBadge { visible: root.showStatus; status: root.rep.statut === undefined ? 0 : root.rep.statut }
    }

    Txt {
        text: root.rep.panne
        variant: "muted"
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        maximumLineCount: 2
        elide: Text.ElideRight
        lineHeight: 1.2
    }

    ProgressDots {
        Layout.fillWidth: true
        status: root.rep.statut === undefined ? 0 : root.rep.statut
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8
        Avatar { name: root.rep.clientName || ""; size: 26 }
        Txt { text: root.rep.clientName; font.pixelSize: Theme.fsMd; Layout.fillWidth: true; elide: Text.ElideRight }
        Txt {
            text: root.rep.cout > 0 ? Fmt.ar(root.rep.cout) : "Devis à venir"
            variant: root.rep.cout > 0 ? "strong" : "caption"
            font.pixelSize: Theme.fsMd
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6
        Icon { name: "clock"; size: 14; color: root.rep.late ? Theme.danger : Theme.textSubtle }
        Txt {
            text: root.rep.age === 0 ? "Déposé aujourd'hui" : "Déposé il y a " + root.rep.age + (root.rep.age > 1 ? " jours" : " jour")
            variant: "caption"
            color: root.rep.late ? Theme.danger : Theme.textSubtle
            Layout.fillWidth: true
        }
        Tag { visible: root.rep.late === true; text: "En retard"; tone: "danger"; small: true }
    }
}
