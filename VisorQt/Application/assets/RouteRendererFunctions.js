
//renders a route segment//--------------------------------------------------------------------------------
function renderSegment( ctx, index, routeData, networkGraph, canvasOrigin, startRouteLengthPos, endRouteLengthPos ){ //--------------------------------------------------------------------------------
    var segmentIndex = routeData.segmentIndices[index];
    var segment = networkGraph.getSegment( segmentIndex );
    var segmentPolarity = routeData.segmentPolarities[index];
    var startSectionIndex
    var startSectionPosition = undefined;
    var endSectionIndex
    var endSectionPosition = undefined;
    var currentSection

    // If specific start and end length positions weren't passed in then default to the whole route
    startRouteLengthPos = startRouteLengthPos || 0;
    endRouteLengthPos = endRouteLengthPos || routeData.totalLength;

    // Clamp the ranges and make sure the start is before the end
    if( startRouteLengthPos < 0 )
        startRouteLengthPos = 0;
    if( endRouteLengthPos > routeData.totalLength )
        endRouteLengthPos = routeData.totalLength;
    if( endRouteLengthPos < startRouteLengthPos ){
        var temp = endRouteLengthPos;
        endRouteLengthPos = startRouteLengthPos;
        startRouteLengthPos = temp;
    }

    // Convert the route length positions to segment length positions
    var startNetworkPos = routeData.routeToSegmentLengthPos( startRouteLengthPos );
    var endNetworkPos = routeData.routeToSegmentLengthPos( endRouteLengthPos );
    //console.log( "rendering segment index: " + index + ", start segment index:" + startNetworkPos.segmentIndex + ", indices index:" + startNetworkPos.segmentIndicesIndex + ", pos:" + startNetworkPos.lengthPosition + ", end segment index:" + endNetworkPos.segmentIndex + ", indices index: " + endNetworkPos.segmentIndicesIndex + ", pos:" + endNetworkPos.lengthPosition );

    // If the segment we're rendering is outside the range of the segments that should be rendered
    // for the route
    if( index < startNetworkPos.segmentIndicesIndex || index > endNetworkPos.segmentIndicesIndex ){

        //console.log( "index " + index + " is outside of route range [" + startNetworkPos.segmentIndicesIndex + "," + endNetworkPos.segmentIndicesIndex + "]")
        return;
    }

    // Clamp our render section indices to the current segment
    if( startNetworkPos.segmentIndicesIndex < index ){

        startNetworkPos.segment = segment;
        startNetworkPos.segmentIndex = segmentIndex;
        startNetworkPos.segmentIndicesIndex = index;
        startNetworkPos.lengthPosition = segmentPolarity ? 0 : segment.totalLength;
    }
    if( endNetworkPos.segmentIndicesIndex > index ){

        endNetworkPos.segment = segment;
        endNetworkPos.segmentIndex = segmentIndex;
        endNetworkPos.segmentIndicesIndex = index;
        endNetworkPos.lengthPosition = segmentPolarity ? segment.totalLength : 0;
    }

    var startSectionData = segment.getSectionData(startNetworkPos.lengthPosition);
    var endSectionData = segment.getSectionData(endNetworkPos.lengthPosition);

    //forward rendering of segment loop
    if(segmentPolarity){

        startSectionIndex = startSectionData.sectionIndex;
        startSectionPosition = startSectionData.sectionPosition;

        endSectionIndex = endSectionData.sectionIndex;
        endSectionPosition = endSectionData.sectionPosition;
        /*
        startSectionIndex = 0;
        endSectionIndex = segment.segmentSections.count-1;

        if( index === startNetworkPos.segmentIndicesIndex ){  //first segment in route is partial start point segment
            startSectionIndex = segment.getSectionData(startNetworkPos.lengthPosition).sectionIndex;
            startSectionPosition = segment.getSectionData(startNetworkPos.lengthPosition).sectionPosition;
            //console.log("Start forward section index: " + startSectionIndex + ", pos: " + startSectionPosition + ", segment length pos: " + startNetworkPos.lengthPosition)
        }
        if( index === endNetworkPos.segmentIndicesIndex ){ //last segment is partial end point segment
            //console.log("endSectionIndex:" + endSectionIndex + ", endNetworkPos.lengthPosition:" + endNetworkPos.lengthPosition)
            endSectionIndex = segment.getSectionData(endNetworkPos.lengthPosition).sectionIndex;
            endSectionPosition = segment.getSectionData(endNetworkPos.lengthPosition).sectionPosition;
            //console.log("rendering forward end sections " + startSectionIndex + "(" + startSectionPosition + ") through " + endSectionIndex + " (" + endSectionPosition + ")")
        }
        */

        //console.log("rendering forward sections " + startSectionIndex + " through " + endSectionIndex)
        for (var i=startSectionIndex; i<=endSectionIndex; i++){

            currentSection = segment.segmentSections.get(i);

            if(i===startSectionIndex && i===endSectionIndex)
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity, startSectionPosition, endSectionPosition);
            else if(i === startSectionIndex)
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity, startSectionPosition, undefined);
            else if(i === endSectionIndex)
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity, undefined, endSectionPosition);
            else
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity);
        }
    }//end forward render

    //reverse rendering of segment loop
    else{

        startSectionIndex = endSectionData.sectionIndex;
        startSectionPosition = endSectionData.sectionPosition;

        endSectionIndex = startSectionData.sectionIndex;
        endSectionPosition = startSectionData.sectionPosition;

        startSectionIndex = startSectionData.sectionIndex;
        startSectionPosition = startSectionData.sectionPosition;

        endSectionIndex = endSectionData.sectionIndex;
        endSectionPosition = endSectionData.sectionPosition;

        /*
        startSectionIndex = segment.segmentSections.count-1;
        endSectionIndex = 0;

        if( index === startNetworkPos.segmentIndicesIndex ){  //first segment in route is partial start point segment
            startSectionIndex = segment.getSectionData(startNetworkPos.lengthPosition).sectionIndex;
            startSectionPosition = segment.getSectionData(startNetworkPos.lengthPosition).sectionPosition;
        }
        if(index === endNetworkPos.segmentIndicesIndex){ //last segment is partial end point segment
            endSectionIndex = segment.getSectionData(endNetworkPos.lengthPosition).sectionIndex;
            endSectionPosition = segment.getSectionData(endNetworkPos.lengthPosition).sectionPosition;
            //console.log("rendering reverse end sections " + startSectionIndex + "(" + startSectionPosition + ") through " + endSectionIndex + " (" + endSectionPosition + ")")
        }
        */

        //console.log("rendering reverse sections " + startSectionIndex + " through " + endSectionIndex)
        for (var i=startSectionIndex; i>=endSectionIndex; i--){

            currentSection = segment.segmentSections.get(i);

            if(i===startSectionIndex && i===endSectionIndex)
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity, startSectionPosition, endSectionPosition);
            else if(i === startSectionIndex)
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity, startSectionPosition, undefined);
            else if(i === endSectionIndex)
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity, undefined, endSectionPosition);
            else
                renderSection(ctx, canvasOrigin, currentSection, segmentPolarity);
        }
    }//end reverse rendering of segment loop
}

