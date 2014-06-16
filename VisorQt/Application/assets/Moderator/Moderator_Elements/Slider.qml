import QtQuick 2.0

Item{id: root
    smooth:true; antialiasing: true
    width: childrenRect.width
    height: childrenRect.height

    property variant targetSynch
    property real minValue: 0
    property real maxValue: 10
    property real currentValue: targetSynch.get()
    property color labelColor: "#803A5050"
    property string labelText: "SLIDER"
    property int sliderWidth: 100
    property int decimalPlaces: 0
    property bool showLabel: true

    Rectangle{
        id: sliderLabel
        height: sliderLabelText.contentHeight + 8
        width: sliderLabelText.contentWidth + 8        
        color: labelColor
        visible: showLabel
        Text {
            id: sliderLabelText
            anchors{centerIn:parent}
            text: labelText
            color: "#DFDFDF"
            font.family: hmicondensed.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: 30
            font.pixelSize: 28
        }
    }
    Button{
        id: sliderSlot
        anchors.top: root.top;
        anchors.topMargin: showLabel ? 45 : 15;
        anchors.left: sliderLabel.left;
        smooth:true; antialiasing: true
        width: sliderWidth
        height: 4
        radius: 2
        active: true
        gradientOpacity: .25
        onClicked: {
            targetSynch.set((mouseArea.mouseX/(sliderWidth-sliderButton.width)) * (maxValue - minValue) + minValue);
            sliderButton.refreshPosition();
        }
    }
    Button{
        id: sliderButton
        smooth:true; antialiasing: true
        anchors.verticalCenter: sliderSlot.verticalCenter
        borderColor: "#E0E0E0"
        width: 8
        height: 12
        radius: 2
        active: false
        mouseArea.drag.axis: Drag.XAxis
        Component.onCompleted: refreshPosition();
        mouseArea.drag.maximumX: sliderWidth-width;
        mouseArea.drag.minimumX: 0;
        mouseArea.drag.target: sliderButton
        onXChanged: targetSynch.set((x/(sliderWidth-width)) * (maxValue - minValue) + minValue);
        function refreshPosition(){
            x = (targetSynch.get() - minValue)/(maxValue - minValue) * (sliderWidth-width);
        }
    }
    Text {
        id: sliderValue
        width: 30
        text: targetSynch.get().toFixed(decimalPlaces)
        anchors {verticalCenter: sliderSlot.verticalCenter; left: sliderSlot.right; leftMargin: 10}        
        font.pixelSize: 20
        color: "#DFDFDF"
    }
}
