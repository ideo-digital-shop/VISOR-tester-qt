import QtQuick 2.0

Rectangle{
    id: root
    property bool expanded: true

    signal expand
    signal collapse

    smooth: true
    antialiasing: true
    width: 30; height: 30
    radius: 2
    color: "#40FFFFFF"

    Text{
        anchors{centerIn: root}
        text: expanded ? "-" : "+"
        color: "black"        
        font.pixelSize: 24
    }
    MouseArea{
        anchors{fill:root}
        onClicked: {
            if (expanded){
                expanded = false;
                collapse();
            }
            else{
                expanded = true;
                expand();
            }
        }
    }
}
