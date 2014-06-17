//Copyright (c) 2014, IDEO

/*
TODO:
• Section.evaluateVector
• Segment.evaluateVector - returns {heroVector (vector from hero to closest point of segment), networkPosition (network position of closest point), coord (x,y coord of closest point)
• NetworkGraph.evaluateVector - use to find what the hero is pointing at, how far they are from it
• Serialize graph data - send out the entire graph over noam?
• Auto scaling - set scale factor based on size of window and bounding box of map
• Draw grid in renderer
• expose some shit to config file
*/
import QtQuick 2.2
import QtQuick.Window 2.1
import Lemma 1.0
import "Moderator/Moderator_Elements"

Rectangle {
    property alias mapData: mapData
    property alias heroModel: heroModel
    property variant mapEvaluation: mapData.evaluateMap( heroModel )

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
        anchors.leftMargin: 20
        anchors.topMargin: 20
        pixelsPerMeterScale:{
            var xppm = width/mapData.maxBoundPoint.x;
            var yppm = height/mapData.maxBoundPoint.y;
            return .85*Math.min( xppm , yppm );
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
