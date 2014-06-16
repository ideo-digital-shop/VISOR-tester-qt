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
            width: 400//childrenRect.width
            spacing: 20
            Section{
                id: flashlightSettings
                sectionColor: "#0000FF"
                mainLabelText: "FLASHLIGHT CONTROLS"
                //anchors{top:parent.top; topMargin: 20; left: parent.left; leftMargin: 20}
                Column{
                    width:380
                    x:20;
                    spacing: 20
                    anchors.top: parent.mainLabel.bottom
                    anchors.topMargin: 20
                    ValueSlider{
                        id: repeatTimeSlider
                        sliderWidth: 240
                        minValue: .5
                        maxValue: 20
                        initialValue: rootStateModel.repeatTime.initialValue;
                        labelText: "Repeat Time"
                        onCurrentValueChanged: {
                            rootStateModel.repeatTime.set( targetSynch );
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
                    SelectorCluster{
                        id: useModeSelector
                        width: 360
                        height: 94
                        labelText: "Use Mode"
                        onSelectedSignal: {
                            rootStateModel.useMode.set( selectionParameter );
                        }
                        SelectorButton{
                            id: flashlight
                            anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                            label: "Flashlight"
                            selectionParameter: "flashlight"
                            width: 120
                            height: 30
                            active: (rootStateModel.useMode.get() === "flashlight")
                        }
                        SelectorButton{
                            id: overview
                            anchors {left: flashlight.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                            label: "Overview"
                            selectionParameter: "overview"
                            width: 120
                            height: 30
                            active: (rootStateModel.useMode.get() === "overview")
                        }
                    }
                    SelectorCluster{
                        id: feedbackModeSelector
                        width: 360
                        height: 134
                        labelText: " Feedback Mode"
                        onSelectedSignal: {
                            rootStateModel.feedbackMode.set( selectionParameter );
                        }
                        SelectorButton{
                            id: standing
                            anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                            label: "Standing"
                            selectionParameter: "standing"
                            width: 120
                            height: 30
                            active: (rootStateModel.feedbackMode.get() === "standing")
                        }
                        SelectorButton{
                            id: moving
                            anchors {left: standing.right; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                            label: "Moving"
                            selectionParameter: "moving"
                            width: 120
                            height: 30
                            active: (rootStateModel.feedbackMode.get() === "moving")
                        }
                        SelectorButton{
                            id: silent
                            anchors {left: moving.left; top: moving.bottom; topMargin:8}
                            label: "Silent"
                            selectionParameter: "silent"
                            width: 120
                            height: 30
                            active: (rootStateModel.feedbackMode.get() === "silent")
                        }
                    }
                    SelectorCluster{
                        id: imuSelector
                        width: 360
                        height: 134
                        labelText: "Heading Source"
                        onSelectedSignal: {
                            console.debug( selectionParameter );
                            //TODO: send signal to signla handler
                        }

                        SelectorButton{
                            id: imuHead
                            anchors {left: parent.left; top: parent.mainLabel.bottom; leftMargin:8; topMargin:8}
                            label: "Head"
                            selectionParameter: "head"
                            width: 120
                            height: 30
                        }
                        SelectorButton{
                            id: imuBody
                            anchors {left:imuHead.right; leftMargin:8; top:imuHead.top}
                            label: "Body"
                            selectionParameter: "body"
                            width: 120
                            height: 30
                            active: true
                        }
                        SelectorButton{
                            id: imuManual
                            anchors {left:imuHead.left; topMargin:8; top:imuHead.bottom}
                            label: "Manual"
                            selectionParameter: "manual"
                            width: 120
                            height: 30
                        }
                        SelectorButton{
                            id: imuGesture
                            anchors {left:imuManual.right; leftMargin:8; top:imuManual.top}
                            label: "Gesture"
                            selectionParameter: "gesture"
                            width: 120
                            height: 30
                        }
                    }
                    Label{id: resultsLabel
                        color: "#803A5070"
                        label: "RESULTS"
                    }
                    Label{id: triggersLabel
                        color: "#803A5070"
                        label: "TRIGGERS"
                    }
                    ListView{
                        id: orthographyView
                        function selected(index){ selectedSignal(index);}
                        signal selectedSignal(int index)
                        height: 400
                        width: 140
                        spacing: 3
                        //                    model: rootVehicleStatusModel.voiceModel.currentOrthography
                        delegate: Rectangle{
                            id: orthDelegateItem
                            Component.onCompleted: {
                                orthographyView.selectedSignal.connect(selectTest);
                                selectMe.connect(orthographyView.selected);
                            }
                            width:orthographyView.width
                            height: 24
                            color: "#A0201060"
                            Behavior on color{ColorAnimation{duration:200}}
                            function selectTest(ind){
                                if(ind!=index){
                                    if (typeof orthDelegateItem != typeof undefined){
                                        orthDelegateItem.color = "#A0201060";
                                        orthDelText.color = "#F9F9F9";
                                    }
                                }
                            }
                            signal selectMe (int ind)
                            Text{id: orthDelText
                                font.pixelSize: 16
                                width: parent.width-4
                                clip:true
                                anchors{verticalCenter:parent.verticalCenter; left: parent.left; leftMargin: 2}
                                color: "#F9F9F9"
                                Behavior on color{ColorAnimation{duration:200}}
                                text:orthographyView.model[index]
                            }
                            MouseArea{
                                anchors{fill:parent}
                                onPressed: {
                                    orthDelegateItem.color = "#A0A0A0";
                                    orthDelText.color = "#302020";
                                    orthDelegateItem.selectMe(index);
                                }
                                onDoubleClicked: {
                                    var orthArray = root.selectedOrthographies
                                    orthArray.push(orthographyView.model[index]);
                                    root.selectedOrthographies = orthArray;
                                }
                            }
                        }
                    }
                    Row{id: voiceButtons
                        spacing: 10
                        Button{id: sendButton
                            width: 75
                            height: 40
                            label: "SEND"
                            fillColor: "#0A2036"
                            textColor: "#DFDFDF"
                            animateClick: true
                            onClicked: {
                                var selectedOrth = root.selectedOrthographies;
                                var orthArray = new Array(0);
                                for(var i=0; i< selectedOrth.length; i++){
                                    orthArray[i]=new Array(0);
                                    orthArray[i].push(i);
                                    orthArray[i].push(7500);
                                    orthArray[i].push(selectedOrth[i]);
                                }
                                eventSender.send("voiceResults", orthArray);
                            }
                        }
                        Button{id: clearButton
                            width: 75
                            height: 40
                            label: "CLEAR"
                            fillColor: "#0A2036"
                            textColor: "#DFDFDF"
                            animateClick: true
                            onClicked: {
                                var selOrth = [];
                                root.selectedOrthographies = selOrth;
                            }
                        }
                    }
                    Row{id: triggerButtons
                        spacing: 10
                        Button{id: thinking
                            width: 120
                            height: 40
                            label: "THINKING"
                            fillColor: "#0A2036"
                            textColor: "#DFDFDF"
                            animateClick: true
                            onClicked: {
                                eventSender.send("toggleVoiceThinking", 1);
                            }
                        }
                    }
                    ListView{id: selOrthView
                        height: 100
                        width: 140
                        spacing: 3
                        model: root.selectedOrthographies
                        delegate: Rectangle{id: selOrthDelegate
                            width:selOrthView.width
                            height: 24
                            color: "#4080A0FF"

                            Text{
                                font.pixelSize: 16
                                width: parent.width-4
                                clip:true
                                anchors{verticalCenter:parent.verticalCenter; left: parent.left; leftMargin: 2}
                                color: "#F9F9F9"
                                text:selOrthView.model[index]
                            }
                        }
                    }

                }

            }
            Section{
                id:userControls
                sectionColor: "#36200A"
                mainLabelText: "USER CONTROLS"
                //anchors{left: vehicleControls.left; topMargin: 20; top: vehicleControls.bottom}
                Item{id: catButtonCluster
                    anchors{left: userControls.mainLabel.left; top: userControls.mainLabel.bottom; topMargin:20; leftMargin: 4}
                    width: childrenRect.width
                    height: childrenRect.height
                    property real childSpacing: 3.5
                    Button{id:clusterButton
                        width:70; height:40
                        radius: 10
                        label: "INFO"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.clusterButtonSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("clusterButton", true);
                    }
                    Button{id:musicButton
                        width:70; height:40
                        radius: 10
                        anchors{top: clusterButton.bottom; topMargin: 20}
                        label: "MUSIC"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.musicSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("musicButton", true);
                    }
                    Button{id:navButton
                        width:70; height:40
                        radius: 10
                        anchors{top: musicButton.bottom; topMargin: catButtonCluster.childSpacing}
                        label: "NAV"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.navSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("navButton", true);
                    }
                    Button{id:comButton
                        width:70; height:40
                        radius: 10
                        anchors{top: navButton.bottom; topMargin: catButtonCluster.childSpacing}
                        label: "COM"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.comSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("phoneButton", true);
                    }
                    Button{id:moreButton
                        width:70; height:40
                        radius: 10
                        anchors{top: comButton.bottom; topMargin: catButtonCluster.childSpacing}
                        label: "MORE"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.moreSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("moreButton", true);
                    }
                }
                Item{id: dirButtonCluster
                    width: childrenRect.width
                    height: childrenRect.height
                    property real childSpacing: 3.5
                    anchors{top: catButtonCluster.top; leftMargin: 40; left: catButtonCluster.right}
                    Button{
                        id:leftButton
                        width:70; height:40
                        radius: 10
                        anchors{top: selectButton.top;left:parent.left}
                        label: "LEFT"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.leftSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("leftButton", true);
                    }
                    Button{id:selectButton
                        width:70; height:40
                        anchors{left: leftButton.right; leftMargin: 10; top: upButton.bottom; topMargin: 10}
                        radius: 10
                        label: "SELECT"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.selectSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("selectButton", true);
                    }
                    Button{id:upButton
                        width:70; height:40
                        radius: 10
                        anchors{left: selectButton.left; top: parent.top}
                        label: "UP"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.upSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("upButton", true);
                    }
                    Button{
                        id:rightButton
                        width:70; height:40
                        radius: 10
                        anchors{top: selectButton.top; left: selectButton.right; leftMargin: 10}
                        label: "RIGHT"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.rightSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("rightButton", true);
                    }
                    Button{id:downButton
                        width:70; height:40
                        radius: 10
                        anchors{left: selectButton.left; top: selectButton.bottom; topMargin: 10}
                        label: "DOWN"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.downSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("downButton", true);
                    }
                    Button{id:voiceButton
                        width:70; height:40
                        radius: 10
                        anchors{top: downButton.bottom; topMargin: 20; left: downButton.left}
                        label: "VOICE"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            //                            rootUserModel.voiceButtonSignal.connect(clickDetector);
                        }
                        onClicked: eventSender.send("voice", true);
                    }
                    Button{id:nextButton
                        width:80; height:40
                        radius: 10
                        anchors{top: downButton.bottom; topMargin: 20; left: voiceButton.right; leftMargin: 20;}
                        label: "SKIP >>"
                        labelSize: 20
                        fillColor: "#36200A"
                        textColor: "#DFDFDF"
                        labelObj.horizontalAlignment: Text.AlignHCenter
                        labelObj.verticalAlignment: Text.AlignVCenter
                        onClicked: eventSender.send("seekNextValue", 10)
                    }
                }
            }
        }
        /*
        Column{
            id: columnB
            width: childrenRect.width
            //anchors {left: columnA.rigth; leftMargin:200}
            x: 400
            spacing: 20
            Section{
                id: clusterControls
                //anchors{top:voiceEngineDisplay.bottom; topMargin: 20; left: parent.left; leftMargin: 20}
                mainLabelText: "CLUSTER CONTROLS"
                Label{
                    id: mapControlsLabel
                    anchors {top:clusterControls.mainLabel.bottom; topMargin:10; left: clusterControls.mainLabel.left}
                    color: "#803A5070"
                    label: "MAP VIEW"
                }
                Slider{
                    id: clusterMapZoomSlider
                    targetSynch: rootInterfaceModel.clusterMapZoom
                    anchors {top:mapControlsLabel.bottom; left: mapControlsLabel.left; topMargin: 10}
                    sliderWidth: 200
                    minValue: .5
                    maxValue: 60
                    labelText: "ZOOM"
                    decimalPlaces: 1
                }
                Slider{
                    id: clusterTiltSlider
                    targetSynch: rootInterfaceModel.clusterMapTilt
                    anchors {top:clusterMapZoomSlider.bottom; left: clusterMapZoomSlider.left; topMargin: 10}
                    sliderWidth: 200
                    minValue: 0
                    maxValue: 90
                    labelText: "TILT"
                }
                Button{
                    id:poiButton
                    width:130; height:40
                    anchors{top: clusterTiltSlider.bottom; left: clusterTiltSlider.left; topMargin: 20}
                    label: "CLUSTER POI"
                    onClicked: eventSender.send("showClusterPois", !rootInterfaceModel.showClusterPois.get());
                    active: rootInterfaceModel.showClusterPois.get()
                }
                Label{
                    id: ecoControlsLabel
                    anchors {top:poiButton.bottom; topMargin:20; left: poiButton.left}
                    color: "#803A5070"
                    label: "ECO VIEW"
                }
                Button{
                    id:ecoSupportButton
                    width:130; height:40
                    labelSize:22
                    anchors{top: ecoControlsLabel.bottom; left: ecoControlsLabel.left; topMargin: 20}
                    label: rootInterfaceModel.ecoQuantGauge.get() ? "SHOW QUAL" : "SHOW QUANT"
                    onClicked: rootInterfaceModel.ecoQuantGauge.toggle()
                }
                Button{
                    id:ecoPointFeedbackButton
                    width:55; height:40
                    labelSize:22
                    anchors{top: ecoControlsLabel.bottom; left: ecoSupportButton.right; leftMargin: 10; topMargin: 20}
                    label: "PTS"
                    onClicked: eventSender.send("showPointAchievement", 1);
                }
                Button{
                    id:ecoLevelFeedbackButton
                    width:55; height:40
                    labelSize:22
                    anchors{top: ecoControlsLabel.bottom; left: ecoPointFeedbackButton.right; leftMargin: 10; topMargin: 20}
                    label: "LVL"
                    onClicked: eventSender.send("showLevelAchievement", 1);
                }
                Button{
                    id:gasModeButton
                    width:80; height:40
                    labelSize:22
                    anchors{top: ecoSupportButton.bottom; left: ecoSupportButton.left; topMargin: 20}
                    label: "GAS"
                    active: !rootVehicleStatusModel.evMode.get()
                    onClicked: {
                        rootVehicleStatusModel.phevMode.set(false)
                        rootVehicleStatusModel.bevMode.set(false)
                    }
                }
                Button{
                    id:phevModeButton
                    width:80; height:40
                    labelSize:22
                    anchors{top: ecoSupportButton.bottom; left: gasModeButton.right; leftMargin: 10; topMargin: 20}
                    label: "PHEV"
                    active: rootVehicleStatusModel.phevMode.get()
                    onClicked: {
                        rootVehicleStatusModel.phevMode.toggle()
                        rootVehicleStatusModel.bevMode.set(!rootVehicleStatusModel.phevMode.get())
                    }
                }
                Button{
                    id:bevModeButton
                    width:80; height:40
                    labelSize:22
                    anchors{top: ecoSupportButton.bottom; left: phevModeButton.right; leftMargin: 10; topMargin: 20}
                    label: "BEV"
                    active: rootVehicleStatusModel.bevMode.get()
                    onClicked: {
                        rootVehicleStatusModel.bevMode.toggle()
                        rootVehicleStatusModel.phevMode.set(!rootVehicleStatusModel.bevMode.get())
                    }
                }
            }
            Section{
                id:vehicleControls
                sectionColor: "#FFFFFF"
                mainLabelText: "VEHICLE CONTROLS"
                //anchors{left: voiceEngineDisplay.right; leftMargin: 20; top: voiceEngineDisplay.top}
                Row{
                    id:gearRow
                    spacing:10
                    anchors{top:vehicleControls.mainLabel.bottom; topMargin:10; left:vehicleControls.mainLabel.left; leftMargin: 5}
                    Button{
                        id:parkButton
                        width:60; height:40
                        label: "PRK"
                        onClicked: eventSender.send("gearChange", 0)
                        active: rootTelemetryModel.gear == "P"
                    }
                    Button{
                        id:driveButton
                        width:60; height:40
                        label: "DRV"
                        onClicked: eventSender.send("gearChange", 3)
                        active: rootTelemetryModel.gear == "D"
                    }
                    Button{
                        id:reverseButton
                        width:60; height:40
                        label: "REV"
                        onClicked: eventSender.send("gearChange", 1)
                        active: rootTelemetryModel.gear == "R"
                    }
                }
                Button{
                    id:passButton
                    width:130; height:40
                    anchors{top: gearRow.bottom; left: gearRow.left; topMargin: 20}
                    label: "PASS MODE"
                    onClicked: eventSender.send("passengerDetected", !rootVehicleStatusModel.passengerDetected);
                    active: rootVehicleStatusModel.passengerDetected
                }
                Button{id:ignitionButton
                    width:60; height:40
                    anchors{top: passButton.top; left: passButton.right; leftMargin: 10}
                    label: "PWR"
                    onClicked: eventSender.send("startStopBtn", "1");
                    active: rootVehicleStatusModel.ignitionState.get()
                }
                Button{id:hudModeButton
                    width:130; height:40
                    anchors{top: passButton.bottom; left: passButton.left; topMargin: 20}
                    label: "HUD MODE"
                    onClicked: {
                        eventSender.send("hud", !rootVehicleStatusModel.hudMode.get());
                    }
                    active: rootVehicleStatusModel.hudMode.get()
                }
                Button{id:favsButton
                    width:130; height:40
                    anchors{top: hudModeButton.bottom; left: hudModeButton.left; topMargin: 20}
                    label: "SOURCE SPECIFIC"
                    onClicked: {
                        eventSender.send("sourceSpecificShortcuts", !rootInterfaceModel.sourceSpecificShortcuts.get());
                    }
                    active: rootInterfaceModel.sourceSpecificShortcuts.get()
                }
                Button{id:climateOptionsButton
                    width:180; height:40
                    anchors{top: favsButton.bottom; left: passButton.left; topMargin: 20}
                    label: "CLIMATE OPTIONS"
                    onClicked: {
                        eventSender.send("moreOptionsBtn", 1);
                    }
                }
            }
        }
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
        }
    }
}
