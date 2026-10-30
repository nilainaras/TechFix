import QtQuick
import QtQuick.Layouts
import TechFix

// Barre du haut : recherche globale (Ctrl+K), date, notifications, thème clair/sombre.
Rectangle {
    id: root

    readonly property real margin: UI.compact ? 20 : 32

    function focusSearch() { search.forceFocus() }

    implicitHeight: Theme.topbarHeight
    color: Theme.bg

    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.border }

    RowLayout {
        anchors { fill: parent; leftMargin: root.margin; rightMargin: root.margin }
        spacing: 14

        SearchField {
            id: search
            Layout.preferredWidth: Math.min(460, Math.max(220, root.width * 0.4))
            placeholder: root.width > 900 ? "Rechercher une réparation, un client, un appareil…" : "Rechercher…"
            onTextChanged: {
                if (text.trim().length >= 2) { if (!results.opened) results.open() }
                else results.close()
            }
            onAccepted: {
                var r = AppData.search(text)
                if (r.repairs.length > 0) results.pick(function () { UI.openRepair(r.repairs[0].id) })
            }
        }

        Row {
            visible: root.width > 1000
            spacing: 6
            Rectangle {
                width: kbd.implicitWidth + 14; height: 24; radius: 7
                color: Theme.surfaceAlt; border.width: 1; border.color: Theme.border
                Txt { id: kbd; anchors.centerIn: parent; text: "Ctrl K"; font.pixelSize: Theme.fsXs; font.weight: Font.DemiBold; color: Theme.textSubtle }
            }
        }

        Item { Layout.fillWidth: true }

        Txt {
            visible: root.width > 1100
            text: Fmt.dateLong(AppData.now).charAt(0).toUpperCase() + Fmt.dateLong(AppData.now).slice(1)
            variant: "muted"
        }

        IconButton {
            id: bell
            icon: "bell"
            variant: "surface"
            tip: "Notifications"
            dot: notifs.count > 0
            active: notifs.opened
            onClicked: notifs.opened ? notifs.close() : notifs.open()
        }

        ThemeToggle {}

        IconButton {
            icon: "settings"
            variant: "surface"
            tip: "Paramètres"
            onClicked: UI.go("settings")
        }
    }

    SearchPopup {
        id: results
        query: search.text
        x: search.x + root.margin
        y: root.height - 8
        width: Math.min(560, root.width - root.margin * 2)
        onPicked: search.input.text = ""
    }

    NotificationsPopup {
        id: notifs
        x: root.width - root.margin - width
        y: root.height - 8
    }
}
