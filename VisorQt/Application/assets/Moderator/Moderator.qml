import QtQuick 2.0
import Lemma 1.0
import QtGraphicalEffects 1.0

import "Moderator_Elements"

Rectangle{
    id: container     //allows for fullscreen switching without root distortion
    width: root.width
    height: root.height
    property string version: "Moderator 0.0.1"

    property bool clusterShown: true
    signal showCluster(bool showCluster)

    property bool hudShown: true
    signal showHud(bool showHud)

    property int wiperNumber: 0
    property int lightNumber: 0

    color: "#333"

    Rectangle {
        id: root
        property variant selectedOrthographies: []
        width: childrenRect.width+20
        height: childrenRect.height+20

        color: parent.color
        clip: true

        Column{
            id: columnA
            width: 340
            spacing: 20
            height: container.height
            Item{width:1;height:1}
            x:20;
            Button{
                id: sendFlashButton
                width: 120
                height: 30
                label: "Send Flash"
                fillColor: "#0A2036"
                textColor: "#DFDFDF"
                animateClick: true
                onClicked: {
                    if(!noamIsConnected)sendFlashSignal();
                    else noamLemma.speak("sendFlashSignal", true);
                }
            }            
            Item{
                height: childrenRect.height
                width: childrenRect.width
                Button{
                    id: sendOverviewButton1
                    width: 160
                    height: 30
                    label: "Woz Overview 1"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.woz1();
                }
                Button{
                    id: sendOverviewButton2
                    anchors{ left: sendOverviewButton1.right; leftMargin: 8}
                    width: 160
                    height: 30
                    label: "Woz Overview 2"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.woz2();
                }
            }
            Button{
                id: toggleFlashScanButton
                x:8
                width: 200
                height: 30
                label: active ? "Flashlight Scan On" : "Flashlight Scan Off"
                active: rootStateModel.flashlightIsScanning.get()
                onClicked: rootStateModel.flashlightIsScanning.set( !rootStateModel.flashlightIsScanning.get() );
            }
            Button{
                id: toggleVibeMode
                x:8
                width: 200
                height: 30
                label: active ? "Vibe Mode On" : "Vibe Mode Off"
                active: rootStateModel.vibeMode.get()
                onClicked: rootStateModel.vibeMode.set(!rootStateModel.vibeMode.get());
            }
            ValueSlider{
                id: repeatTimeSlider
                sliderWidth: 240
                minValue: .15
                maxValue: 5
                initialValue: rootStateModel.repeatTime.initialValue;
                labelText: "Repeat Time"
                onCurrentValueChanged: {
                    rootStateModel.repeatTime.set( targetSynch );
                }
            }            
            ValueSlider{
                id: motorIntensitySlider
                sliderWidth: 240
                minValue: 400
                maxValue: 4095
                intMode: true
                initialValue: parseInt( rootStateModel.motorIntensity.initialValue );
                labelText: "Motor Intensity"
                onCurrentValueChanged: {
                    rootStateModel.motorIntensity.set( parseInt(targetSynch).toString() );
                }
            }
            ValueSlider{
                id: motorDurationSlider
                sliderWidth: 240
                minValue: 150
                maxValue: 5000
                intMode: true
                initialValue: parseInt( rootStateModel.motorDuration.initialValue );
                labelText: "Motor Duration"
                onCurrentValueChanged: {
                    rootStateModel.motorDuration.set( parseInt(targetSynch).toString() );
                }
            }

            SelectorCluster{
                id: flashScanModeSelector
                width: 320
                height: 94
                labelText: "Flashlight Scan Mode"
                onSelectedSignal: {
                    rootStateModel.flashlightScanMode.set( selectionParameter );
                }
                SelectorButton{
                    id: timer
                    anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                    label: "Timer"
                    selectionParameter: "timer"
                    width: 120
                    height: 30
                    active: (rootStateModel.flashlightScanMode.get() === "timer")
                }
                SelectorButton{
                    id: newDude
                    anchors {left: timer.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                    label: "New"
                    selectionParameter: "new"
                    width: 120
                    height: 30
                    active: (rootStateModel.flashlightScanMode.get() === "new")
                }
            }           
        }

        Column{
            id: columnB
            width: 340
            spacing: 20
            height: container.height
            anchors {left: columnA.right; leftMargin: 20}          
            SelectorCluster{
                id: imuSelector
                width: 320
                height: 134
                labelText: "Heading Source"
                onSelectedSignal: {
                    rootStateModel.headingSource.set( selectionParameter );
                }

                SelectorButton{
                    id: imuHead
                    anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                    label: "Head"
                    selectionParameter: "head"
                    width: 120
                    height: 30
                    active: (rootStateModel.headingSource.get() === "head")
                }
                SelectorButton{
                    id: imuBody
                    anchors {left:imuHead.right; leftMargin:8; top:imuHead.top}
                    label: "Body"
                    selectionParameter: "body"
                    width: 120
                    height: 30
                    active: (rootStateModel.headingSource.get() === "body")
                }
                SelectorButton{
                    id: imuManual
                    anchors {left:imuHead.left; topMargin:8; top:imuHead.bottom}
                    label: "Manual"
                    selectionParameter: "manual"
                    width: 120
                    height: 30
                    active: (rootStateModel.headingSource.get() === "manual")
                }
                SelectorButton{
                    id: imuGesture
                    anchors {left:imuManual.right; leftMargin:8; top:imuManual.top}
                    label: "Gesture"
                    selectionParameter: "gesture"
                    width: 120
                    height: 30
                    active: (rootStateModel.headingSource.get() === "gesture")

                }
            }
            Item{width:1;height:1}
            Rectangle {
                id: nudgeCluster
                width: 320
                height: 46
                color: "#68555555"
                radius: 2
                Button{
                    id: nudgeLeft
                    width: 140
                    height: 30
                    anchors {left: parent.left; top: parent.top; leftMargin: 8; topMargin: 8}
                    label: "Nudge Left"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.nudgeLeft();
                }
                Button{
                    id: nudgeRight
                    width: 140
                    height: 30
                    anchors {left: nudgeLeft.right; top: parent.top; leftMargin: 8; topMargin: 8}
                    label: "Nudge Right"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.nudgeRight();
                }
            }
            Rectangle {
                id: turnCluster
                width: 320
                height: 92
                color: "#68555555"
                radius: 2
                Button{
                    id: turnLeft
                    width: 140
                    height: 30
                    anchors {left: parent.left; top: parent.top; leftMargin: 8; topMargin: 8}
                    label: "Turn Left"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.turnLeft();
                }
                Button{
                    id: turnRight
                    width: 140
                    height: 30
                    anchors {left: turnLeft.right; top: parent.top; leftMargin: 8; topMargin: 8}
                    label: "Turn Right"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.turnRight();
                }
                Button{
                    id: goForward
                    width: 140
                    height: 30
                    anchors {left: parent.left; top: turnLeft.bottom; leftMargin: 8; topMargin: 8}
                    label: "Forward"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.sendPlayAudioMsg("goForward");
                }
            }
            Rectangle {
                id: uiCluster
                width: 320
                height: 230
                color: "#68555555"
                radius: 2
                Button{
                    id: confirmArrival
                    width: 150
                    height: 30
                    anchors {left: parent.left; top: parent.top; leftMargin: 8; topMargin: 8}
                    label: "Nav Arrive"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.arrivedAt(rootStateModel.targetObject.get());
                }
                Button{
                    id: confirmBegin
                    width: 150
                    height: 30
                    anchors {left: confirmArrival.right; top: parent.top; leftMargin: 8; topMargin: 8}
                    label: "Nav Begin"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.headingTo(rootStateModel.targetObject.get());
                }
                Button{
                    id: bookmark
                    width: 150
                    height: 30
                    anchors {left: confirmArrival.left; top: confirmBegin.bottom; leftMargin: 0; topMargin: 8}
                    label: "Set Bookmark"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: eventManager.setBookmark(rootStateModel.targetObject.get());
                }

                SelectorCluster{
                    id: confirmTarget
                    width: 320
                    height: 120
                    labelText: "Target Object"
                    anchors {
                        left: parent.left
                        top: bookmark.bottom
                    }

                    onSelectedSignal: {
                        rootStateModel.targetObject.set( selectionParameter );
                    }
                    SelectorButton{
                        id: none
                        anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                        label: "None"
                        selectionParameter: "None"
                        width: 60
                        height: 30
                        active: (rootStateModel.targetObject.get() === "None")
                    }
                    SelectorButton{
                        id: desk
                        anchors {left: none.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                        label: "Desk"
                        selectionParameter: "FrontDesk"
                        width: 60
                        height: 30
                        active: (rootStateModel.targetObject.get() === "FrontDesk")
                    }
                    SelectorButton{
                        id: table
                        anchors {left: desk.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                        label: "Table"
                        selectionParameter: "Table"
                        width: 70
                        height: 30
                        active: (rootStateModel.targetObject.get() === "Table")
                    }
                    SelectorButton{
                        id: restroom
                        anchors {left: table.right; top: parent.mainLabel.bottom; leftMargin: 8; topMargin:8}
                        label: "Restroom"
                        selectionParameter: "Restroom"
                        width: 100
                        height: 30
                        active: (rootStateModel.targetObject.get() === "Restroom")
                    }
                    SelectorButton{
                        id: kitchen
                        anchors {left: none.left; top: none.bottom; leftMargin: 0; topMargin:8}
                        label: "Kitchen"
                        selectionParameter: "Kitchen"
                        width: 100
                        height: 30
                        active: (rootStateModel.targetObject.get() === "Kitchen")
                    }
                    SelectorButton{
                        id: readingTable
                        anchors {left: kitchen.right; top: none.bottom; leftMargin: 0; topMargin:8}
                        label: "Reading Table"
                        selectionParameter: "ReadingTable"
                        width: 100
                        height: 30
                        active: (rootStateModel.targetObject.get() === "ReadingTable")
                    }
                }
            }
            Button{
                id: buttonEnableToggle
                x:8
                width: 175
                height: 30
                label: active ? "Button Enabled" : "Button Disabled"
                active: rootStateModel.buttonEnabled.get()
                onClicked: rootStateModel.buttonEnabled.set( !rootStateModel.buttonEnabled.get() );
            }
            Rectangle {
                id: buttonStatuses
                width: 320
                height: 96
                color: "#68555555"
                radius: 2
                Button{
                    id: b1Status
                    width: 80
                    height: 80
                    anchors {left: parent.left; top: parent.top; leftMargin: 8; topMargin: 8}
                    label: "B1"
                    radius: 0
                    border.color: "cyan"
                    active: rootStateModel.halfButtonState
                    MouseArea{anchors.fill:parent} //deactivate control
                }
                Button{
                    id: b2Status
                    width: 80
                    height: 80
                    anchors {left: b1Status.right; top: parent.top; leftMargin: 20; topMargin: 8}
                    label: "B2"
                    radius: 0
                    border.color: "cyan"
                    active: rootStateModel.fullButtonState
                    MouseArea{anchors.fill:parent} //deactivate control
                }
            }                        
        }

        focus: true
        Keys.onPressed: {
            if( event.key === Qt.Key_Q )
            {
                event.accepted = true;
                Qt.quit();
            }
            else if( event.key === Qt.Key_Right){
                rootStateModel.heroOrientationOffset.set( rootStateModel.heroOrientationOffset.get()+2 );
            }
            else if( event.key === Qt.Key_Left){
                rootStateModel.heroOrientationOffset.set( rootStateModel.heroOrientationOffset.get()-2 );
            }
            else if( event.key === Qt.Key_W){
                nudgeLeft.clickSim();
            }
            else if( event.key === Qt.Key_E){
                nudgeRight.clickSim();
            }
            else if( event.key === Qt.Key_S){
                turnLeft.clickSim();
            }
            else if( event.key === Qt.Key_D){
                turnRight.clickSim();
            }
        }
    }
}
