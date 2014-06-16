import QtQuick 2.0

Rectangle{
    id: root
    property color sectionColor: "#703A50"
    property real sectionColorRed: sectionColor.r
    property real sectionColorGreen: sectionColor.g
    property real sectionColorBlue: sectionColor.b
    property string mainLabelText: "MAIN LABEL"
    property alias mainLabel: mainLabelBack

    smooth:true; antialiasing: true
    radius: 2
    clip: true
    color: Qt.rgba(sectionColorRed,sectionColorGreen,sectionColorBlue,.0625)
    border{width:1.5;color:"#40FFFFFF"}
    width: childrenRect.width + 16
    height: expander.expanded ? root.childrenRect.height + 16 : mainLabelBack.height + 2*mainLabelBack.y
    Behavior on height{NumberAnimation{duration: 175; easing.type: Easing.InOutQuad}}

    Rectangle{id: mainLabelBack
        x:8
        y:8
        height: mainLabel.contentHeight+8
        width: mainLabel.contentWidth+8
        color: Qt.rgba(sectionColorRed,sectionColorGreen,sectionColorBlue,.25)
        Text{id: mainLabel
            anchors{centerIn:parent}
            text: mainLabelText
            color: "#DFDFDF"
            Behavior on color{ColorAnimation{duration:200}}            
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: 30
            font.pixelSize: 22
        }
    }
    Expander{
        id: expander
        anchors{verticalCenter: mainLabelBack.verticalCenter; left: mainLabelBack.right; leftMargin: 20}
        expanded: true
        onCollapse: root.height = mainLabelBack.height + 2*mainLabelBack.y
        onExpand: root.height = root.childrenRect.height + 16
    }
}

