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
                x:8
                width: 200
                height: 30
                label: active ? "Is Mouse Controller" : "Is Moderator"
                active: rootStateModel.isEventController
                onClicked: rootStateModel.isEventController = !rootStateModel.isEventController;
            }
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
            Button{
                id: dynamicOverview
                width: 160
                height: 30
                label: "Send Overview"
                fillColor: "#0A2036"
                textColor: "#DFDFDF"
                animateClick: true
                onClicked: {
                    eventManager.sendOverviewEvent();
                }
            }
            Item{
                height: childrenRect.height
                width: childrenRect.width
                Button{
                    id: sendOverviewButton1
                    width: 100
                    height: 30
                    label: "Woz 1"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: {
                        noamLemma.speak("wozOverview1", true);
                    }
                }
                Button{
                    id: sendOverviewButton2
                    anchors{ left: sendOverviewButton1.right; leftMargin: 8}
                    width: 100
                    height: 30
                    label: "Woz 2"
                    fillColor: "#0A2036"
                    textColor: "#DFDFDF"
                    animateClick: true
                    onClicked: {
                        noamLemma.speak("wozOverview2", true);
                    }
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
                id: overviewTimeSlider
                sliderWidth: 240
                minValue: .15
                maxValue: 5
                initialValue: rootStateModel.overviewTime.initialValue;
                labelText: "Overview Time"
                onCurrentValueChanged: {
                    rootStateModel.overviewTime.set( targetSynch );
                }
            }
            ValueSlider{
                id: beamAngleSlider
                sliderWidth: 240
                minValue: 0
                maxValue: 360
                initialValue: rootStateModel.beamAngle.initialValue;
                labelText: "Beam Angle"
                onCurrentValueChanged: {
                    rootStateModel.beamAngle.set( targetSynch );
                }
            }
            ValueSlider{
                id: distanceThresholdSlider
                sliderWidth: 240
                minValue: 0
                maxValue: 50
                initialValue: parseInt( rootStateModel.distanceThresholdIn.initialValue / 12 );
                labelText: "Distance Threshold - ft"
                onCurrentValueChanged: {
                    rootStateModel.distanceThresholdIn.set( targetSynch * 12 );
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
            //            SelectorCluster{
            //                id: useModeSelector
            //                width: 320
            //                height: 94
            //                labelText: "Use Mode"
            //                onSelectedSignal: {
            //                    rootStateModel.useMode.set( selectionParameter );
            //                }
            //                SelectorButton{
            //                    id: flashlight
            //                    anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
            //                    label: "Flashlight"
            //                    selectionParameter: "flashlight"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.useMode.get() === "flashlight")
            //                }
            //                SelectorButton{
            //                    id: overview
            //                    anchors {left: flashlight.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
            //                    label: "Overview"
            //                    selectionParameter: "overview"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.useMode.get() === "overview")
            //                }
            //            }

            //            SelectorCluster{
            //                id: soundModeSelector
            //                width: 320
            //                height: 134
            //                labelText: " Sound Mode"
            //                onSelectedSignal: {
            //                    rootStateModel.soundMode.set( selectionParameter );
            //                }
            //                SelectorButton{
            //                    id: binaural
            //                    anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
            //                    label: "Binaural"
            //                    selectionParameter: "binaural"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.soundMode.get() == "binaural")
            //                }
            //                SelectorButton{
            //                    id: stereo
            //                    anchors {left: binaural.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
            //                    label: "Stereo"
            //                    selectionParameter: "stereo"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.soundMode.get() == "stereo")
            //                }
            //                SelectorButton{
            //                    id: mono
            //                    anchors {left: stereo.left; top: stereo.bottom; topMargin:8}
            //                    label: "Mono"
            //                    selectionParameter: "mono"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.soundMode.get() == "mono")
            //                }
            //            }
        }

        Column{
            id: columnB
            width: 340
            spacing: 20
            height: container.height
            anchors {left: columnA.right; leftMargin: 20}
            //            SelectorCluster{
            //                id: feedbackModeSelector
            //                width: 320
            //                height: 134
            //                labelText: " Feedback Mode"
            //                onSelectedSignal: {
            //                    // rootStateModel.feedbackMode.set( selectionParameter );
            //                }
            //                SelectorButton{
            //                    id: standing
            //                    anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
            //                    label: "Standing"
            //                    selectionParameter: "standing"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.feedbackMode.get() === "standing")
            //                }
            //                SelectorButton{
            //                    id: moving
            //                    enabled: false
            //                    anchors {left: standing.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
            //                    label: "Moving"
            //                    selectionParameter: "moving"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.feedbackMode.get() === "moving")
            //                }
            //                SelectorButton{
            //                    id: silent
            //                    anchors {left: moving.left; top: moving.bottom; topMargin:8}
            //                    label: "Silent"
            //                    enabled: false
            //                    selectionParameter: "silent"
            //                    width: 120
            //                    height: 30
            //                    active: (rootStateModel.feedbackMode.get() === "silent")
            //                }
            //            }
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
                    onClicked: eventManager.goForward();
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
                    onClicked: noamLemma.speak("confirmArrival" , rootStateModel.targetObject.get());
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
                    onClicked: noamLemma.speak("confirmRouteBegin" , rootStateModel.targetObject.get());
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
                    onClicked: noamLemma.speak("setBookmark" , rootStateModel.targetObject.get());
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
            Item{
                width: childrenRect.width
                height: childrenRect.height
                Button{
                    id: caneButton
                    x:8
                    width: 200
                    height: 30
                    label: active ? "Cane Running" : "Cane Stopped"
                    active: rootStateModel.caneRunning.get();
                    onClicked: rootStateModel.caneRunning.set(!rootStateModel.caneRunning.get());
                }
                Rectangle{
                    id: ind
                    width:30
                    height:30
                    anchors{ left: caneButton.right; leftMargin: 8}
                    color:"#00FFFFFF"
                    border{color:"cyan";width:1}
                    SequentialAnimation{
                        id: caneAnim
                        ColorAnimation{target: ind; property: "color"; to:"#FFFFFF"; duration: 50}
                        ColorAnimation{target: ind; property: "color"; to:"#00FFFFFF"; duration: 50}
                    }
                    Component.onCompleted:{
                        rootCaneSignal.connect(caneAnim.start);
                    }
                }
            }
            ValueSlider{
                id: canePeriodSlider
                sliderWidth: 240
                minValue: .1
                maxValue: 5
                initialValue: rootStateModel.caneTime.initialValue;
                labelText: "Cane Period"
                onCurrentValueChanged: {
                    rootStateModel.caneTime.set(targetSynch);
                }
            }
        }

        /*

        Column{
            id: columnC
            width: childrenRect.width
            //anchors {left: columnB.rigth; leftMargin:20}
            x: 700
            spacing: 20
            Section{
                id:eventControls
                sectionColor: "#FFFFFF"
                mainLabelText: "EVENT CONTROLS"
                //anchors{left: userControls.right; leftMargin: 20; top: desktopControls.bottom; topMargin:20}
                Button{id:volumeDownButton
                    width:70; height:40
                    anchors{left: eventControls.mainLabel.left; top: eventControls.mainLabel.bottom; topMargin:20; leftMargin: 4}
                    label: "VOL -"
                    onClicked: {
                        eventSender.send("volumeDown", true);
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:volumeUpButton
                    width:70; height:40
                    anchors{left: volumeDownButton.right; top: eventControls.mainLabel.bottom; topMargin:20; leftMargin: 20}
                    label: "VOL +"
                    onClicked: {
                        eventSender.send("volumeUp", true);
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:wiperModeButton
                    width:125; height:40
                    anchors{left: eventControls.mainLabel.left; top: volumeDownButton.bottom; topMargin:20; leftMargin: 4}
                    label: "WIPERS"
                    onClicked: {
                        switch (wiperNumber){
                        case 0:
                            eventSender.send("wiperKnob", "1")
                            break
                        case 1:
                            eventSender.send("wiperKnob", "2")
                            break
                        case 2:
                            eventSender.send("wiperKnob", "0")
                            break
                        }
                        if(wiperNumber == 2) wiperNumber = 0
                        else wiperNumber++
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:lightModeButton
                    width:125; height:40
                    anchors{left: wiperModeButton.right; top: volumeDownButton.bottom; topMargin:20; leftMargin: 20}
                    label: "LIGHTS"
                    onClicked: {
                        switch (lightNumber){
                        case 0:
                            eventSender.send("lightKnob", "1")
                            break
                        case 1:
                            eventSender.send("lightKnob", "2")
                            break
                        case 2:
                            eventSender.send("lightKnob", "3")
                            break
                        case 3:
                            eventSender.send("lightKnob", "0")
                            break
                        }
                        if(lightNumber == 3) lightNumber = 0
                        else lightNumber++
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:cruiseButton
                    width:125; height:40
                    anchors{left:eventControls.mainLabel.left; top:lightModeButton.bottom; topMargin:20; leftMargin: 4}
                    label: "CRUISE"
                    onClicked: {
                        eventSender.send("cruise", "1");
                    }
                    active: rootVehicleStatusModel.cruiseActive.get()

                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:cruiseMinusButton
                    width:35; height:40
                    anchors{left:cruiseButton.right; top:cruiseButton.top; topMargin:0; leftMargin: 20}
                    label: "-"
                    onClicked: {
                        eventSender.send("cruiseMinus", "1");
                    }
                    active: rootVehicleStatusModel.cruiseActive.get()

                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:cruisePlusButton
                    width:35; height:40
                    anchors{left:cruiseMinusButton.right; top:cruiseButton.top; topMargin:0; leftMargin: 20}
                    label: "+"
                    onClicked: {
                        eventSender.send("cruisePlus", "1");
                    }
                    active: rootVehicleStatusModel.cruiseActive.get()

                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:cruiseGapButton
                    width:125; height:40
                    anchors{left:eventControls.mainLabel.left; top:cruisePlusButton.bottom; topMargin:20; leftMargin: 4}
                    label: "CYCLE GAP"
                    onClicked: {
                        eventSender.send("gap", "1");
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:gapAlertButton
                    width:125; height:40
                    anchors{left:cruiseGapButton.right; top:cruiseGapButton.top; topMargin:0; leftMargin: 20}
                    label: "CAR AHEAD"
                    onClicked: {
                        eventSender.send("cruiseRadarActive", "1");
                    }
                    // active: rootVehicleStatusModel.cruiseRadarActive.get()

                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }

                Text{
                    id:alertsLabel
                    anchors{left:eventControls.mainLabel.left; top:cruiseGapButton.bottom; topMargin:20; leftMargin: 4}
                    text:"ALERTS"
                    font.pixelSize: 24
                    font.family: hmicondensed.name
                    color:"#FFFFFF"
                }
                Button{id:lowFuelButton
                    width:70; height:40
                    anchors{left:eventControls.mainLabel.left; top:alertsLabel.bottom; topMargin:20; leftMargin: 4}
                    label: "FUEL"
                    onClicked: {
                        if(rootTelemetryModel.fuel > .1) eventSender.send("fuelLevel", .07);
                        else eventSender.send("fuelLevel", .7);
                    }
                    fillColor: rootTelemetryModel.fuel < .1 ? "#B05050" : "#101010"
                    textColor: rootTelemetryModel.fuel < .1 ? "#101010" : "#AFAFAF"
                }
                Button{id:textButton
                    width:70; height:40
                    anchors{left: lowFuelButton.right; top: lowFuelButton.top; leftMargin: 20}
                    label: "TEXT"
                    onClicked: {
                        eventSender.send("incomingText", 1);
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:callButton
                    width:70; height:40
                    anchors{left: textButton.right; top: lowFuelButton.top; leftMargin: 20}
                    label: "CALL"
                    onClicked: {
                        eventSender.send("incomingCall", 1);
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }

                Text{
                    id:categoriesLabel
                    anchors{left:eventControls.mainLabel.left; top:callButton.bottom; topMargin:20; leftMargin: 4}
                    text:"CATEGORIES"
                    font.pixelSize: 24
                    font.family: hmicondensed.name
                    color:"#FFFFFF"
                }
                Button{id:killMusic
                    width:70; height:40
                    anchors{left: eventControls.mainLabel.left; top: categoriesLabel.bottom; topMargin:20; leftMargin: 4}
                    label: "MUS"
                    active: rootVehicleStatusModel.audioSource != rootVehicleStatusModel.audioSources.off
                    onClicked: rootVehicleStatusModel.setSource("off");
                }
                Button{id:setRoute
                    width:70; height:40
                    anchors{left: killMusic.right; top: killMusic.top; leftMargin: 20}
                    label: rootNavModel.routeIsSet.get() ? "CLEAR ROUTE" : "SET ROUTE"
                    active: rootNavModel.routeIsSet.get()
                    onClicked: eventSender.send("routeIsSet", !active );
                }
                Button{id:phonePaired
                    width:70; height:40
                    anchors{left: setRoute.right; top: killMusic.top; leftMargin: 20}
                    label: "COM"
                    active: rootVehicleStatusModel.phoneModel.phonePaired.get()
                    onClicked: eventSender.send("phonePaired", !active );
                }

                Text{
                    id:miscLabel
                    anchors{left:eventControls.mainLabel.left; top:killMusic.bottom; topMargin:20; leftMargin: 4}
                    text:"MISC"
                    font.pixelSize: 24
                    font.family: hmicondensed.name
                    color:"#FFFFFF"
                }
                Button{id:shortcutsButton
                    width:160; height:40
                    anchors{left: eventControls.mainLabel.left; top: miscLabel.bottom; topMargin:20; leftMargin: 4}
                    label: "ADD PRESETS"
                    onClicked: {
                        eventSender.send("exampleShortcuts", true);
                    }
                    fillColor: "#101010"
                    textColor: "#AFAFAF"
                }
                Button{id:demoMode
                    width:100; height:40
                    anchors{left: shortcutsButton.left; top: shortcutsButton.bottom; topMargin:20; leftMargin: 4}
                    label: "DRV DEMO"
                    active: rootTelemetryModel.demoMode
                    onClicked: eventSender.send("demoMode", !active );
                }
                Button{id:navDemoModeBtn
                    width:100; height:40
                    anchors{left: demoMode.right; top: demoMode.top; leftMargin: 4}
                    label: "NAV DEMO"
                    active: rootVehicleStatusModel.navDemoMode.get()
                    onClicked: eventSender.send("navDemoMode", "1" )
                }
                Button{id:navDemoPauseBtn
                    width:100; height:40
                    anchors{left: navDemoModeBtn.right; top: navDemoModeBtn.top; leftMargin: 4}
                    label: "PAUSE"
                    active: false
                    onClicked: eventSender.send("navDemoPause", "1" )
                }
            }
            Section{
                id: desktopControls
                sectionColor: "#FFFFFF"
                mainLabelText: "DESKTOP CONTROLS"
                //anchors{left: vehicleControls.right; leftMargin: 20; top: vehicleControls.top}
                Button{id: clusterHideButton
                    width: 120; height: 60
                    label: clusterShown ? "HIDE CLUSTER" : "SHOW CLUSTER"
                    anchors{left: desktopControls.mainLabel.left; top: desktopControls.mainLabel.bottom; topMargin:20; leftMargin: 4}
                    fillColor: clusterShown ? "#0A3620" : "#101010"
                    textColor: "#AFAFAF"
                    labelObj.horizontalAlignment: Text.AlignHCenter
                    labelObj.verticalAlignment: Text.AlignVCenter
                    onClicked:{
                        if(clusterShown){showCluster(false);}
                        else {showCluster(true);}
                    }
                }
                Button{id: hudHideButton
                    width: 120; height: 60
                    label: hudShown ? "HIDE HUD" : "SHOW HUD"
                    anchors{left: clusterHideButton.left; top: clusterHideButton.bottom; topMargin:10}
                    fillColor: hudShown ? "#0A3620" : "#101010"
                    textColor: "#AFAFAF"
                    labelObj.horizontalAlignment: Text.AlignHCenter
                    labelObj.verticalAlignment: Text.AlignVCenter
                    onClicked:{
                        if(hudShown){showHud(false);}
                        else {showHud(true);}
                    }
                }
            }
        }
        */
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
