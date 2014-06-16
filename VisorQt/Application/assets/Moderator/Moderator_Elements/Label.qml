
import QtQuick 2.0

Rectangle{
    id: root

    property string label: "LABEL"

    height: labelText.contentHeight + 8
    width: labelText.contentWidth + 8
    Text {
        id: labelText
        anchors{centerIn:parent}
        text: label
        color: "#F0F0F0"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        height: 30
        font.pixelSize: 20
    }
}
