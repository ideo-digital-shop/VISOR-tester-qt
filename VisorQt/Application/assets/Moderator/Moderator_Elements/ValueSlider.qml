import QtQuick 2.0

Item{id: root
    smooth:true; antialiasing: true
    width: childrenRect.width
    height: childrenRect.height

    property real targetSynch: minValue
    property real minValue: 0
    property real maxValue: 10
    property real currentValue: targetSynch
    property color labelColor: "#803A5050"
    property string labelText: "SLIDER"
    property int sliderWidth: 100
    property int decimalPlaces: 0
    property real initialValue: 0

    Component.onCompleted: {
        targetSynch = initialValue;
    }

    Rectangle{
        id: sliderLabel
        height: sliderLabelText.contentHeight + 8
        width: sliderLabelText.contentWidth + 8
        color: labelColor
        Text {
            id: sliderLabelText
            anchors{centerIn:parent}
            text: labelText
            color: "#DFDFDF"            
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: 30
            font.pixelSize: 18
        }
    }
    Button{
        id: sliderSlot
        anchors {top: sliderLabel.bottom; topMargin: 10; left: sliderLabel.left}
        smooth:true; antialiasing: true
        width: sliderWidth
        height: 8
        radius: 2
        active: true
        gradientOpacity: .25
        onClicked: {
            targetSynch = ((mouseArea.mouseX/(sliderWidth-sliderButton.width)) * (maxValue - minValue) + minValue);
            sliderButton.refreshPosition();
        }
    }
    Button{
        id: sliderButton
        smooth:true; antialiasing: true
        anchors {verticalCenter: sliderSlot.verticalCenter}
        borderColor: "#E0E0E0"
        width: 16
        height: 16
        radius: 2
        active: false
        mouseArea.drag.axis: Drag.XAxis
        Component.onCompleted: refreshPosition();
        mouseArea.drag.maximumX: sliderWidth-width;
        mouseArea.drag.minimumX: 0;
        mouseArea.drag.target: sliderButton
        onXChanged: targetSynch = ((x/(sliderWidth-width)) * (maxValue - minValue) + minValue);
        function refreshPosition(){
            x = (targetSynch - minValue)/(maxValue - minValue) * (sliderWidth-width);
        }
    }
    Text {
        id: sliderValue
        width: 30
        text: targetSynch.toFixed(1)
        anchors {verticalCenter: sliderSlot.verticalCenter; left: sliderSlot.right; leftMargin: 20}        
        font.pixelSize: 18
        color: "#DFDFDF"
    }
}
