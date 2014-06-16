import QtQuick 2.0
import Lemma 1.0
import "."
/*
  Network graph for the generic world map
  */
NetworkGraph {
    id: root
    segments: segmentsObject    
    //xmax = 585.5
    Item{
        id: segmentsObject
        Segment{ // door wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 38; y1: 22; x2: 38; y2: 0; tag: "wall"}
            }
        }
        Segment{ // door wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 38; y1: 22; x2: 0; y2: 22; tag: "wall"}
            }
        }

        Segment{ // reception wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 0; y1: 22; x2: 0; y2: 416; tag: "wall"}
            }
        }
        Segment{ // reception wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 0; y1: 416; x2: 89; y2: 395; tag: "wall"}
            }
        }

        Segment{ // pony wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 118; y1: 0; x2: 118; y2: 120; tag: "wall"}
            }
        }
        Segment{ // pony wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 118; y1: 120; x2: 137; y2: 120; tag: "wall"}
            }
        }
        Segment{ // pony wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 137; y1: 120; x2: 137; y2: 0; tag: "wall"}
            }
        }

        Segment{ // pony wall 2
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 125; y1: 266; x2: 144; y2: 266; tag: "wall"}
            }
        }
        Segment{ // pony wall 2
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 144; y1: 266; x2: 144; y2: 386; tag: "wall"}
            }
        }
        Segment{ // pony wall 2
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 125; y1: 266; x2: 125; y2: 389; tag: "wall"}
            }
        }

        Segment{ // kitchen wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 144; y1: 386; x2: 425.5; y2: 335; tag: "wall"}
            }
        }

        Segment{ // post 1
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 159.5; y1: 205; x2: 159.5; y2: 219; tag: "post"}
                ListElement{type: "linear"; x1: 159.5; y1: 219; x2: 173.5; y2: 219; tag: "post"}
                ListElement{type: "linear"; x1: 173.5; y1: 219; x2: 173.5; y2: 205; tag: "post"}
                ListElement{type: "linear"; x1: 173.5; y1: 205; x2: 159.5; y2: 205; tag: "post"}
            }
        }

        Segment{ // post 2
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 425.5; y1: 205; x2: 425.5; y2: 219; tag: "post"}
                ListElement{type: "linear"; x1: 425.5; y1: 219; x2: 411.5; y2: 219; tag: "post"}
                ListElement{type: "linear"; x1: 411.5; y1: 219; x2: 411.5; y2: 205; tag: "post"}
                ListElement{type: "linear"; x1: 411.5; y1: 205; x2: 425.5; y2: 205; tag: "post"}
            }
        }

        Segment{ // mini post
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 364.5; y1: 208; x2: 364.5; y2: 214; tag: "post"}
                ListElement{type: "linear"; x1: 364.5; y1: 214; x2: 358.5; y2: 214; tag: "post"}
                ListElement{type: "linear"; x1: 358.5; y1: 214; x2: 358.5; y2: 208; tag: "post"}
                ListElement{type: "linear"; x1: 358.5; y1: 208; x2: 364.5; y2: 208; tag: "post"}
            }
        }

        Segment{ // stair wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 173.5; y1: 205; x2: 322.5; y2: 205; tag: "wall"}
            }
        }
        Segment{ // stair wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 322.5; y1: 205; x2: 322.5; y2: 151; tag: "wall"}
            }
        }
        Segment{ // stair wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 322.5; y1: 151; x2: 173.5; y2: 151; tag: "wall"}
            }
        }

        Segment{ // window wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 137; y1: 0; x2: 465.5; y2: 0; tag: "wall"}
            }
        }
        Segment{ // bump wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 465.5; y1: 0; x2: 465.5; y2: 24; tag: "wall"}
            }
        }
        Segment{ // bump wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 465.5; y1: 24; x2: 585.5; y2: 24; tag: "wall"}
            }
        }
        Segment{ // tv wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 585.5; y1: 24; x2: 585.5; y2: 330; tag: "wall"}
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
