import QtQuick 2.0
import Lemma 1.0

Item {
    id: root
    property point heroPositionMeters: Qt.point(0,0)
    property real heroOrientation: 0

    NoamLemmaHears{
        topic: "heroOrientation"
        onNewEvent:{
            heroOrientation = value;            
        }
    }

    function setPosition( posPoint ){
        heroPositionMeters.x = posPoint.x;
        heroPositionMeters.y = posPoint.y;
    }
}
