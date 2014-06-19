
import QtQuick 2.0

Rectangle{id: root
    smooth:true; antialiasing: true

    property color fillColor: active ? "#D0D0D0" : "#101010"
    property color textColor: active ? "#101010": "#CFCFCF"
    property color borderColor: "#AFAFAF"
    property string label: ""
    property int labelSize: 18
    property bool clickAnimateEnable: false
    property bool animateClick: false
    property alias labelObj: label
    property bool active: false
    property alias mouseArea: mouseArea
    property real gradientOpacity: .75

    signal clicked

    function clickSim(){
        console.debug("blarg")
        clicked();
    }

    Component.onCompleted: mouseArea.onPressed.connect(clicked);

    color: fillColor

    radius: 4
    border{width:2; color:borderColor}
    clip:true
    Behavior on opacity {NumberAnimation{duration: 350}}

    opacity: 1
    Rectangle{
        id: gradientContainer
        anchors{fill:parent}
        radius:parent.radius
        opacity:gradientOpacity
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FF555658" }
            GradientStop { position: 0.438; color: "#00000000" }
        }
    }
    Text{id: label
        smooth:true; antialiasing: true        
        font.pixelSize: labelSize
        text: root.label
        anchors{fill:parent; leftMargin: 7; rightMargin: 7}
        clip: true
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: textColor
    }
    MouseArea{id: mouseArea
        property bool toggle: false
        anchors{fill: parent}
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if(animateClick)clickDetectAnimation.start();
            clickedAnimation.start();
        }
    }
    function clickDetector(){
        //console.debug(version + " moderator: button click detected");
        clickDetectAnimation.start();
    }
    SequentialAnimation{id: clickDetectAnimation; running: true
        PropertyAnimation{target:root; property: "color"; to: Qt.lighter(fillColor,3); duration: 350; easing.type: Easing.OutQuad}
        PropertyAnimation{target:root; property: "color"; to: fillColor; duration: 350; easing.type: Easing.OutQuad}
    }
    SequentialAnimation{id: clickedAnimation
        PropertyAnimation{target:root; property: "border.color"; to: Qt.lighter(borderColor,1.5); duration: 350; easing.type: Easing.OutQuad}
        PropertyAnimation{target:root; property: "border.color"; to: borderColor; duration: 350; easing.type: Easing.OutQuad}
    }
}
