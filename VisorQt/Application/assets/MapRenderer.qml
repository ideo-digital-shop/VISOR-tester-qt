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
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            if(!validData){
                console.warn("renderer has no valid map data!");
                return;
            }

            var ctx = routeCanvas.getContext('2d')
            ctx.clearRect(0, 0, routeCanvas.width, routeCanvas.height)

            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            //            ctx.strokeStyle = "#FFA000"
            ctx.lineWidth = simpleWidth

            var pixelStartPoint
            var currSegment
            var currentSection
            var mapPoint
            var pixelMapPoint

            for(var i = 0; i < mapData.nSegments; i++){
                currSegment = mapData.getSegment(i)
                if( currSegment.isTarget )ctx.strokeStyle = "#FFA000";
                else ctx.strokeStyle = "white";
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
            id: segmentNames
            model: mapData.segments.children
            anchors.fill: parent
            Text{
                smooth:true; antialiasing: true
                color: mapData.segments.children[index].isTarget ? Qt.lighter("green") : Qt.lighter("red");
                text: mapData.segments.children[index].segmentName
                x: root.pixelsPerMeterScale*mapData.segments.children[index].minBoundPoint.x
                y: root.pixelsPerMeterScale*mapData.segments.children[index].minBoundPoint.y
            }
        }
        //        Repeater{
        //            id: segmentHeadings
        //            model: evaluation.proximityEvaluation.segmentEvalArray
        //            anchors.fill: parent
        //            Text{
        //                property variant currentError:evaluation.proximityEvaluation.segmentEvalArray[index]
        //                property variant owningSegment: mapData.getSegment(currentError.segmentIndex)
        //                property real errorVectorDeg: 180/Math.PI * currentError.errorVector.heading
        //                property real errorHeadingDeg:{
        //                    var result = errorVectorDeg-90;
        //                    if(result>180)result-=360;
        //                    if(result<-180)result+=360;
        //                    return result;
        //                }
        //                property real relHeroHeading:{
        //                    var result = errorHeadingDeg - heroModel.heroHeading;
        //                    if(result>180)result-=360;
        //                    if(result<-180)result+=360;
        //                    return result;
        //                }
        //                smooth:true; antialiasing: true
        //                color: "cyan"
        //                font.pixelSize: 12
        //                text: owningSegment.isTarget ? parseInt(relHeroHeading) + "\u00b0": ""
        //                x: root.pixelsPerMeterScale*mapData.segments.children[index].minBoundPoint.x+15
        //                y: root.pixelsPerMeterScale*mapData.segments.children[index].minBoundPoint.y+15
        //            }
        //        }
        //        Repeater{
        //            id: segmentProximities
        //            model: evaluation.proximityEvaluation.segmentEvalArray
        //            anchors.fill: parent
        //            Rectangle{
        //                smooth:true; antialiasing: true
        //                width: 23
        //                height: width
        //                radius: width/2
        //                color: "transparent"
        //                border.color: "#480"
        //                border.width: 1.5
        //                property var posPoint: evaluation.proximityEvaluation.segmentEvalArray[index].cartPosition
        //                property point pixelLocation: posPoint ? RouteRendererFunctions.metersToPixels( posPoint ) : Qt.point(-50,-50)
        //                x: pixelLocation.x - width/2
        //                y: pixelLocation.y - height/2
        //            }
        //        }

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
                Text{
                    id: pathHeadings
                    color: "magenta"
                    property variant currentErrorVector: evaluation.proximityEvaluation.errorVector
                    property variant currentIndex:evaluation.proximityEvaluation.networkPosition.segmentIndex
                    property variant owningSegment: mapData.getSegment(currentIndex)
                    property real pathHeading: owningSegment.pathHeading(evaluation.proximityEvaluation.networkPosition.lengthPosition)
                    property real incidenceHeading: {
                        var corPathHeading = 180/Math.PI*pathHeading;
                        corPathHeading = corPathHeading >= 180 ? corPathHeading-180 : corPathHeading;
                        var errVect = 180/Math.PI*currentErrorVector.heading+90
                        var result = corPathHeading+errVect+heroModel.heroOrientation;
                        if(result>180)result-=360;
                        if(result<-180)result+=360;
                        if(errVect >= 180) result = -(heroModel.heroHeading+corPathHeading-90);
                        else result = -(heroModel.heroHeading+corPathHeading+90);
                        if(result>180)result-=360;
                        if(result<-180)result+=360;
                        return result;
                    }
                    text: incidenceHeading
                }
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
                positionSignal.connect( root.heroModel.setSynchPosition);
            }

            onPressed: {
                if( !rootStateModel.isPositionController ) return;
                posPoint.x = Qt.binding( function() { return (mouseX - mouseArea.x)/pixelsPerMeterScale } );
                posPoint.y = Qt.binding( function() { return (mouseY - mouseArea.y)/pixelsPerMeterScale } );
            }
            onReleased: {
                if( !rootStateModel.isPositionController ) return;
                posPoint.x = (mouseX - mouseArea.x)/pixelsPerMeterScale ;
                posPoint.y = (mouseY - mouseArea.y)/pixelsPerMeterScale ;
            }
        }
    }
}
