import QtQuick 2.0
import Lemma 1.0
//import ProgenitorControls 1.0
import "RouteRendererFunctions.js" as RouteRendererFunctions

Rectangle {
    id: root
    smooth: true
    antialiasing: true

    color: "#444"

    property color simpleStyle: "#DDD"
    property real simpleWidth: 1
    property variant hero: hero
    property variant mapData
    property bool validData: (mapData || false)
    property real pixelsPerMeterScale: 1    
    property variant heroModel
    property variant evaluation
    property point closestPoint: Qt.point(0,0)    

    Canvas{        

        id: routeCanvas
        smooth: true
        antialiasing: true
        anchors.fill: parent
        anchors{ leftMargin: 20; rightMargin: 20; topMargin: 20; bottomMargin: 20 }
        property point canvasOrigin: Qt.point( 0 , 0 )        
        onPaint: {
            if(!validData){
                console.warn("renderer has no valid map data!");
                return;
            }

            var ctx = routeCanvas.getContext('2d')
            ctx.clearRect(0, 0, routeCanvas.width, routeCanvas.height)

            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            ctx.strokeStyle = simpleStyle
            ctx.lineWidth = simpleWidth

            var pixelStartPoint
            var currSegment
            var currentSection
            var mapPoint
            var pixelMapPoint

            for(var i = 0; i < mapData.nSegments; i++){
                currSegment = mapData.getSegment(i)
                mapPoint = currSegment.pathCoord(0)
                pixelMapPoint = RouteRendererFunctions.metersToPixels( mapPoint )
                pixelStartPoint = Qt.point(pixelMapPoint.x-routeCanvas.x, pixelMapPoint.y-routeCanvas.y)
                ctx.moveTo(pixelStartPoint.x, pixelStartPoint.y)//start point
                ctx.beginPath()
                for (var j=0; j< currSegment.segmentSections.count; j++){
                    currentSection = currSegment.segmentSections.get(j)
                    RouteRendererFunctions.renderSection(ctx, canvasOrigin, currentSection, 1)
                }
                ctx.stroke()
            }            
        }
        //            onRouteDataChanged: {requestPaint()}

        HeroView{
            id: hero
            heroModel: root.heroModel
            pixelsPerMeterScale: root.pixelsPerMeterScale
        }

        Repeater{
            id: segmentProximities
            model: evaluation.proximityEvaluation.segmentEvalArray
            anchors.fill: parent
            Rectangle{
                smooth:true; antialiasing: true
                width: 23
                height: width
                radius: width/2
                color: "transparent"
                border.color: "#480"
                border.width: 1.5
                property var posPoint: evaluation.proximityEvaluation.segmentEvalArray[index].cartPosition
                property point pixelLocation: posPoint ? RouteRendererFunctions.metersToPixels( posPoint ) : Qt.point(-50,-50)
                x: pixelLocation.x - width/2
                y: pixelLocation.y - height/2
            }
        }

        Rectangle{
            id: closestPointIcon
            color: "#8F0"
            width: 10
            height: width
            radius: width/2
            property point pixelLocation: RouteRendererFunctions.metersToPixels( evaluation.proximityEvaluation.cartPosition )
            x: pixelLocation.x - width/2
            y: pixelLocation.y - height/2
            Rectangle{
                anchors.centerIn: parent
                smooth: true
                width:36
                height: width
                radius: width/2
                color: "transparent"
                border.color: closestPointIcon.color
                border.width: 3
            }
        }

        Rectangle{
            id: headingPointIcon
            color: "#08F"
            width: 6
            height: width
            radius: width/2
            property var posPoint: evaluation.headingEvaluation.cartPosition
            property point pixelLocation: posPoint ? RouteRendererFunctions.metersToPixels( posPoint ) : Qt.point(-50,-50)
            x: pixelLocation.x - width/2
            y: pixelLocation.y - height/2
            Rectangle{
                anchors.centerIn: parent
                smooth: true
                width:44
                height: width
                radius: width/2
                color: "transparent"
                border.color: headingPointIcon.color
                border.width: 3
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            property point posPoint: Qt.point( 0 , 0 )
            signal positionSignal( var posPoint )
            onPosPointChanged: positionSignal( posPoint );
            Component.onCompleted: {
                positionSignal.connect( root.heroModel.setPosition);
            }

            onPressed: {
//                var testObj = new Object;
//                testObj.param1 = 43;
//                testObj.param2 = "hey derr";
//                noamLemma.speak( "maxTestMap" , testObj);
                posPoint.x = Qt.binding( function() { return (mouseX - mouseArea.x)/pixelsPerMeterScale } )
                posPoint.y = Qt.binding( function() { return (mouseY - mouseArea.y)/pixelsPerMeterScale } )
            }
        }
    }
}
