import QtQuick
import QtQuick.Layouts
import TechFix

// Ligne compacte d'une réparation (liste, tableau de bord). Un clic ouvre le détail.
//   rep : objet fourni par AppData.repairView()      compact → masque le technicien et la panne
Card {
    id: root

    property var rep: ({})
    property bool compact: false
    property bool showCost: true

    padding: 14
    clickable: true
    onClicked: UI.openRepair(rep.id)

    RowLayout {
        Layout.fillWidth: true
        spacing: 14

        Rectangle {
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            radius: Theme.rMd
            color: Theme.statusSoft(root.rep.statut)
            Icon { anchors.centerIn: parent; name: root.rep.icon || "wrench"; size: 21; color: Theme.statusColor(root.rep.statut) }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                spacing: 8
                Txt { text: root.rep.label; variant: "strong"; Layout.fillWidth: true; elide: Text.ElideRight }
                Tag { visible: root.rep.late === true; text: "En retard"; tone: "danger"; small: true; icon: "clock" }
            }
            Txt {
                Layout.fillWidth: true
                elide: Text.ElideRight
                variant: "caption"
                text: root.compact ? root.rep.code + " · " + root.rep.clientName
                                   : root.rep.code + " · " + root.rep.clientName + " · " + root.rep.panne
            }
        }

        RowLayout {
            visible: !root.compact && root.width > 820
            spacing: 8
            Layout.preferredWidth: 190
            Avatar { name: root.rep.technicienName || ""; size: 28 }
            Txt { text: root.rep.technicienName; variant: "muted"; font.pixelSize: Theme.fsMd; Layout.fillWidth: true; elide: Text.ElideRight }
        }

        StatusBadge { status: root.rep.statut === undefined ? 0 : root.rep.statut }

        Txt {
            visible: root.showCost && root.width > 600
            text: root.rep.cout > 0 ? Fmt.ar(root.rep.cout) : "—"
            variant: "strong"
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: 104
            color: root.rep.cout > 0 ? Theme.text : Theme.textSubtle
        }

        Icon { name: "chevron-right"; size: 18; color: Theme.textSubtle }
    }
}
