//Copyright (c) 2014, IDEO

/*
TODO:
• signal handler - connect to noam if config and connected, connect internal if not config
• expose some shit to config file
• Add 'mouse control on/off' button
*/

import QtQuick 2.2
import QtQuick.Window 2.1
import Lemma 1.0
import MyTools 1.0
import "assets"
import "assets/Moderator"

Rectangle {
    id: root
    visible: true
    width: parent ? parent.width : 0
    height: parent ? parent.height : 0
    smooth: true
    antialiasing: true
    color: "#444"

    property int clickCount: 0
    property bool noamIsConnected: false
    property bool useNoamPosition: false
    property bool isMasterModerator: masterStatusHandler.isMasterModerator
    onIsMasterModeratorChanged: {
            if( isMasterModerator ) connectEventManager();
            else disconnectEventManager();
    }

    property string recMessage: ""

    signal sendFlashSignal()
    signal rootCaneSignal()

    function connectEventManager(){
        sendFlashSignal.connect( eventManager.sendFlashlightEvent );
        eventManager.connect();
        console.log("Signals connected successfully.")
    }

    function disconnectEventManager(){
        sendFlashSignal.disconnect( eventManager.sendFlashlightEvent );
        eventManager.disconnect();
        console.log("Signals disconnected successfully.")
    }

    //Hear Noam message
    NoamLemmaHears{
        topic: "sampleMessage"
        onNewEvent:{
            recMessage = value;
        }
    }

    NoamLemmaHears{
        topic: "sendFlashSignal"
        onNewEvent:{
            sendFlashSignal();
        }
    }
    NoamLemmaHears{
        topic: "heroPosSynch"
        onNewMapEvent: {
            var newPos = Qt.point( value.x , value.y );
            mapView.heroModel.setPosition( newPos );
        }
    }
    NoamLemmaHears{
        topic: "IMU2"
        onNewEvent:{
            if( rootStateModel.headingSource.get() == "body" ){
                var parsed = JSON.parse(value);
                mapView.heroModel.bulkOrientation = (parseInt(parsed[2]) + 360) % 360;
            }
        }
    }
    NoamLemmaHears{
        topic: "IMU"
        onNewEvent:{
            if( rootStateModel.headingSource.get() == "head" ){
                var parsed = JSON.parse(value);
                mapView.heroModel.bulkOrientation = (parseInt(parsed[2]) + 360) % 360;
            }
        }
    }
    NoamLemmaHears{
        topic: "iPhoneHeading"
        onNewEvent:{
            if(iPhoneThrottleTimer.running)return;
            if( rootStateModel.headingSource.get() == "gesture" ){
                mapView.heroModel.bulkOrientation = (value + 360) % 360;
                iPhoneThrottleTimer.start();
            }
        }
    }
    Timer{
        id: iPhoneThrottleTimer
        interval: 75
        running: false
        repeat: false
    }

    StateModel{
        id: rootStateModel
    }

    EventManager{
        id: eventManager
        mapData: mapView.mapData
        evaluation: mapView.mapEvaluation
        heroModel: mapView.heroModel
    }

    Moderator{
        id:moderatorPanel
        height: root.height
        anchors.right: divider.horizontalCenter
        anchors.left: parent ? parent.left : undefined
    }

    MapView{
        id:mapView
        anchors.left: moderatorPanel.right
        anchors.top: parent ? parent.top : undefined
        anchors.right: parent ? parent.right : undefined
        height: parent.height
    }

    Rectangle{
        id: divider
        height: parent.height
        width: 4
        x: 50
        color: "#7B7"
        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            drag.target: divider
            drag.axis: Drag.XAxis
            drag.minimumX: 20
            drag.maximumX: root.width-20
        }
    }

    //Track Noam connection status
    NoamConnectionStatus{
        onConnectionEstablished: noamIsConnected = true;
        onConnectionLost: noamIsConnected = false;
    }

    MasterStatusHandler{
        id: masterStatusHandler
        noamIsConnected: root.noamIsConnected
    }

    //    property int sendOrient: 0
    //    Timer{
    //        id: testTimer
    //        running:true
    //        repeat:true
    //        interval: 50
    //        onTriggered: {
    ////            noamLemma.speak( "heroOrientation" , sendOrient );
    ////            sendOrient++;
    ////            if( sendOrient > 360 ) sendOrient = 0;
    //            //            var mapEvaluation = mapData.evaluatePointToGraph( mapRenderer.hero.heroPositionMeters );
    //            //            sampleText.text = mapEvaluation.errorVector.magnitude.toFixed(1);
    //            //            mapRenderer.closestPoint = mapData.getNetworkCoord( mapEvaluation.networkPosition );
    //        }
    //    }
}
