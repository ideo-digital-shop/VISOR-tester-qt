import QtQuick 2.0
import Lemma 1.0
//import ProgenitorControls 1.0
import "RouteRendererFunctions.js" as RouteRendererFunctions

Rectangle {
    id: root
    smooth: true
    antialiasing: true

    color: "#444"

    property color simpleStyle: "#FFF"
    property real simpleWidth: 3
    property variant hero: hero
    property variant mapData
    property bool validData: (mapData || false)
    property real pixelsPerMeterScale: 1

    property point closestPoint: Qt.point(0,0)
    clip:true

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

        Hero{
            id: hero
            pixelsPerMeterScale: 20
        }

        Rectangle{
            id: closestPointIcon
            color: "#4F0"
            width: 10
            height: width
            radius: width/2
            x: RouteRendererFunctions.metersToPixels( root.closestPoint ).x - width/2
            y: RouteRendererFunctions.metersToPixels( root.closestPoint ).y - height/2
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onPressed: {
                hero.x = Qt.binding( function() { return (mouseX - mouseArea.x) } )
                hero.y = Qt.binding( function() { return (mouseY - mouseArea.y) } )
            }
        }
    }
}
