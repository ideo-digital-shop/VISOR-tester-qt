import QtQuick 2.0
import Lemma 1.0
//import ProgenitorControls 1.0
import "SectionFunctions.js" as SectionFunctions

/*
  A segment is the most granular element of the map-graph system.  It defines the path between two nodes, and has some helper functions
  */
Item {
    id: root
    // When rendering map data, starting point is primarily the west-most, then north-most of the segment end-points
    // the index in the segments children[] array associated with the segment
    property int index: -1 //** populated by networkGraph
    // the total length in meters of the segment path
    property real totalLength//: getSegmentLength()
    // the time in seconds it takes to drive the segment
    property real totalTime//: timeToComplete(0, totalLength)
    // points defining the bounding box of the segment
    property point minBoundPoint: Qt.point(0,0)//:getBounds
    property point maxBoundPoint: Qt.point(0,0)//:getBounds
    // traffic density of the segment, may not be used
    property real trafficDensity: 0
    // enable forward polarity segment transversal
    property bool forwardEnabled: true
    // enable reverse polarity segment transversal
    property bool reverseEnabled: true
    // the road ListElement in owningMap that owns the segment
    property variant owningRoad: undefined //** populated by networkGraph
    // the heading direction between start and endPoint of the segment
    property real bulkHeading: 0 //** populated by Component.onCompleted 0->360 clockwise from north
    // a list defining the sections that comprise the segment
    property variant segmentSections: ListModel{}
    // the map that owns the networkGraph and associated Segments
    //property variant owningMap: defined in parent

    // the speed limit for this segment in kilometers per hour (56=35mph,120=75mph)
    property real speedLimit: 56

    property bool isTarget: false
    property string segmentName: "Wall"
    property string segmentType: "Thing"

    //----------------------------------------------------------------------------------------------------------------------------------//

    Component.onCompleted: {
        for (var i=0; i<segmentSections.count; i++){
            SectionFunctions.buildSectionData( segmentSections.get(i) );
        }
        totalLength = getSegmentLength();
        totalTime = getTravelTime( totalLength );
        calculatePathBounds();
        var _bulkHeading = Math.PI - Math.atan2((pathCoord(totalLength).x-pathCoord(0).x), (pathCoord(totalLength).y-pathCoord(0).y));
        if( _bulkHeading < 0 ) _bulkHeading += 2*Math.PI;
        bulkHeading = 180*_bulkHeading/Math.PI;
    }

    //----------------------------------------------------------------------------------------------------------------------------------//

    // Get the time, in seconds, it takes to travel the passed-in distance, in meters, on this
    // segment
    function getTravelTime( dist ){

        // Mulitply by 1000 to get meters per hour, then by 3600 to get seconds
        return (dist / (speedLimit *  1000)) * 3600;
    }

    // returns the length of the segment
    function getSegmentLength(){
        if (segmentSections.count < 1) return 0; //if no sections defined
        var evalLength = 0;
        var currentSection
        for (var i=0; i<segmentSections.count; i++){
            currentSection = segmentSections.get(i);
            evalLength += currentSection.length;
        }
        return evalLength;
    }

    // function that returns the x/y coordinates, in map space, of the segment path given a length position
    function pathCoord( lengthPosition ){
        // This function returns the X,Y coordinates of the segment path as a function of path distance (not absolute distance) travelled from the starting point
        var currentSection
        var sectionLength
        var completedLength = 0;

        if(lengthPosition < 0){
//            console.debug("length was negative! " + lengthPosition);
            lengthPosition = 0;
        }

        for (var i=0; i < segmentSections.count; i++){
            currentSection = segmentSections.get(i);
            sectionLength = currentSection.length;
            if(lengthPosition - completedLength <= sectionLength + .001){ //target lengthPosition is in the currentSection (a little allowance)
                return SectionFunctions.getSectionCoord( currentSection, lengthPosition - completedLength );
            }
            completedLength += sectionLength;
        }
        if(totalLength && lengthPosition){
            console.debug("length was out of segment bounds! " + lengthPosition + " , " + totalLength);
        }
    }

    // This function returns the heading, in radians, of the segment path as a function of path distance (not absolute distance) travelled from the starting point, assuming polarity is start -> end
    function pathHeading ( lengthPosition ){
        var currentSection
        var sectionLength
        var evalLength = lengthPosition;
        var completedLength = 0;

        if(lengthPosition < 0){
//            console.debug("length was negative! " + lengthPosition);
            lengthPosition = 0;
        }

        for (var i=0; i<segmentSections.count; i++){
            currentSection = segmentSections.get(i);
            sectionLength = currentSection.length;
            if(lengthPosition - completedLength <= sectionLength  + .001){ //target lengthPosition is in the currentSection
                return SectionFunctions.getSectionHeading( currentSection, lengthPosition - completedLength );
            }
            //evalLength -= sectionLength;
            completedLength += sectionLength;
        }
        if(totalLength && lengthPosition){
            console.debug("length was out of segment bounds! " + lengthPosition + " , " + totalLength);
        }
    }
    //This function returns two points defining the minimum and maximum x,y coordinates of the segment's bounding box
    function calculatePathBounds(){
        var result = new Object();
        var _minBoundPoint = Qt.point(0,0);
        var _maxBoundPoint = Qt.point(0,0);
        var currentSection
        var testBounds

        for (var i=0; i<segmentSections.count; i++){
            currentSection = segmentSections.get(i);
            testBounds = SectionFunctions.getPathBounds( currentSection );
            if( i==0 ){
                _minBoundPoint = testBounds.minBoundPoint;
                _maxBoundPoint = testBounds.maxBoundPoint;
            }
            else{
                if (testBounds.minBoundPoint.x < _minBoundPoint.x) _minBoundPoint.x = testBounds.minBoundPoint.x;
                if (testBounds.minBoundPoint.y < _minBoundPoint.y) _minBoundPoint.y = testBounds.minBoundPoint.y;
                if (testBounds.maxBoundPoint.x > _maxBoundPoint.x) _maxBoundPoint.x = testBounds.maxBoundPoint.x;
                if (testBounds.maxBoundPoint.y > _maxBoundPoint.y) _maxBoundPoint.y = testBounds.maxBoundPoint.y;
            }
        }
        root.minBoundPoint = _minBoundPoint;
        root.maxBoundPoint = _maxBoundPoint;
    }

    function getPathBounds( startLength, endLength ){
        var result = new Object();
        var _minBoundPoint = Qt.point(0,0);
        var _maxBoundPoint = Qt.point(0,0);
        var currentSection
        var testBounds
        var iStart = 0;
        var completedLength = 0;
        var startSecPos =0;
        var endSecPos = 0;

        for (var i=0; i<segmentSections.count; i++){
            currentSection = segmentSections.get( i );
            if ( completedLength + currentSection.length < startLength ){ //start is beyond currentSection
                iStart = i+1;
            }
            else{
                if( i == iStart){ //on start segment
                    startSecPos = startLength - completedLength;
                }
                else startSecPos = 0;

                if( completedLength + currentSection.length > endLength){ // on end section
                    endSecPos = endLength - completedLength;
                }
                else endSecPos = currentSection.length;

                testBounds = SectionFunctions.getPathBounds( currentSection, startSecPos, endSecPos );
                if( i == iStart ){
                    _minBoundPoint = testBounds.minBoundPoint;
                    _maxBoundPoint = testBounds.maxBoundPoint;
                }
                else{
                    if (testBounds.minBoundPoint.x < _minBoundPoint.x) _minBoundPoint.x = testBounds.minBoundPoint.x;
                    if (testBounds.minBoundPoint.y < _minBoundPoint.y) _minBoundPoint.y = testBounds.minBoundPoint.y;
                    if (testBounds.maxBoundPoint.x > _maxBoundPoint.x) _maxBoundPoint.x = testBounds.maxBoundPoint.x;
                    if (testBounds.maxBoundPoint.y > _maxBoundPoint.y) _maxBoundPoint.y = testBounds.maxBoundPoint.y;
                }
            }
            completedLength += currentSection.length;
        }
        result.minBoundPoint = _minBoundPoint;
        result.maxBoundPoint = _maxBoundPoint;
        return result;
    }

    function pathSpeedLimit ( lengthPosition ){
        // This function returns the speed limit of the segment path as a function of path distance (not absolute distance) travelled from the starting point
        return speedLimit;
    }

    function timeToComplete ( startPosition, endPosition, dLength ){
        // This function returns the time it will take to drive between two arbitrary points of the segment
        // Integrate length/speedLimit • dLength
        return ( endPosition - startPosition ) / pathSpeedLimit(0);
    }

    // This function evaluates the relationship between an arbitrary  x,y evalPoint and the segment.
    function evaluatePointToSegment ( evalPoint ){
        /*  It returns an object containing the following:
            errorVector (heading and magnitude) representing the minimum distance between the evalPoint and segment path
            segmentPosition the length position of the segment that intersects the minDistanceVector
        */
        var result = new Object();
        var segmentPosition = 0;
        var evalPosition = 0;
        var testSection = segmentSections.get(0);
        var testError = SectionFunctions.evaluatePointToSection( testSection, evalPoint );
        var errorVector = new Object();

        for(var i=0; i<segmentSections.count; i++){
            testSection = segmentSections.get(i);
            testError = SectionFunctions.evaluatePointToSection( testSection, evalPoint );
            if(testError.errorVector.magnitude < errorVector.magnitude || i === 0){
                errorVector = testError.errorVector;
                segmentPosition = evalPosition + testError.sectionPosition;
            }
            evalPosition += testSection.length;
        }

        result.errorVector = errorVector;
        result.segmentPosition = segmentPosition;

        return result;
    }

    function evaluateVectorToSegment ( evalPosition , evalHeading ){
        var result = new Object;
        var segmentPosition = 0;
        var testSection = segmentSections.get(0);
        var testResult = SectionFunctions.evaluateVectorToSection( testSection, evalPosition , evalHeading );
        var displacementMag;
        var headingError;
        var evalLengthPosition = 0;

        for(var i=0; i<segmentSections.count; i++){
            testSection = segmentSections.get(i);
            testResult = SectionFunctions.evaluateVectorToSection( testSection, evalPosition , evalHeading );
            if( testResult.displacementMag ){
                if( !displacementMag || testResult.displacementMag < displacementMag ){
                    displacementMag = testResult.displacementMag;
                    segmentPosition = evalLengthPosition + testResult.sectionPosition;
                }
            }
            evalLengthPosition += testSection.length;
        }

        result.displacementMag = displacementMag;
        result.segmentPosition = segmentPosition;

        return result;
    }

    //gets the section index lengthPosition associated with a segment lengthPosition
    function getSectionData ( segmentLengthPosition ){
        var result = new Object();
        result.sectionPosition = SectionFunctions.getSectionLengthPosition( segmentLengthPosition );
        result.sectionIndex = SectionFunctions.getSectionIndex( segmentLengthPosition );

        return result;
    }
}
