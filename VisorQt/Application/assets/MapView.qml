//Copyright (c) 2014, IDEO

/*
TODO:
• expose some shit to config file
*/
import QtQuick 2.2
import QtQuick.Window 2.1
import Lemma 1.0
import "Moderator/Moderator_Elements"

Rectangle {
    property alias mapData: mapData
    property alias heroModel: heroModel
    property variant mapEvaluation:mapData.evaluateMap( heroModel );

    Timer{ //once triggered breaks binding, switches to timer mode
        id: mapEvaluationTimer
        interval: 40
        running: true
        repeat: true
        onTriggered: mapEvaluation = mapData.evaluateMap( heroModel );
    }

    clip: true
    width: 300
    height: 300

    color: "#444"

    MapRenderer{
        id: mapRenderer
        mapData: mapData
        heroModel: heroModel
        evaluation: mapEvaluation
        anchors.fill: parent
        anchors.leftMargin: -100
        anchors.topMargin: 20
        pixelsPerMeterScale:{
            var xppm = width/mapData.maxBoundPoint.x;
            var yppm = height/mapData.maxBoundPoint.y;
            return 1.5*Math.min( xppm , yppm );
        }
    }
    //Text display of received noam message
    Column{
        spacing: 8
        x: 8
        Text {
            id: sampleText
            color: "white"
            font.pixelSize: 20
            text:{
                if( noamIsConnected ){
                    qsTr("Noam is connected.");
                }
                else return qsTr("Looking for Noam Hosts...");
            }
        }
        Text {
            id: masterStatusText
            color: "white"
            font.pixelSize: 20
            text:{
                if( isMasterModerator ){
                    return qsTr("Master moderator.");
                }
                else return qsTr("Secondary moderator.");
            }
            anchors.left: sampleText.left
        }
        Button{
            width: 200
            height: 30
            label: active ? "Mouse Control On" : "Mouse Control Off"
            active: rootStateModel.isPositionController
            onClicked: rootStateModel.isPositionController = !rootStateModel.isPositionController;
        }
    }

    MapData660{
        id: mapData
    }

    HeroModel{
        id: heroModel
    }

    Button{

    }
}
