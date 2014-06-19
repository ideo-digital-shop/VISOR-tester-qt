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

    onFullButtonStateChanged: {
        if(!connected || !fullButtonState){
            console.debug("i am not the master of buttons.");
            return;
        }
        if( useMode !== "off" ){
            if( useMode === "flashlight"){
                if( fullButtonState ){
                    sendFlashlightEvent();
                }
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

    function sendFlashlightEvent(){
        console.debug("evaluating flashlight");
        var eventDataObj = new Object;
        eventDataObj.soundMode = rootStateModel.soundMode.get();
        eventDataObj.feedbackMode = rootStateModel.feedbackMode.get();
        eventDataObj.object1 = buildFlashlightObject();
        if(eventDataObj.object1.magnitude > 10*12) eventDataObj.object1.magnitude = 30*12;
        else eventDataObj.object1.magnitude = 1;
        eventDataObj.objectsLength = 1;
        if( eventDataObj.feedbackMode != "silent"){
            if(eventDataObj.object1.type != "None"  && (!rootStateModel.flashlightIsScanning.get() || eventDataObj.object1.name != "Wall")){
                console.debug(JSON.stringify(eventDataObj));
                console.debug("sending flashlight");
                noamLemma.speak( "flashlightTrigger" , eventDataObj );
            }
        }
        if( eventDataObj.feedbackMode == "silent" || rootStateModel.vibeMode.get() ){
            if( eventDataObj.object1.magnitude<10*12 && eventDataObj.object1.magnitude>0){
                var motorIntensityInt = (1-eventDataObj.object1.magnitude/(10*12))*3095+1000;
                rootStateModel.motorIntensity.set( parseInt(motorIntensityInt).toString());
                leftMotor();
                rightMotor();
            }
        }
    }

    function buildFlashlightObject(){
        var curElement = new Object;
        curElement.heading = 0;
        if( !evaluation.headingEvaluation.displacementMag ){
            curElement.type = "None"
            curElement.magnitude = 0;
            curElement.name = "";
        }
        else{
            var targetSeg = mapData.getSegment( evaluation.headingEvaluation.networkPosition.segmentIndex );
            curElement.magnitude = evaluation.headingEvaluation.displacementMag;
            curElement.type = targetSeg.segmentType;
            curElement.name = targetSeg.segmentName;
        }
        if(curElement.magnitude > rootStateModel.distanceThresholdIn.get()){
            curElement.type = "None"
            curElement.magnitude = 0;
            curElement.name = "";
        }

        return curElement;
    }

    function sendOverviewEvent(){
        console.debug("eval overview")
        var eventDataObj = new Array;
        eventDataObj = buildOverviewObjectList();
        console.debug("overview list: " + JSON.stringify(eventDataObj));
        if( eventDataObj.feedbackMode != "silent" ){
            overviewSendTimer.sendOverviewMessages( eventDataObj );
        }
        if( eventDataObj.feedbackMode == "silent" || rootStateModel.vibeMode.get() ){
            //            leftMotor();
            //            rightMotor();
        }
    }

    function buildOverviewObjectList(){
        var objectList = new Array;
        for( var i=0; i<evaluation.proximityEvaluation.segmentEvalArray.length; i++ ){
            var currentError = evaluation.proximityEvaluation.segmentEvalArray[i];
            var owningSegment = mapData.getSegment(currentError.segmentIndex);
            if(owningSegment.isTarget){
                var curElement = new Object;
                var errorVectorDeg = 180/Math.PI * currentError.errorVector.heading
                var errorHeadingDeg = errorVectorDeg-90;
                if(errorHeadingDeg>180)errorHeadingDeg-=360;
                if(errorHeadingDeg<-180)errorHeadingDeg+=360;
                var relHeroHeading = errorHeadingDeg - heroModel.heroHeading;
                if(relHeroHeading>180)relHeroHeading-=360;
                if(relHeroHeading<-180)relHeroHeading+=360;
                curElement.heading = relHeroHeading;
                curElement.inputString = owningSegment.segmentName;
                curElement.distance = currentError.errorVector.magnitude;
                objectList.push( curElement );
            }
        }
        return sortAndReap( objectList );
    }

    function sortAndReap( objectList ){
        for(var i=objectList.length-1; i>=0; i--){
            if(Math.abs(objectList[i].heading) > rootStateModel.beamAngle.get()/2 ||
                    objectList[i].distance > rootStateModel.distanceThresholdIn.get() ){
                objectList.splice(i,1);
            }
        }
        function compare(a,b){
            if (a.heading < b.heading){
                return -1;
            }
            if (a.heading > b.heading){
                return 1;
            }
            return 0;
        }
        objectList.sort(compare);
        return appendOclocks(objectList);
    }

    function appendOclocks(objectList){
        var oclockList = ["six" , "seven" , "eight" , "nine" , "ten" , "eleven" ,
                          "twelve" , "one" , "two" , "three" , "four" , "five"];
        for(var i=0; i<objectList.length; i++){
            var offHead = parseInt((objectList[i].heading + 205)/360*12);
            objectList[i].inputString = oclockList[offHead] + "  " + objectList[i].inputString;
        }
        return objectList;
    }

    function nudgeLeft(){
        if( rootStateModel.vibeMode.get() ) leftMotor();
    }
    function nudgeRight(){
        if( rootStateModel.vibeMode.get() ) rightMotor();
    }
    function turnLeft(){
        noamLemma.speak("turnLeft", true);
        if( rootStateModel.vibeMode.get() ) leftMotor();
    }
    function turnRight(){
        noamLemma.speak("turnRight", true);
        if( rootStateModel.vibeMode.get() ) rightMotor();
    }
    function goForward(){
        noamLemma.speak("forward", true);
        if( rootStateModel.vibeMode.get() ) {
            rightMotor();
            leftMotor();
        }
    }

    function leftMotor(){
        var motorData = new Array;
        motorData.push("0");
        motorData.push("" + rootStateModel.motorIntensity.get());
        motorData.push("" + rootStateModel.motorDuration.get());
        noamLemma.speak("PWMSet" , JSON.stringify(motorData));
        console.debug("sending motor turn");
        console.debug(JSON.stringify(motorData));
    }

    function rightMotor(){
        var motorData = new Array;
        motorData.push("1");
        motorData.push("" + rootStateModel.motorIntensity.get());
        motorData.push("" + rootStateModel.motorDuration.get());
        noamLemma.speak("PWMSet" , JSON.stringify(motorData));
        console.debug("sending motor turn");
        console.debug(JSON.stringify(motorData));
    }

    function sendCaneEvent(){
        var L = evaluation.proximityEvaluation.segmentEvalArray.length;
        var minWallDistance = -1;
        var minErrorIndex = -1;
        var minSegIndex = -1;
        for(var i=0; i<L; i++){
            var currentError = evaluation.proximityEvaluation.segmentEvalArray[i];
            var currentIndex = currentError.segmentIndex;
            var currentSegment = mapData.getSegment(currentIndex);
            if( currentSegment.segmentName === "Wall"){
                if( i==0 || currentError.errorVector.magnitude < minWallDistance){
                    minWallDistance = currentError.errorVector.magnitude;
                    minSegIndex = currentIndex;
                    minErrorIndex = i;
                }
            }
        }
        var minError = evaluation.proximityEvaluation.segmentEvalArray[minErrorIndex];
        var minSeg = mapData.getSegment(minSegIndex);
        var pathHeading = minSeg.pathHeading(minError.segmentPosition);
        var incidenceHeading = 0;
        var corPathHeading = 180/Math.PI*pathHeading;
        corPathHeading = corPathHeading >= 180 ? corPathHeading-180 : corPathHeading;
        var errVect = 180/Math.PI*minError.errorVector.heading+90
        var result = corPathHeading+errVect+heroModel.heroOrientation;
        if(result>180)result-=360;
        if(result<-180)result+=360;
        if(errVect >= 180) result = -(heroModel.heroHeading+corPathHeading-90);
        else result = -(heroModel.heroHeading+corPathHeading+90);
        if(result>180)result-=360;
        if(result<-180)result+=360;
        incidenceHeading = result;
        var caneData = new Object;
        caneData.distance = minWallDistance;
        caneData.heading = incidenceHeading;
        rootCaneSignal();
        noamLemma.speak( "caneClick" , caneData );
    }

    Timer{
        id: caneTimer
        interval: 1000*rootStateModel.caneTime.get();
        running: rootStateModel.caneRunning.get();
        repeat: true
        onTriggered:{
            if(!root.connected)return;
            sendCaneEvent();
        }
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
        id: overviewSendTimer
        interval: 1000*rootStateModel.overviewTime.get();
        running: false
        repeat: false
        property var sendList
        property var sendIndex
        function sendOverviewMessages( inputList ){
            if(!root.connected)return;
            if(inputList.length){
                stop();
                var sendObject = inputList[0];
                console.debug("sending overview stage");
                console.debug(JSON.stringify(sendObject));
                noamLemma.speak("speechTrigger" , sendObject);
                sendList = inputList;
                sendList.shift();
                start();
            }
        }
        onTriggered: sendOverviewMessages( sendList );
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
