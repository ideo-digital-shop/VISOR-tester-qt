import QtQuick 2.0
import "Node.js" as Nodes

/*
  Network graph defines all the segments and nodes for a given map
  */
Item {
    id: root
    // This is the object container for all segments in the graph
    property variant segments //currently implemented as a QtObject containing Segment.qml children

    property point minBoundPoint
    property point maxBoundPoint
    // A list of PathingNode objects used for path finding, generated from our segment data
    //property variant nodes: ListModel{}

    // Indicates if we've generated nodes yet
    property bool nodesHaveBeenGenerated: false

    // The map to which this graph belongs
    property variant owningMap

    property bool allowNonHighwayUturns: false

    //number if segments in the network
    property int nSegments: {
        return segments.children.length;
    }
//    property variant pathFinder:PathFinder{}


    //----------------------------------------------------------------------------------------------------------------------------------//

    Component.onCompleted: {
        buildSegmentData();
    }

    //----------------------------------------------------------------------------------------------------------------------------------//

    // this function populates segment data
    function buildSegmentData(){
        var maxBoundPoint = Qt.point(0,0);
        var minBoundPoint = Qt.point(0,0);
        for (var i=0; i<segments.children.length; i++){
            var curSeg = segments.children[i];
            curSeg.index = i;
            if( curSeg.maxBoundPoint.x > maxBoundPoint.x ) maxBoundPoint.x = curSeg.maxBoundPoint.x;
            if( curSeg.maxBoundPoint.y > maxBoundPoint.y ) maxBoundPoint.y = curSeg.maxBoundPoint.y;
        }
        root.maxBoundPoint = maxBoundPoint;
        root.minBoundPoint = minBoundPoint;
    }

    // this function returns the segment object of a given index
    // in the map and route data, segments are bound to indeces rather than being stored directly to facilitate noam synchronization
    function getSegment ( segmentIndex ){
        if( typeof segments.children[segmentIndex] == typeof undefined){
            console.debug(version + " networkGraph: segmentInex '" + segmentIndex + "' is undefined");
            return undefined;
        }
        return segments.children[segmentIndex];
    }

    // method to automatically create a node map by iterating through the segments and checking for intersections
    function generateNodes(){
        /* Goes through the list of segments and creates a node for both the start and end of each
        segment. Then goes through those nodes and compares every node to every other node and
        creates connections for nodes that are very close together. */

        Nodes.clear();

        // Start by building the list of nodes simply based on segment start and end points
        for( var segmentIndex = 0; segmentIndex < nSegments; ++segmentIndex ){

            var curSegment = getSegment( segmentIndex );

            // Add a pair of nodes for each direction that can be travelled on this road
            if( curSegment.forwardEnabled ) {
                var newForwardStartNode = createNode( segmentIndex, 0, true );
                var newForwardEndNode = createNode( segmentIndex, curSegment.totalLength, false );
                connectNodeOneWay( newForwardStartNode.nodeIndex, newForwardEndNode.nodeIndex );
            }
            if( curSegment.reverseEnabled ) {
                var newReverseStartNode = createNode( segmentIndex, curSegment.totalLength, true );
                var newReverseEndNode = createNode( segmentIndex, 0, false );
                connectNodeOneWay( newReverseStartNode.nodeIndex, newReverseEndNode.nodeIndex );
            }

            //console.log( "newForwardStartNode.x: " + newForwardStartNode.position.x + ", node 1 X: " + nodes.get(0).position.x );
        }

        // Now that we have all of our nodes let's make connections
        for( var curNodeIndex = 0; curNodeIndex < Nodes.count; ++curNodeIndex ){

            var curNode = Nodes.get( curNodeIndex );

            if( curNode.nodeIndex !== curNodeIndex )
                console.debug("Node ID doesn't match its index.")

            // Go through the rest of the nodes. No need to start at index 0 since the outer loop
            // makes sure when only compare every node pair one time
            for( var subNodeIndex = curNodeIndex + 1; subNodeIndex < Nodes.count; ++subNodeIndex ){

                var subNode = Nodes.get( subNodeIndex );

                // We connect nodes on the same segment in the code above so don't allow it now
                if( curNode.owningSegmentIndex === subNode.owningSegmentIndex )
                    continue;

                attemptToConnectNodes( curNode, subNode );
            }
        }


        nodesHaveBeenGenerated = true;
    }

    function getSegmentsThatConnectTo( segmentIndex, useStart ){

        return Nodes.getConnectionsForSegment( segmentIndex, useStart );
    }

    // Helper method to get the squared distance between to points. Squared to avoid the call to
    // Math.sqrt which can be slow.
    function getDistSq( pt1, pt2 ){
        return (pt1.x - pt2.x) * (pt1.x - pt2.x) + (pt1.y - pt2.y) * (pt1.y - pt2.y);
    }

    // Get the positive, minimal difference between to radian angles within [0, Pi]. For example in degrees,
    // will return 10 for the angles 350 and 340, the angle 25 for the angles 5 and -20, and the
    // angle 25 for the angles 5 and 340.
    function angleDiff( angle1, angle2 ){

        var twoPi = Math.PI * 2;

        // Get both angles into [0,2pi]
        angle1 = angle1 % twoPi;
        if( angle1 < 0 )
            angle1 += twoPi;

        angle2 = angle2 % twoPi;
        if( angle2 < 0 )
            angle2 += twoPi;

        return Math.min(twoPi - Math.abs(angle1 - angle2), Math.abs(angle1 - angle2));
    }

   //returns the x,y coordinates of a network position
    function getNetworkCoord( networkPosition ){
        return getSegment( networkPosition.segmentIndex ).pathCoord( networkPosition.lengthPosition );
    }

    // This function evaluates the relationship between an arbitrary  x,y evalPoint and the network.
    function evaluatePointToGraph( evalPoint ){
        var result = new Object;
        var segmentEvalArray = [];
        var networkPositionComponent = Qt.createComponent("NetworkPosition.qml");
        var networkPosition = networkPositionComponent.createObject();
        var evalPosition = 0;
        var testSegment = getSegment(0);
        var testError = new Object;
        var errorVector = new Object;

        for(var i=0; i < nSegments; i++){
            testSegment = getSegment(i);
            testError = testSegment.evaluatePointToSegment ( evalPoint );            
            testError.cartPosition = testSegment.pathCoord( testError.segmentPosition );            
            segmentEvalArray.push( testError );            
            if(testError.errorVector.magnitude < errorVector.magnitude || i==0){
                errorVector.heading = testError.errorVector.heading;
                errorVector.magnitude = testError.errorVector.magnitude;
                networkPosition.segmentIndex = i;
                networkPosition.lengthPosition = testError.segmentPosition;
            }
        }

//        result.errorVector = errorVector;
//        result.networkPosition = networkPosition;
//        result.cartPosition = getNetworkCoord( networkPosition );
        result.segmentEvalArray = segmentEvalArray;

        return result;

        // iterates through segment evaluation
        // returns a results object containing:
        //    • A NetworkPosition representing the place in the network closest to the point
        //    • A vector representing the position error
    }

    function evaluateVectorToGraph( evalPosition , evalHeading ){
        var result = new Object;
        var segmentEvalArray = [];
        var networkPositionComponent = Qt.createComponent("NetworkPosition.qml");
        var networkPosition = networkPositionComponent.createObject();
        var testSegment = getSegment(0);
        var headingError; //if not pointing at target seg
        var displacementMag;
        var testResult = new Object;

        for(var i=0; i < nSegments; i++){
            testSegment = getSegment(i);
            testResult = testSegment.evaluateVectorToSegment ( evalPosition , evalHeading );
            segmentEvalArray.push( testResult );
            if( testResult.displacementMag){                
                if(!displacementMag || testResult.displacementMag < displacementMag ){
                    displacementMag = testResult.displacementMag;
                    testResult.cartPosition = testSegment.pathCoord( testResult.segmentPosition )
                    networkPosition.segmentIndex = i;
                    networkPosition.lengthPosition = testResult.segmentPosition;
                }
            }
        }

        result.displacementMag = displacementMag;
        if(displacementMag)result.networkPosition = networkPosition;
        if(displacementMag)result.cartPosition = getNetworkCoord( networkPosition );
        result.segmentEvalArray = segmentEvalArray;

        return result;

        // iterates through segment evaluation
        // returns a results object containing:
        //    • A NetworkPosition representing the place in the network closest to the point
        //    • A vector representing the position error
    }

    function evaluateMap( heroModel ){
        var heroPosition = heroModel.heroPositionMeters;
        var heroOrientation = heroModel.heroOrientation;
        var result = new Object;
        result.proximityEvaluation = evaluatePointToGraph( heroPosition );
        result.headingEvaluation = evaluateVectorToGraph( heroPosition , heroOrientation );        

        return result;
    }
}
