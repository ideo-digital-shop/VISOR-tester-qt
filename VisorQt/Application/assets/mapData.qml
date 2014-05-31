import QtQuick 2.0
import Lemma 1.0
import "."
/*
  Network graph for the generic world map
  */
NetworkGraph {
    id: root
    segments: segmentsObject    

    Item{
        id: segmentsObject
        Segment{ // Far west loop, upper curve
            id: seg0
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 0; y1: 10; x2: 10; y2: 10}
//                ListElement{type: "arc"; x1: -1400; y1: 5800; x2: -1300; y2: 5700; angle: 90}
//                ListElement{type: "linear"; x1: -1300; y1: 5700; x2: -900; y2: 5700}
//                ListElement{type: "arc"; x1: -900; y1: 5700; x2: -800; y2: 5800; angle: 90}
//                ListElement{type: "linear"; x1: -800; y1: 5800; x2: -800; y2: 6100}
            }
        }
        Segment{ // Far west loop, straight through
            id: seg1
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 10; y1: 10; x2: 10; y2: 0}
            }
        }
//        Segment{ // Far west loop, lower curve
//            id: seg2
//            segmentSections: ListModel{
//                ListElement{type: "linear"; x1: -1400; y1: 6100; x2: -1400; y2: 6400}
//                ListElement{type: "arc"; x1: -1400; y1: 6400; x2: -1300; y2: 6500; angle: -90}
//                ListElement{type: "linear"; x1: -1300; y1: 6500; x2: -900; y2: 6500}
//                ListElement{type: "arc"; x1: -900; y1: 6500; x2: -800; y2: 6400; angle: -90}
//                ListElement{type: "linear"; x1: -800; y1: 6400; x2: -800; y2: 6100}
//            }
//        }
//        Segment{ // Connect far west loop to highway
//            id: seg3
//            segmentSections: ListModel{
//                ListElement{type: "linear"; x1: -800; y1: 6100; x2: -60; y2: 6100}
//            }
//        }
    }
}
