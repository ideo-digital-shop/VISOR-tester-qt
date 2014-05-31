//Copyright (c) 2014, IDEO

/*
TODO:
Segment.heroEvaluation - returns {heroVector (vector from hero to closest point of segment), networkPosition (network position of closest point), coord (x,y coord of closest point)
NetworkGraph.evaluateVector - use to find what the hero is pointing at, how far they are from it
Serialize graph data - send out the entire graph over noam?
*/
import QtQuick 2.2
import QtQuick.Window 2.1
import Lemma 1.0
import "assets"

Rectangle {
    visible: true
    width: 1680
    height: 1050
    smooth: true
    antialiasing: true

    property int clickCount: 0
    property bool noamIsConnected: false
    property string recMessage: ""

    //Hear Noam message
    NoamLemmaHears{
        topic: "sampleMessage"
        onNewEvent:{
            recMessage = value;
        }
    }

    RouteRenderer{
        id: routeRender
        mapData: mapData
        anchors.fill: parent
        pixelsPerMeterScale: 20
    }

    MapData{
        id: mapData
    }

    //Text display of received noam message
    Text {
        id: sampleText
        color: "white"
        font.pixelSize: 36
        text:{
            if( noamIsConnected ){
                if( !recMessage ) return qsTr("Click the mouse to send a message.");
                else return recMessage;
            }
            else return qsTr("Looking for Noam Hosts...");
        }
        anchors.centerIn: parent
    }

    //Track Noam connection status
    NoamConnectionStatus{
        onConnectionEstablished: noamIsConnected = true;
        onConnectionLost: noamIsConnected = false;
    }

    property int sendOrient: 0
    Timer{
        id: testTimer
        running:true
        repeat:true
        interval: 50
        onTriggered: {
            noamLemma.speak( "heroOrientation" , sendOrient );
            sendOrient++;
            if( sendOrient > 360 ) sendOrient = 0;
            var mapEvaluation = mapData.evaluatePointToGraph( routeRender.hero.heroPositionMeters );
            sampleText.text = mapEvaluation.errorVector.magnitude.toFixed(1);
            routeRender.closestPoint = mapData.getNetworkCoord( mapEvaluation.networkPosition );
        }
    }
}
