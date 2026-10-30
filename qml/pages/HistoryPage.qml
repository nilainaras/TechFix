import QtQuick
import QtQuick.Layouts
import TechFix

// Historique : tout ce qui s'est passé à l'atelier, jour après jour.
PageScaffold {
    id: page

    title: "Historique"
    subtitle: "Dépôts, changements d'étape et interventions"

    property string kind: "all"             // all | statut | intervention
    property int shown: 30

    readonly property var events: AppData.events(0)
    readonly property var filtered: events.filter(function (e) { return kind === "all" || e.kind === kind })

    readonly property var chips: [
        { label: "Tout", value: "all", count: events.length },
        { label: "Étapes", value: "statut", count: events.filter(function (e) { return e.kind === "statut" }).length },
        { label: "Interventions", value: "intervention", count: events.filter(function (e) { return e.kind === "intervention" }).length }
    ]

    // regroupement par jour
    readonly property var groups: {
        var out = []
        var list = filtered.slice(0, shown)
        var current = null
        for (var i = 0; i < list.length; i++) {
            var key = Fmt.startOfDay(list[i].date).getTime()
            if (!current || current.key !== key) {
                current = { key: key, date: list[i].date, items: [] }
                out.push(current)
            }
            current.items.push(list[i])
        }
        return out
    }

    function toneOf(e) {
        return e.kind === "intervention" ? Theme.warning : Theme.statusColor(e.statut)
    }
    function softOf(e) {
        return e.kind === "intervention" ? Theme.warningSoft : Theme.statusSoft(e.statut)
    }
    function dayTitle(d) {
        var rel = Fmt.relativeDay(d)
        var full = Fmt.dateLong(d)
        full = full.charAt(0).toUpperCase() + full.slice(1)
        return (rel === "Aujourd'hui" || rel === "Hier") ? rel + " · " + full : full
    }

    FilterChips {
        Layout.fillWidth: true
        model: page.chips
        current: page.kind
        onSelected: (v) => { page.kind = v; page.shown = 30 }
    }

    EmptyState {
        visible: page.filtered.length === 0
        icon: "history"
        title: "Rien à afficher"
        text: "L'historique se remplit dès qu'un appareil est déposé à l'atelier."
    }

    Repeater {
        model: page.groups
        delegate: ColumnLayout {
            id: day
            required property var modelData
            Layout.fillWidth: true
            spacing: 10

            Txt { text: page.dayTitle(day.modelData.date); variant: "h3"; Layout.leftMargin: 4 }

            Card {
                padding: 8
                spacing: 0

                Repeater {
                    model: day.modelData.items
                    delegate: Rectangle {
                        id: ev
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        Layout.preferredHeight: 66
                        radius: Theme.rMd
                        color: evArea.containsMouse ? Theme.surfaceAlt : "transparent"
                        Behavior on color { ColorAnimation { duration: Theme.durFast } }

                        RowLayout {
                            anchors { fill: parent; leftMargin: 10; rightMargin: 12 }
                            spacing: 14
                            Rectangle {
                                Layout.preferredWidth: 40; Layout.preferredHeight: 40; radius: 20
                                color: page.softOf(ev.modelData)
                                Icon { anchors.centerIn: parent; name: ev.modelData.icon; size: 19; color: page.toneOf(ev.modelData) }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1
                                Txt { text: ev.modelData.title; variant: "strong"; Layout.fillWidth: true; elide: Text.ElideRight }
                                Txt { text: ev.modelData.subtitle; variant: "caption"; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                            Tag { visible: page.width > 700; text: ev.modelData.code; small: true }
                            Txt { text: Fmt.time(ev.modelData.date); variant: "muted"; font.pixelSize: Theme.fsMd; Layout.preferredWidth: 46; horizontalAlignment: Text.AlignRight }
                        }
                        MouseArea {
                            id: evArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: UI.openRepair(ev.modelData.repId)
                        }
                    }
                }
            }
        }
    }

    AppButton {
        visible: page.filtered.length > page.shown
        text: "Afficher plus d'événements"
        icon: "chevron-down"
        variant: "secondary"
        Layout.alignment: Qt.AlignHCenter
        onClicked: page.shown += 30
    }
}
