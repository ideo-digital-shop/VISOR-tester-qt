//Adds roles to list model object ------------------------------------------------------------------------------------------------
function buildSectionData ( section ){
    //universal data prelim

    //arc only data
    if( section.type === "arc"){
        var theta = section.angle * Math.PI/180
        var chordLength = pointVector(Qt.point(section.x1, section.y1), Qt.point(section.x2, section.y2)).magnitude;
        var radius = chordLength/(2*Math.sin(theta/2));
        var y1=section.y1; var x1=section.x1;
        var y2=section.y2; var x2=section.x2;

        var phi = Math.atan2((y2 - y1), (x2 - x1));
        var tau = (Math.PI - theta)/2;
        var alpha = tau - phi;
        var startAngle = - alpha - theta;
        var endAngle = - alpha;

        if(theta<0){
            startAngle = startAngle + Math.PI;
            endAngle = endAngle + Math.PI;
        }

        var originY = y1 + radius * Math.sin( alpha + theta );
        var originX = x1 - radius * Math.cos( alpha + theta );

        section.radius = radius;
        section.startAngle = startAngle;
        section.endAngle = endAngle;
        section.originX = originX;
        section.originY = originY;
    }
    //linear only data
    else if( section.type == "linear" ){}
    //universal data
    section.length = getSectionLength( section );
}

//calculates vector between 2 cartesian points ------------------------------------------------------------------------------------------------
function pointVector ( point1, point2 ){
    var x = point1.x - point2.x;
    var y = point1.y - point2.y;
    var result = new Object();

    result.magnitude = Math.sqrt(x*x+y*y);
    result.heading = Math.atan2(y , x);
    return result;
}

// returns the length of a segment section ------------------------------------------------------------------------------------------------
function getSectionLength( section ){
    switch (section.type){
    case "linear":
        var sectionStartPoint = Qt.point(section.x1, section.y1);
        var sectionEndPoint = Qt.point(section.x2, section.y2);
        return pointVector(sectionStartPoint, sectionEndPoint).magnitude;
        break;
    case "arc":
        return (Math.abs(section.endAngle - section.startAngle) * Math.abs(section.radius));
        break;
    default:
        console.debug(version + "Segment.qml: type '" + section.type + "' is not supported" );
        break;
    }
}

// returns the index of the section containing a segment length position ------------------------------------------------------------------------------------------------
function getSectionIndex( lengthPosition ){
    var currentSection
    var sectionLength
    var evalLength = lengthPosition;
    var completedLength = 0;

    for (var i=0; i<segmentSections.count; i++){
        currentSection = segmentSections.get(i);
        sectionLength = currentSection.length;
        if(lengthPosition - completedLength < sectionLength){
            return i;
        }
        evalLength -= sectionLength;
        completedLength += sectionLength;
    }

    // Default to returning the last section
    return segmentSections.count - 1;
}

//returns the section length position of a section for a given segment length position ------------------------------------------------------------------------------------------------
function getSectionLengthPosition( lengthPosition ){
    var currentSection
    var sectionLength
    var evalLength = lengthPosition;
    var completedLength = 0;

    for (var i=0; i<segmentSections.count; i++){
        currentSection = segmentSections.get(i);
        sectionLength = currentSection.length;
        if(lengthPosition - completedLength < sectionLength){
            return lengthPosition - completedLength;
        }
        evalLength -= sectionLength;
        completedLength += sectionLength;
    }

    //console.log( "Failed to find section length position for:" + lengthPosition + ", total length:" + totalLength )

    // Default to return the end of the last segment
    return segmentSections.get( segmentSections.count - 1 ).length;
}

// function that returns the x/y coordinates of a section path given the section and length position ------------------------------------------------------------------------------------------------
function getSectionCoord( section, length ){
    var result = Qt.point(0,0);
    var sectionLength = section.length;

    if( length > sectionLength){
        length = sectionLength;
    }
    if( length < 0){
        length = 0;
    }
    switch (section.type){
    case "arc":
        var angle = section.angle > 0 ? length/sectionLength * (section.endAngle - section.startAngle) + section.startAngle : (section.startAngle - length/sectionLength * (section.startAngle - section.endAngle));
        result.x = Math.cos(angle) * section.radius + section.originX;
        result.y = Math.sin(angle) * section.radius + section.originY;
        if(section.angle<0){
            result.x = -Math.cos(angle) * section.radius + section.originX
            result.y = -Math.sin(angle) * section.radius + section.originY;
        }
        break;
    case "linear":
        result.x = (section.x2 - section.x1) * (length/sectionLength) + section.x1;
        result.y = (section.y2 - section.y1) * (length/sectionLength) + section.y1;
        break;
    default:
        console.debug(version + "Segment.qml: type '" + section.type + "' is not supported" );
        break;
    }
    return result;
}

