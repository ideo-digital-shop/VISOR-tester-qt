import QtQuick 2.0
import Lemma 1.0

Item {
    id: root
    property point heroPositionMeters: Qt.point(0,0)
    property real heroOrientation: ( bulkOrientation + orientationOffset ) % 360
    property real bulkOrientation: 0
    property real orientationOffset: rootStateModel.heroOrientationOffset.get()
    property real heroHeading: heroOrientation - 180

    function setPosition( posPoint ){
        heroPositionMeters.x = posPoint.x;
        heroPositionMeters.y = posPoint.y;
        if(rootStateModel.isEventController){
            var posObj = new Object;
            posObj.x = posPoint.x;
            posObj.y = posPoint.y;
            noamLemma.speak( "heroPosSynch" , posObj );
        }
    }
}
