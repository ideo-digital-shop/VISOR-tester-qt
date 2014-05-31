import QtQuick 2.0
//import Lemma 1.0
//import ProgenitorControls 1.0

QtObject {
    id: root
    // The network graph the route is bound to
    property variant networkGraph
    // The index of the segement the position represents
    property int segmentIndex: 0
    // The path length position on the specified segment
    property real lengthPosition: 0
}
