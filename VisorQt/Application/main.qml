//Copyright (c) 2014, IDEO

/*
TODO:
• Serialize graph data - send out the entire graph over noam?
• Draw grid in renderer
• signal handler - connect to noam if config and connected, connect internal if not config
• expose some shit to config file
• build event handler (sends abstract events)
• add speech, tone, vibe toggles
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

    property string recMessage: ""

    //Hear Noam message
    NoamLemmaHears{
        topic: "sampleMessage"
        onNewEvent:{
            recMessage = value;
        }
    }

    StateModel{
        id: rootStateModel
    }

    EventManager{
        id: eventManager
        mapData: mapView.mapData
        evaluation: mapView.mapEvaluation
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
        x: 200
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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
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
            //            var mapEvaluation = mapData.evaluatePointToGraph( mapRenderer.hero.heroPositionMeters );
            //            sampleText.text = mapEvaluation.errorVector.magnitude.toFixed(1);
            //            mapRenderer.closestPoint = mapData.getNetworkCoord( mapEvaluation.networkPosition );
        }
    }
}
