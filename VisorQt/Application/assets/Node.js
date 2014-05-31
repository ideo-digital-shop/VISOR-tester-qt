var nodes = {}
var count = 0;

// Used to store which segments store to which other segments
var startSegmentConnections = {};
var endSegmentConnections = {};

function getIndexOfSegmentConnection( segmentIndex, useStart, connectingSegmentIndex ){

    var testArray = useStart ? startSegmentConnections[segmentIndex] : endSegmentConnections[segmentIndex];
    if( !testArray )
        return -1;

    for( var i = 0; i < testArray.length; ++i )
    {
        if( testArray[i].segmentIndex === connectingSegmentIndex )
            return i;
    }

    return -1;
}

function addSegmentConnection( segmentIndex, connectsAtStart, connectingIndex, connectingIsStart ){

    // If this connection already exists then bail
    if( getIndexOfSegmentConnection(segmentIndex, connectsAtStart, connectingIndex) !== -1 )
        return;

    var newEntry = {
        segmentIndex: connectingIndex,
        isStart: connectingIsStart
    };

    if( connectsAtStart ){

        if( !startSegmentConnections[segmentIndex] )
            startSegmentConnections[segmentIndex] = [];

        // Don't insert duplicates
        //if( startSegmentConnections[segmentIndex].indexOf(connectingIndex) === -1 )
            startSegmentConnections[segmentIndex].push( newEntry );
    }
    else {

        if( !endSegmentConnections[segmentIndex] )
            endSegmentConnections[segmentIndex] = [];

        //if( endSegmentConnections[segmentIndex].indexOf(connectingIndex) === -1 )
            endSegmentConnections[segmentIndex].push( newEntry );
    }
}

function getConnectionsForSegment( segmentIndex, getForStart ){

    if( getForStart )
        return startSegmentConnections[segmentIndex];
    else
        return endSegmentConnections[segmentIndex];
}

function clear(){
    nodes = {};
    count = 0;
}

function append( newNode ){
    nodes[count] = newNode;
    count++;
}

function removeByIndex( nodeIndex ){
    nodes[nodeIndex] = null;
    --count;
}

function get (nodeIndex ){
    return nodes[nodeIndex];
}

function setConnections ( nodeIndex, connections ){
    nodes[ nodeIndex ].connectionIndices = connections;
}

function addConnectionToNode( node, nodeIndexToAdd ){

    // Copy the existing connections
    var newConnections = new Array();
    for( var connIndex = 0; connIndex < node.connectionIndices.length; ++connIndex )
        newConnections.push( node.connectionIndices[connIndex] );

    // Add the new connections and return it to persited by ListModel.setProperty
    newConnections.push( nodeIndexToAdd );
    return newConnections;
}

function removeConnectionFromNode( node, nodeIndexToRemove ){

    // Copy the existing connections, but don't copy the connection between the two nodes
    var newConnections = new Array();
    for( var connIndex = 0; connIndex < node.connectionIndices.length; ++connIndex ){

        if( node.connectionIndices[connIndex] !== nodeIndexToRemove )
            newConnections.push( node.connectionIndices[connIndex] );
    }

    return newConnections;
}
