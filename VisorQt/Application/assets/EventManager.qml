import QtQuick 2.0

Item {
    property var mapData
    property var evaluation

    function sendOrientationEvent(){
        if( rootStateModel.useMode.get() === "flashlight" ){
            sendFlashlightEvent();
        }
        else if( rootStateModel.useMode.get() === "overview" ){
            sendOverviewEvent();
        }
        else console.warn("invalid use mode");

        var eventDataObj = new Object;
        eventDataObj.useMode = rootStateModel.useMode.get();
        eventDataObj.soundMode = rootStateModel.soundMode.get();
        eventDataObj.speech = rootStateModel.speech.get();
        eventDataObj.tone = rootStateModel.tone.get();
        eventDataObj.vibe = rootStateModel.vibe.get();
        eventDataObj.objects = buildObjectList();
    }
    function sendFlashlightEvent(){

    }
    function sendOverviewEvent(){

    }
    function buildObjectList(){
        var objectList = new Array;

        var curElement = new Object;
    }

    Timer{
        id: repeatTimer
    }
}