// function that returns the heading (0 -> 2pi, clockwise from north) of a section path given the section and length position ------------------------------------------------------------------------------------------------
function getSectionHeading( section, length ){
    var _result = 0;
    var sectionLength = section.length;

    if( length > sectionLength){
        length = sectionLength;
    }
    if( length < 0){
        length = 0;
    }

    switch (section.type){
    case "arc":
        _result = Math.atan2 ((getSectionCoord(section, length).y - section.originY),(getSectionCoord(section, length).x - section.originX));
        if(section.angle > 0) _result += Math.PI;
        if(_result < 0 ) _result += 2*Math.PI;
        break;

    case "linear":
        _result = Math.atan2 ((section.y2-section.y1), (section.x2-section.x1));
        if( _result < 0 ) _result += 2*Math.PI;
        _result+= .5 * Math.PI;
        if( _result >= 2*Math.PI ) _result -= 2*Math.PI;
        break;

    default:
        console.debug(version + "Segment.qml: type '" + section.type + "' is not supported" );
        break;
    }
    return _result;
}

// returns corners of the bounding box of the section
function getPathBounds( section, startLength, endLength ){
    var result = new Object();
    var minBoundPoint = Qt.point(0,0);
    var maxBoundPoint = Qt.point(0,0);
    var x1 = section.x1;
    var x2 = section.x2;
    var y1 = section.y1;
    var y2 = section.y2;

    if(startLength){
        x1 += startLength/section.length * (x2 - x1);
        y1 += startLength/section.length * (y2 - y1);
    }
    if(endLength){
        x2 = section.x1 + endLength/section.length * (x2 - x1);
        y2 = section.y1 + endLength/section.length * (y2 - y1);
    }


    switch (section.type){
    case "arc": //simplified arc solution doesn't take actual swept angle into account
        minBoundPoint.x = section.originX - section.radius;
        minBoundPoint.y = section.originY - section.radius;
        maxBoundPoint.x = section.originX + section.radius;
        maxBoundPoint.y = section.originY + section.radius;
        break;
    case "linear":
        minBoundPoint.x = Math.min(x1, x2);
        minBoundPoint.y = Math.min(y1, y2);
        maxBoundPoint.x = Math.max(x1, x2);
        maxBoundPoint.y = Math.max(y1, y2);
        break;
    default:
        console.debug(version + "Segment.qml: type '" + section.type + "' is not supported" );
        break;
    }
    result.minBoundPoint = minBoundPoint;
    result.maxBoundPoint = maxBoundPoint;
    return result;
}

//Function that finds the errorVector and sectionPosition of the minError from x,y point to section path ------------------------------------------------------------------------------------------------
function evaluatePointToSection ( section, evalPoint ){
    var sectionLength = section.length;
    var evalPosition = 0;
    var sectionPosition = 0;
    var testError = pointVector(evalPoint, getSectionCoord( section, evalPosition ));
    var errorVector = testError;

    switch (section.type){
    case "arc":
        var evalAngle = Math.atan2((section.originY - evalPoint.y),(evalPoint.x - section.originX));
        var evalStart = section.startAngle;
        //rectify evalStart
        if(evalStart<0) evalStart += 2*Math.PI;
        else if (evalStart>2*Math.PI) evalStart -= 2*Math.PI;
        //rectify evalAngle
        if(evalAngle<0)evalAngle = -evalAngle;
        else evalAngle = 2*Math.PI-evalAngle;
        var evalEnd = evalStart + section.angle*Math.PI/180;
        //rectify evalEnd
        if(evalEnd<0) evalEnd += 2*Math.PI;
        else if (evalEnd>2*Math.PI) evalEnd -= 2*Math.PI;

        var inBounds
        if(section.angle > 0){ //clockwise render
            if(evalEnd>evalStart){ //no transit
                if((evalAngle > evalStart) && (evalAngle < evalEnd)){
                    sectionPosition = (evalAngle - evalStart) * section.radius;
                    inBounds = true;
                }
                else inBounds = false;
            }
            else{ //arc transits 0
                if((evalAngle > evalStart) || (evalAngle < evalEnd)){
                    if(evalAngle > evalStart) sectionPosition = (evalAngle - evalStart) * section.radius;
                    else sectionPosition = (2*Math.PI - evalStart + evalAngle) * section.radius;
                    inBounds = true;
                }
                else inBounds = false;
            }
        }
        else{ //counter clockwise render
            if(evalEnd < evalStart){ //no transit
                if((evalAngle < evalStart) && (evalAngle > evalEnd)){
                    sectionPosition = (evalAngle - evalStart) * section.radius;
                    inBounds = true;
                }
                else inBounds = false;
            }
            else{ //arc transits 0
                if((evalAngle < evalStart) || (evalAngle > evalEnd)){
                    if(evalAngle < evalStart) sectionPosition = (evalAngle - evalStart) * section.radius;
                    else sectionPosition = -(2*Math.PI - evalAngle + evalStart) * section.radius;
                    inBounds = true;
                }
                else inBounds = false;
            }
        }
        if(inBounds){
            errorVector = pointVector(evalPoint, getSectionCoord(section, sectionPosition));
        }
        else{
            var startErrorVector = pointVector(evalPoint, Qt.point(section.x1,section.y1));
            var endErrorVector = pointVector(evalPoint, Qt.point(section.x2,section.y2));
            if(startErrorVector.magnitude > endErrorVector.magnitude){
                errorVector = endErrorVector;
                sectionPosition = sectionLength-.001;
            }
            else{
                errorVector = startErrorVector;
                sectionPosition = 0;
            }
        }

        break;
    case "linear":
        var startPoint = Qt.point(section.x1, section.y1);
        var endPoint = Qt.point(section.x2, section.y2);
        var length = pointVector(startPoint, endPoint).magnitude;
        var startError = pointVector(evalPoint, startPoint);
        var startMag = startError.magnitude;
        var startHyp = Math.sqrt(length*length + startMag *startMag);
        var endError = pointVector(evalPoint, endPoint);
        var endMag = endError.magnitude;
        var endHyp = Math.sqrt(length*length + endMag *endMag);
        if(endMag > startHyp){ //start point is the closet point
            errorVector = startError;
            sectionPosition = 0;
        }
        else if(startMag > endHyp){ //end point is the closest point
            errorVector = endError;
            sectionPosition = sectionLength;
        }
        else if(endPoint.x === startPoint.x){ //closest point to vertical segment
            sectionPosition = Math.abs(evalPoint.y - startPoint.y);
            errorVector = pointVector(evalPoint, Qt.point(startPoint.x, evalPoint.y));
        }
        else{ //closest point to a non-vertical line
            var lineSlope = (endPoint.y - startPoint.y)/(endPoint.x - startPoint.x);
            var lineInt = startPoint.y - lineSlope*startPoint.x;
            var minErrorPoint = Qt.point(0,0);
            minErrorPoint.x = (lineSlope * evalPoint.y + evalPoint.x - lineSlope * lineInt)/(lineSlope * lineSlope + 1);
            minErrorPoint.y = lineSlope * minErrorPoint.x + lineInt;
            errorVector = pointVector(evalPoint, minErrorPoint);
            sectionPosition = pointVector(startPoint, minErrorPoint).magnitude;
        }

        break;
    default:
        console.debug(version + "Segment.qml: type '" + section.type + "' is not supported" );
        break;
    }

    var result = new Object;
    result.errorVector = errorVector;
    result.sectionPosition = sectionPosition;

    return result;
}

