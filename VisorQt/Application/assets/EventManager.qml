import QtQuick 2.0

Item {
    id: root
    property var mapData
    property var evaluation
    property var heroModel

    property bool halfButtonState: rootStateModel.halfButtonState
    property bool fullButtonState: rootStateModel.fullButtonState
    property int currentFacingIndex: evaluation.headingEvaluation.networkPosition ? evaluation.headingEvaluation.networkPosition.segmentIndex : -1
    property bool connected: false
    property string useMode: rootStateModel.buttonFunctionMode.get();
    onUseModeChanged: {
        rootStateModel.flashlightIsScanning.set( false );
    }

    onCurrentFacingIndexChanged: {
        if(!connected)return;
        if( rootStateModel.flashlightScanMode.get() === "new" && rootStateModel.flashlightIsScanning.get() ){
            sendFlashlightEvent();
        }
    }

    onHalfButtonStateChanged: {
        if(!connected)return;
        if( rootStateModel.buttonFunctionMode.get() !== "off" ){
            if(halfButtonState){
                waitForFullPressTimer.start();
            }
            else{
                waitForFullPressTimer.stop();
            }
        }
    }

    onFullButtonStateChanged: {
        if(!connected)return;
        if( useMode !== "off" ){
            waitForFullPressTimer.stop();
            if( useMode === "flashlight"){
                if( rootStateModel.flashlightIsScanning.get() ){
                    rootStateModel.flashlightIsScanning.set( false );
                }
                else rootStateModel.flashlightIsScanning.set( true );
            }
            else if(useMode === "overview"){
                rootStateModel.flashlightIsScanning.set( false );
                //if sending overview, send cancel signal
                //if not sending overview, send overview
            }
        }
    }

    function connect(){
        connected = true;
    }

    function disconnect(){
        connected = false;
    }

    function sendOrientationEvent(){
        if( rootStateModel.useMode.get() === "flashlight" ){
            sendFlashlightEvent();
        }
        else if( rootStateModel.useMode.get() === "overview" ){
            sendOverviewEvent();
        }
        else console.warn("invalid use mode");
    }

    function sendFlashlightEvent(){
        console.debug("sending flashlight")
        var eventDataObj = new Object;
        eventDataObj.soundMode = rootStateModel.soundMode.get();
        eventDataObj.feedbackMode = rootStateModel.feedbackMode.get();
        eventDataObj.object1 = buildFlashlightObject();
        eventDataObj.objectsLength = 1;
        console.debug(JSON.stringify(eventDataObj));
        noamLemma.speak( "flashlightTrigger" , eventDataObj );
    }
    function sendOverviewEvent(){

    }
    function buildFlashlightObject(){
        var curElement = new Object;
        curElement.heading = 0;
        if( !evaluation.headingEvaluation.displacementMag ){
            curElement.type = "none"
            curElement.magnitude = 0;
            curElement.name = "";
        }
        else{
            var targetSeg = mapData.getSegment( evaluation.headingEvaluation.networkPosition.segmentIndex );
            curElement.magnitude = evaluation.headingEvaluation.displacementMag;
            curElement.type = targetSeg.segmentType;
            curElement.name = targetSeg.segmentName;
        }
        return curElement;
    }

    function buildOverviewObjectList(){
        var objectList = new Array;
        var curElement = new Object;
    }

    Timer{
        id: repeatTimer
        interval: 1000*rootStateModel.repeatTime.get();
        running: true
        repeat: true
        onTriggered:{
            if(!root.connected)return;
            if( rootStateModel.flashlightScanMode.get() === "timer" && rootStateModel.flashlightIsScanning.get() ){
                sendFlashlightEvent();
            }

        }

    }

    Timer{
        id: waitForFullPressTimer
        interval: 75
        running: false
        repeat: false
        onTriggered: {
            if(!connected)return;
            sendFlashlightEvent();
        }
    }
}
