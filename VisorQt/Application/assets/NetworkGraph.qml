import QtQuick 2.0
import "Node.js" as Nodes

/*
  Network graph defines all the segments and nodes for a given map
  */
Item {
    id: root
    // This is the object container for all segments in the graph
    property variant segments //currently implemented as a QtObject containing Segment.qml children

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
        generateNodes();
        buildSegmentData();
    }

    //----------------------------------------------------------------------------------------------------------------------------------//

    // this function populates segment data
    function buildSegmentData(){
        for (var i=0; i<segments.children.length; i++){
            segments.children[i].index = i;
//            segments.children[i].owningRoad = owningMap.getRoad( i );
        }
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

            /*
            var str = "Start of segment " + curNode.owningSegmentIndex + " connects to ";
            for( var i = 0; i < startConnections.length; ++i)
                str += startConnections[i] + ",";
            console.log( str );
            */

            //curNode.startConnections = startConnections;
            //curNode.endConnections = endConnections;
        }

        /*
        // For debugging segment connections
        console.log( "Logging from generateNodes" );
        for( var segmentIndex = 0; segmentIndex < nSegments; ++segmentIndex ){

            var segment = getSegment( segmentIndex );

            var str = "The start of segment " + segmentIndex + " connects to ";
            var list = getSegmentsThatConnectTo( segmentIndex, true );
            for( var i = 0; i < list.length; ++i )
                str += list[i].segmentIndex + "(" + (list[i].isStart ? "start" : "end") + "), "
            console.log( str );

            str = "The end of segment " + segmentIndex + " connects to ";
            list = getSegmentsThatConnectTo( segmentIndex, false );
            for( var i = 0; i < list.length; ++i )
                str += list[i].segmentIndex + "(" + (list[i].isStart ? "start" : "end") + "), "
            console.log( str );
        }
        */

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

    // Test if a value is in the list model
    function isValueInListModel( listModel, value ){

        for( var i = 0; i < listModel.count; ++i ){

            if( listModel.get(i).value === value )
                return true;
        }

        return false;
    }

    // Add a value if it's not already in the list
    function addValueIfNonExistant( listModel, value, isStart ){

        if( !isValueInListModel( listModel, value ) )
            listModel.append( { value: value } );
    }

    // Make a connection between two nodes if the meet the proper criteria. Returns true if the two
    // nodes were connected.
    function attemptToConnectNodes( node1, node2 ){

        // The maximum distance, squared, that nodes must be near each other to be considered
        // connected
        var ConnectionMaxDistSq = 1 * 1;

        // If these nodes are too far apart then ignore them
        if( getDistSq( node1.position, node2.position) > ConnectionMaxDistSq )
            return false;

        // Store that these segments connect
        Nodes.addSegmentConnection( node1.owningSegmentIndex, node1.lengthPosition === 0, node2.owningSegmentIndex, node2.lengthPosition === 0 );
        Nodes.addSegmentConnection( node2.owningSegmentIndex, node2.lengthPosition === 0, node1.owningSegmentIndex, node1.lengthPosition === 0 );

        // If the nodes don't continue in the same direction (i.e. end nodes can only connect to
        // start nodes of other segments)
        if( node1.isStartNode === node2.isStartNode )
            return false;

        // Highway segments have special cases since you should never be able to make a
        // hard turn (>90deg) on a highway
        if( node1.owningSegment.isHighway && node2.owningSegment.isHighway ){

            // If these two nodes are on highway on/off ramps then don't connect them.
            // There's never a case when you'd want on ramps to lead to each other and helps
            // prevent highway u-turns
            var bothAreHwyRamps = node1.owningSegment.isOneWay && node2.owningSegment.isOneWay;

            //console.log( "Connecting highway (node " + node1.nodeIndex + ") " +  (node1.isOnSegmentForward() ? "fwd" : "rvs") + " " + (node1.isStartNode ? "start" : "end") + " of segment " + node1.owningSegmentIndex + " and " + (subNode.isOnSegmentForward() ? "fwd" : "rvs") + " " + (subNode.isStartNode ? "start" : "end") + " of " + subNode.owningSegmentIndex + ", one way: " +  node1.owningSegment.isOneWay + "," + subNode.owningSegment.isOneWay + ": " + (bothAreHwyRamps ? "skipped" : "connected") );

            if( bothAreHwyRamps )
                return false;

            // If this is a highway straight-away connecting to a ramp
            if( (node1.owningSegment.isOneWay || node2.owningSegment.isOneWay)
                && (node1.owningSegment.isOneWay !== node2.owningSegment.isOneWay)){

                // If their heading is too different then don't connect them
                if( angleDiff( node1.getHeading(), node2.getHeading()) > (Math.PI / 2) ){
                    //console.log("skipped, cur heading: " + node1.getHeading() + ", sub heading: " + node2.getHeading());
                    return false;
                }
            }
        }

        /*
        // Debugging code, shows which nodes within a range connect to others
        var testMin = 32;
        var testMax = 34;
        if( (node1.owningSegmentIndex >= testMin && node1.owningSegmentIndex <= testMax)
            || (node2.owningSegmentIndex >= testMin && node2.owningSegmentIndex <= testMax) )
            console.log( "Connecting nodes (node " + node1.nodeIndex + ") " +  (node1.isOnSegmentForward() ? "fwd" : "rvs") + " " + (node1.isStartNode ? "start" : "end") + " of segment " + node1.owningSegmentIndex + " and " + (node2.isOnSegmentForward() ? "fwd" : "rvs") + " " + (node2.isStartNode ? "start" : "end") + " of " + node2.owningSegmentIndex + ", one way: " +  node1.owningSegment.isOneWay + "," + node2.owningSegment.isOneWay + ": " );
        */


        // We only want to connect ends of segments to starts of others
        if( node1.isStartNode )
            connectNodeOneWay( node2.nodeIndex, node1.nodeIndex );
        else
            connectNodeOneWay( node1.nodeIndex, node2.nodeIndex );

        return true;
    }

    // Create a connection between a node toward another node
    function connectNodeOneWay( startNodeIndex, endNodeIndex ){

        Nodes.setConnections( startNodeIndex, Nodes.addConnectionToNode( Nodes.get( startNodeIndex ), endNodeIndex ) );
    }

    // Create a connection between two nodes
    function connectNodes( node1Index, node2Index ){

        Nodes.setConnections( node1Index, Nodes.addConnectionToNode( Nodes.get( node1Index ), node2Index ) );
        Nodes.setConnections( node2Index, Nodes.addConnectionToNode( Nodes.get( node2Index ), node1Index ) );
    }

    // Remove a connection between two nodes
    function disconnectNodes( node1Index, node2Index ){

        Nodes.setConnections( node1Index, Nodes.removeConnectionFromNode( Nodes.get( node1Index ), node2Index ) );
        Nodes.setConnections( node2Index, Nodes.removeConnectionFromNode( Nodes.get( node2Index ), node1Index ) );
    }

    // Find the "best" route between be locations on our network.
    function findBestRoute(startNetworkPosition, startHeading, endNetworkPosition){

        console.debug("Attempting for find path between");
        console.debug("Start segment index: " + startNetworkPosition.segmentIndex + " at lengthPosition " + startNetworkPosition.lengthPosition );
        console.debug("End segment index: " + endNetworkPosition.segmentIndex + " at lengthPosition " + endNetworkPosition.lengthPosition );

        // True indicates we're heading forward on the start segment, false for reverse.
        var isForwardOnStartSegment = isForwardOnSegment( startHeading, startNetworkPosition );
        //console.log( "Initial heading (" + startHeading + ") is " + (isForwardOnStartSegment ? "forward" : "reverse"));

        // Special case the start and end being on the same segment
        var startsAndEndsOnSameSegment = startNetworkPosition.segmentIndex === endNetworkPosition.segmentIndex;
        if( startsAndEndsOnSameSegment ){

            // If the user is there already then do nothing
            if( startNetworkPosition.lengthPosition === endNetworkPosition.lengthPosition ){

                console.debug( "Trying to find path, but start and end are equal" )
                return null;
            }

            // If the end point is in front of the user then we can bail out quickly
            var targetIsInFront = (isForwardOnStartSegment && startNetworkPosition.lengthPosition < endNetworkPosition.lengthPosition)
                               || (!isForwardOnStartSegment && startNetworkPosition.lengthPosition > endNetworkPosition.lengthPosition);

            if( targetIsInFront )
                return pathFinder.makeQuickForwardRoute( startNetworkPosition, endNetworkPosition, root, owningMap )
        }

        // Find the pairs of nodes that contain for the start and end segments. We're doing this so
        // we can split the connections between those nodes and insert a temporary node representing
        // our start and end positions. For the start position, we only need to split the connection
        // in the direction of travel, for example, so the user doesn't have to flip a U-turn at the
        // start. For the end position, we must split both the connection between the start and end
        // nodes (forward) and end and start nodes (reverse).
        var startSegmentStartNode = null;
        var startSegmentEndNode = null;
        var endSegmentForwardStartNode = null;
        var endSegmentForwardEndNode = null;
        var endSegmentReverseStartNode = null;
        var endSegmentReverseEndNode = null;
        var startSegment = getSegment(startNetworkPosition.segmentIndex);
        var endSegment = getSegment(endNetworkPosition.segmentIndex);
        for( var nodeIndex = 0; nodeIndex < Nodes.count; ++nodeIndex ){

            var curNode = Nodes.get(nodeIndex);

            // Determine if this node represents a connection heading in the same direction as
            // the passed-in start heading (i.e. Going forward on the segment's forward
            // connection)
            var isNodeForwardDir = (curNode.isStartNode && curNode.lengthPosition === 0)
                                || (!curNode.isStartNode && curNode.lengthPosition === curNode.owningSegment.totalLength);

            // If this node is on the start segment
            if( curNode.owningSegment === startSegment ){

                // Only use the node if it's going in the direction we're heading
                var isNodeInProperDirection = isNodeForwardDir === isForwardOnStartSegment;

                if( isNodeInProperDirection ){

                    if( curNode.isStartNode )
                        startSegmentStartNode = curNode;
                    else
                        startSegmentEndNode = curNode;
                }
            }

            // If this node is on the end segment
            if( curNode.owningSegment === endSegment ){

                if( isNodeForwardDir ) {

                    if( curNode.isStartNode )
                        endSegmentForwardStartNode = curNode;
                    else
                        endSegmentForwardEndNode = curNode;
                }
                else {

                    if( curNode.isStartNode )
                        endSegmentReverseStartNode = curNode;
                    else
                        endSegmentReverseEndNode = curNode;
                }
            }
        }

        if( startSegment.forwardEnabled && (startSegmentStartNode === null || startSegmentEndNode === null) )
            console.debug( "Failed to find nodes that contain start segment")

        if( endSegment.forwardEnabled && (endSegmentForwardStartNode === null || endSegmentForwardEndNode === null) )
            console.debug( "Failed to find nodes that contain end segment in forward direction")

        if( endSegment.reverseEnabled && (endSegmentReverseStartNode === null || endSegmentReverseEndNode === null) )
            console.debug( "Failed to find nodes that contain end segment in reverse direction")

        // If needed, split up the connection to insert our start and end position in the node graph
        var startNodeIsNew = false;
        var startNode;
        if( startNetworkPosition.lengthPosition === 0.0 )
            startNode = startSegmentStartNode;
        else if( startNetworkPosition.lengthPosition === startSegment.getSegmentLength() )
            startNode = startSegmentEndNode;
        else
        {
            // Indicate that we created a node for the start position by splitting up two existing
            // nodes
            startNodeIsNew = true;
            startNode = createNode( startNetworkPosition.segmentIndex, startNetworkPosition.lengthPosition, true );

            disconnectNodes( startSegmentStartNode.nodeIndex, startSegmentEndNode.nodeIndex );

            connectNodeOneWay( startNode.nodeIndex, startSegmentEndNode.nodeIndex );
        }

        var endNodeIsNew = false;
        var endNode;
        if( startNetworkPosition.lengthPosition === 0.0 )
            endNode = endSegmentForwardStartNode;
        else if( endNetworkPosition.lengthPosition === endSegment.getSegmentLength() )
            endNode = endSegmentForwardEndNode;
        else
        {
            // Indicate that we created a node for the end position by splitting up two existing
            // nodes
            endNodeIsNew = true;

            endNode = createNode( endNetworkPosition.segmentIndex, endNetworkPosition.lengthPosition, false );

            if( endSegmentForwardStartNode !== null ) {

                disconnectNodes( endSegmentForwardStartNode.nodeIndex, endSegmentForwardEndNode.nodeIndex );

                connectNodeOneWay( endSegmentForwardStartNode.nodeIndex, endNode.nodeIndex );
            }

            if( endSegmentReverseStartNode !== null ) {

                disconnectNodes( endSegmentReverseStartNode.nodeIndex, endSegmentReverseEndNode.nodeIndex );

                connectNodeOneWay( endSegmentReverseStartNode.nodeIndex, endNode.nodeIndex );
            }
        }

        //for( var curNodeIndex = 0; curNodeIndex < Nodes.count; ++curNodeIndex )
        //    console.debug("Node " + curNodeIndex + " on segment " + Nodes.nodes[curNodeIndex].owningSegmentIndex + ", connected to " + Nodes.nodes[curNodeIndex].connectionIndices)

        // Path find from start to end
        var routeNodeIndexList = pathFinder.findPath( startNode, endNode, Nodes );

        var foundRoute = null;
        if( routeNodeIndexList.count === 0 )
            console.debug("Failed to find path");
        // Convert the node path to directions
        else{

            // If we allow U-turns and the user is not on the highway, then attempt a U-turn to
            // start
            var startingNode = Nodes.get( routeNodeIndexList.get(0).nodeIndex );
            var didApplyUTurn = false;
            if( allowNonHighwayUturns && !startingNode.owningSegment.isHighway )
                didApplyUTurn = applyUTurnIfPossible( routeNodeIndexList, isForwardOnStartSegment );

            foundRoute = pathFinder.nodePathToRoute( routeNodeIndexList, Nodes, root, owningMap, startNetworkPosition, endNetworkPosition, didApplyUTurn );

            //console.debug("Found path node indices:" + routeNodeIndexList);
        }

        // If we created nodes for the start or end, delete them. Make sure to delete the end node,
        // if needed, first because it was added to the nodes ListModel last.
        if( endNodeIsNew ){

            // Reconnect the end segment forward path direction
            if( endSegmentForwardStartNode !== null ) {

                disconnectNodes( endSegmentForwardStartNode.nodeIndex, endNode.nodeIndex );
                connectNodeOneWay( endSegmentForwardStartNode.nodeIndex, endSegmentForwardEndNode.nodeIndex );
            }

            // Reconnect the end segment reverse path direction
            if( endSegmentReverseStartNode !== null ) {

                disconnectNodes( endSegmentReverseStartNode.nodeIndex, endNode.nodeIndex );
                connectNodeOneWay( endSegmentReverseStartNode.nodeIndex, endSegmentReverseEndNode.nodeIndex );
            }

            Nodes.removeByIndex( endNode.nodeIndex );
        }

        if( startNodeIsNew ){

            disconnectNodes( startNode.nodeIndex, startSegmentEndNode.nodeIndex );

            connectNodeOneWay( startSegmentStartNode.nodeIndex, startSegmentEndNode.nodeIndex );

            Nodes.removeByIndex( startNode.nodeIndex );
        }

        return foundRoute;
    }

    // If the user is not on a highway, then alter the results of pathFinder.findPath to u-turn
    // immdediately if that makes the route shorter
    function applyUTurnIfPossible( routeNodeIndexList, isForwardOnStartSegment ){

        var startingSegmentIndex = Nodes.get( routeNodeIndexList.get(0).nodeIndex ).owningSegmentIndex;

        for( var routeNodeIndex = 1; routeNodeIndex < routeNodeIndexList.count; ++routeNodeIndex ){

            var curNode = Nodes.get( routeNodeIndexList.get(routeNodeIndex).nodeIndex );

            // If we step back through our starting segment
            if( curNode.owningSegmentIndex === startingSegmentIndex
                && curNode.isOnSegmentForward() !== isForwardOnStartSegment){

                //console.log( "U-turn applied, skipping steps 1 to " + routeNodeIndex + ", starts out forward:" + isForwardOnStartSegment + ", cur node forward:" + curNode.isOnSegmentForward());

                // Remove all indices between the start and this node
                for( var i = routeNodeIndex; i > 0; --i )
                    routeNodeIndexList.remove( i );

                // We U-turned so return true
                return true;
            }
        }

        // We didn't U-turn
        return false;
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

    // Returns true if the user is heading forward (start -> end) on the passed-in segment or false
    // if their going reverse on the segment (end -> start). heading should be in radians. If the
    // network position is on a segment that is one-way, this function will return that one-way
    // direction regardless of the input header
    function isForwardOnSegment( heading, networkPosition ){

        var segment = getSegment( networkPosition.segmentIndex );

        // If the user can only go from end to start on this segment
        if( !segment.forwardEnabled )
            return false;
        // Or if the user can only go from start to end
        else if( !segment.reverseEnabled )
            return true;

        // Get the forward heading at our position on the segment
        var segmentHeading = segment.pathHeading( networkPosition.lengthPosition );

        // If the difference is less than 90deg then we can say the user is heading in the same
        // direction as forward on the segment
        return angleDiff( heading, segmentHeading ) < (Math.PI / 2);
    }

    // Create a node object
    function createNode( owningSegmentIndex, lengthPos, isStartNode ){

        var owningSegment = getSegment(owningSegmentIndex);

        // Get the map position of this new node. Subtract a slight delta because pathCoord() gets
        // angry if pass in the very end of the segment
        var testLength = lengthPos;
        if( testLength === owningSegment.totalLength )
            testLength -= 0.0001;

        var pos = owningSegment.pathCoord( testLength );

        var newNode = {
                    nodeIndex: Nodes.count,
                    position: pos,
                    lengthPosition: lengthPos,
                    owningSegment: owningSegment,
                    owningSegmentIndex: owningSegmentIndex,
                    g: 0, // For A*, the cost of traveling from this node to the end node
                    h: 0, // For A*, the result of the heuristic function for this node
                    f: 0, // For A*, simply the sum of g and h
                    parentNodeIndex: -1, // When path finding, this indicates the node that leads to this node along a path
                    connectionIndices: [], // The indices of other out-bound nodes this node connects to, properly takes one-ways into account
                    isStartNode: isStartNode, // Indicates if this node is at the beginning or end of a segment

                    // A pair of nodes is created for each direction driveable on a segment. For
                    // example, a normal two-way road will have a start and end node for the forward
                    // direction and a start and end node in the reverse direction. This makes it
                    // possible to handle one-way roads and prevent u-turns.
                    isOnSegmentForward: function(){ return (this.isStartNode && this.lengthPosition === 0)
                                                    || (this.isStartNode === false && this.lengthPosition === this.owningSegment.totalLength); },

                    // Get the heading of travel at this node. Takes forward/reverse into account
                    getHeading:function(){

                        var testLength = this.lengthPosition;
                        if( testLength === this.owningSegment.totalLength )
                            testLength -= 0.0001;

                        var segmentHeading = this.owningSegment.pathHeading( testLength );

                        // If this node is going in reverse on this segment then flip the heading
                        if( !this.isOnSegmentForward() )
                            segmentHeading = (segmentHeading + Math.PI) % (2.0 * Math.PI);

                        return segmentHeading;
                    }
                  };

        Nodes.append( newNode );

        return newNode;
    }
    //returns the x,y coordinates of a network position
    function getNetworkCoord( networkPosition ){
        return getSegment( networkPosition.segmentIndex ).pathCoord( networkPosition.lengthPosition );
    }

    // This function evaluates the relationship between an arbitrary  x,y evalPoint and the network.
    function evaluatePointToGraph( evalPoint ){
        var result = new Object();
        var networkPositionComponent = Qt.createComponent("NetworkPosition.qml");
        var networkPosition = networkPositionComponent.createObject();
        var evalPosition = 0;
        var testSegment = getSegment(0);
        var testError = new Object();
        var errorVector = new Object();

        for(var i=0; i < nSegments; i++){
            testSegment = getSegment(i);
            testError = testSegment.evaluatePointToSegment ( evalPoint );
            if(testError.errorVector.magnitude < errorVector.magnitude || i==0){
                errorVector = testError.errorVector;
                networkPosition.segmentIndex = i;
                networkPosition.lengthPosition = testError.segmentPosition;
            }
        }

        result.errorVector = errorVector;
        result.networkPosition = networkPosition;

        return result;

        // iterates through segment evaluation
        // returns a results object containing:
        //    • A NetworkPosition representing the place in the network closest to the point
        //    • A vector representing the position error
    }
}