//renders a complete or partial segment section, render direction controlled by polarity//--------------------------------------------------------------------------------
function renderSection( ctx, canvasOrigin, section, polarity, startPosition, endPosition){//--------------------------------------------------------------------------------

    //console.log("renderSection start pos: " + startPosition + ", end pos: " + endPosition + ", type: " + section.type)
    //linear section rendering
    if(section.type === "linear"){
        var pixelEnd = Qt.point(0,0);
        var pixelStart = Qt.point(0,0);

            if(typeof startPosition == typeof undefined){
                if (polarity ) pixelStart = metersToPixels(Qt.point(section.x1,section.y1));
                else pixelStart = metersToPixels(Qt.point(section.x2,section.y2));
            }
            else{
                pixelStart.x = (section.x2 - section.x1) * (startPosition/section.length) + section.x1;
                pixelStart.y = (section.y2 - section.y1) * (startPosition/section.length) + section.y1;
                pixelStart = metersToPixels(pixelStart);
            }

            if(typeof endPosition == typeof undefined){
                if ( polarity ) pixelEnd = metersToPixels(Qt.point(section.x2,section.y2));
                else pixelEnd = metersToPixels(Qt.point(section.x1,section.y1));
            }

            else{
                pixelEnd.x = (section.x2 - section.x1) * (endPosition/section.length) + section.x1;
                pixelEnd.y = (section.y2 - section.y1) * (endPosition/section.length) + section.y1;
                pixelEnd = metersToPixels(pixelEnd);
            }


        ctx.moveTo(pixelStart.x - canvasOrigin.x, pixelStart.y - canvasOrigin.y);
        ctx.lineTo(pixelEnd.x - canvasOrigin.x, pixelEnd.y - canvasOrigin.y);
    }//end linear section rendering

    //arc section rendering
    else if(section.type === "arc"){
        var startAngle
        var endAngle
        var dir = !(section.angle > 0) && polarity || (section.angle>0) && !polarity;

        if(typeof startPosition == typeof undefined) {
            if( polarity ) startAngle = section.startAngle;
            else startAngle = section.endAngle;
        }
        else{
            if(!dir) startAngle = startPosition/section.length * (section.endAngle - section.startAngle) + section.startAngle;
            else startAngle = section.startAngle - startPosition/section.length * (section.startAngle - section.endAngle);
        }

        if(typeof endPosition == typeof undefined) {
            if( polarity ) endAngle = section.endAngle;
            else endAngle = section. startAngle;
        }
        else{
            if(!dir) endAngle = endPosition/section.length * (section.endAngle - section.startAngle) + section.startAngle;
            else endAngle = section.startAngle - endPosition/section.length * (section.startAngle - section.endAngle);
        }

        var pixelOrigin = metersToPixels(Qt.point(section.originX,section.originY));
        var pixelRadius = section.radius*pixelsPerMeterScale;
        ctx.arc(pixelOrigin.x - canvasOrigin.x, pixelOrigin.y - canvasOrigin.y, Math.abs(pixelRadius), startAngle, endAngle, dir);
    }//end arc section rendering
}

function metersToPixels( point ){
    var pixelPoint = Qt.point(0,0);
    pixelPoint.x = point.x*pixelsPerMeterScale;
    pixelPoint.y = point.y*pixelsPerMeterScale;
    return pixelPoint;
}
