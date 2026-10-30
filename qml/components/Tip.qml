import QtQuick
import QtQuick.Controls
import TechFix

// Info-bulle élégante. Usage dans un élément :  Tip { text: "Modifier"; visible: mouse.containsMouse }
ToolTip {
    id: tip

    property string side: "bottom"      // bottom | top | right

    delay: 450
    timeout: 4000
    padding: 8
    leftPadding: 11
    rightPadding: 11

    x: side === "right" ? parent.width + 10 : (parent.width - width) / 2
    y: side === "right" ? (parent.height - height) / 2
       : side === "top" ? -height - 8
       : parent.height + 8

    contentItem: Text {
        text: tip.text
        color: "#EAF0FA"
        font.family: Theme.fontBody
        font.pixelSize: Theme.fsSm
        font.weight: Font.Medium
    }
    background: Rectangle {
        radius: 8
        color: Theme.dark ? "#2C3B5E" : "#1B2740"
    }

    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 120 } }
    exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 80 } }
}
