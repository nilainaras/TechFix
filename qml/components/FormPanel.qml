import QtQuick
import QtQuick.Layouts
import TechFix

// Panneau de formulaire générique, piloté par une description :
//   UI.openForm({
//       title, subtitle, icon, submitText,
//       values: { cle: valeurInitiale },
//       fields: [{ key, label, type: "text|phone|number|multiline|select", placeholder, required,
//                  icon, suffix, options (liste ou fonction(values)), dependsOn, emptyText }],
//       onSubmit: function (values) { ... return { ok: true, message: "…" } }
//   })
SidePanel {
    id: root

    property var spec: ({})
    property var values: ({})
    property var errors: ({})
    property int rev: 0
    property var fields: []

    title: spec.title || ""
    subtitle: spec.subtitle || ""
    icon: spec.icon || "pencil"
    onCloseRequested: opened = false

    function open(options) {
        spec = options
        fields = options.fields || []
        var v = {}
        for (var i = 0; i < fields.length; i++) {
            var f = fields[i]
            var init = (options.values && options.values[f.key] !== undefined) ? options.values[f.key] : ""
            v[f.key] = init
        }
        values = v
        errors = ({})
        rev++
        opened = true
    }

    function optionsOf(f) {
        if (typeof f.options === "function") return f.options(values) || []
        return f.options || []
    }

    function setValue(key, val) {
        var v = Object.assign({}, values)
        v[key] = val
        for (var i = 0; i < fields.length; i++) {
            var f = fields[i]
            if (f.dependsOn === key) {
                var opts = typeof f.options === "function" ? f.options(v) : []
                v[f.key] = opts.length === 1 ? opts[0].value : ""
            }
        }
        values = v
        var e = Object.assign({}, errors)
        delete e[key]
        for (var j = 0; j < fields.length; j++)
            if (fields[j].dependsOn === key) delete e[fields[j].key]
        errors = e
        rev++
    }

    function validate() {
        var e = {}
        for (var i = 0; i < fields.length; i++) {
            var f = fields[i]
            var raw = values[f.key]
            var val = (raw === undefined || raw === null) ? "" : String(raw).trim()
            if (f.required && val === "") { e[f.key] = f.type === "select" ? "Veuillez faire un choix." : "Ce champ est obligatoire."; continue }
            if (val === "") continue
            if (f.type === "phone" && !/^[0-9 +]{9,16}$/.test(val)) e[f.key] = "Numéro invalide (ex. 034 12 345 67)."
            if (f.type === "number") {
                var n = parseInt(val, 10)
                if (isNaN(n) || n <= 0) e[f.key] = "Entrez un montant supérieur à 0."
                else if (f.min !== undefined && n < f.min) e[f.key] = "Minimum : " + Fmt.ar(f.min) + "."
                else if (f.max !== undefined && n > f.max) e[f.key] = "Maximum : " + Fmt.ar(f.max) + "."
            }
            if (f.type === "text" && f.minLength && val.length < f.minLength) e[f.key] = "Au moins " + f.minLength + " caractères."
        }
        errors = e
        return Object.keys(e).length === 0
    }

    function submit() {
        if (!validate()) return
        var res = spec.onSubmit ? spec.onSubmit(values) : undefined
        if (res && res.ok === false) {
            UI.toast(res.message || "Action impossible.", "danger")
            return
        }
        opened = false
        if (res && res.message) UI.toast(res.message, "success")
    }

    Repeater {
        model: root.fields

        delegate: Item {
            id: cell
            required property var modelData
            Layout.fillWidth: true
            Layout.preferredHeight: loader.item ? loader.item.implicitHeight : 0

            Loader {
                id: loader
                width: cell.width
                sourceComponent: cell.modelData.type === "select" ? selectC : textC
            }

            Component {
                id: textC
                FormField {
                    label: cell.modelData.label || ""
                    placeholder: cell.modelData.placeholder || ""
                    icon: cell.modelData.icon || ""
                    suffix: cell.modelData.suffix || ""
                    required: !!cell.modelData.required
                    multiline: cell.modelData.type === "multiline"
                    numeric: cell.modelData.type === "number"
                    initial: root.values[cell.modelData.key] === undefined ? "" : String(root.values[cell.modelData.key])
                    error: root.errors[cell.modelData.key] || ""
                    onEdited: (v) => root.setValue(cell.modelData.key, v)
                }
            }
            Component {
                id: selectC
                SelectField {
                    label: cell.modelData.label || ""
                    placeholder: cell.modelData.placeholder || "Sélectionner…"
                    emptyText: cell.modelData.emptyText || "Aucune option disponible"
                    required: !!cell.modelData.required
                    options: { root.rev; return root.optionsOf(cell.modelData) }
                    currentValue: { root.rev; return root.values[cell.modelData.key] }
                    error: root.errors[cell.modelData.key] || ""
                    onActivated: (v) => root.setValue(cell.modelData.key, v)
                }
            }
        }
    }

    footer: [
        AppButton { text: "Annuler"; variant: "secondary"; onClicked: root.opened = false },
        AppButton { text: root.spec.submitText || "Enregistrer"; icon: "check"; onClicked: root.submit() }
    ]
}