function evaluateVectorToSection( testSection, evalPosition , evalHeading ){
    var transHeading = Math.PI / 180 * ( ( 630 - evalHeading ) % 360 );
    var sectionStartPoint = Qt.point(testSection.x1, testSection.y1);
    var sectionEndPoint = Qt.point(testSection.x2, testSection.y2);
    var evalEndPoint = Qt.point( evalPosition.x + 2000 * Math.cos( transHeading) , evalPosition.y - 2000 * Math.sin( transHeading ) );
    var result = new Object;

    var intersection = checkLineIntersection( sectionStartPoint.x , sectionStartPoint.y , sectionEndPoint.x , sectionEndPoint.y,
                                              evalPosition.x , evalPosition.y , evalEndPoint.x , evalEndPoint.y );
    if( intersection && intersection.onLine1 && intersection.onLine2 ){
        var intersectionPoint = Qt.point( intersection.x , intersection.y );
        result.sectionPosition = pointVector( sectionStartPoint , intersectionPoint ).magnitude;
        result.displacementMag = pointVector( evalPosition , intersectionPoint ).magnitude;
    }
    else{
        result.displacementMag = undefined;
    }
    return result;
}

function checkLineIntersection(line1StartX, line1StartY, line1EndX, line1EndY, line2StartX, line2StartY, line2EndX, line2EndY) {
    // if the lines intersect, the result contains the x and y of the intersection (treating the lines as infinite) and booleans for whether line segment 1 or line segment 2 contain the point
    var denominator, a, b, numerator1, numerator2, result = {
        x: null,
        y: null,
        onLine1: false,
        onLine2: false
    };
    denominator = ((line2EndY - line2StartY) * (line1EndX - line1StartX)) - ((line2EndX - line2StartX) * (line1EndY - line1StartY));
    if (denominator == 0) {
        return result;
    }
    a = line1StartY - line2StartY;
    b = line1StartX - line2StartX;
    numerator1 = ((line2EndX - line2StartX) * a) - ((line2EndY - line2StartY) * b);
    numerator2 = ((line1EndX - line1StartX) * a) - ((line1EndY - line1StartY) * b);
    a = numerator1 / denominator;
    b = numerator2 / denominator;

    // if we cast these lines infinitely in both directions, they intersect here:
    result.x = line1StartX + (a * (line1EndX - line1StartX));
    result.y = line1StartY + (a * (line1EndY - line1StartY));
/*
        // it is worth noting that this should be the same as:
        x = line2StartX + (b * (line2EndX - line2StartX));
        y = line2StartX + (b * (line2EndY - line2StartY));
        */
    // if line1 is a segment and line2 is infinite, they intersect if:
    if (a > 0 && a < 1) {
        result.onLine1 = true;
    }
    // if line2 is a segment and line1 is infinite, they intersect if:
    if (b > 0 && b < 1) {
        result.onLine2 = true;
    }
    // if line1 and line2 are segments, they intersect if both of the above are true
    return result;
};
