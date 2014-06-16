import QtQuick 2.0
import Lemma 1.0
import "."
/*
  Network graph for the generic world map
  */
NetworkGraph {
    id: root
    segments: segmentsObject
    //xmax = 1184
    Item{
        id: segmentsObject
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 0; y1: 0; x2: 198; y2: 0; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 198; y1: 0; x2: 198; y2: 313; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 198; y1: 313; x2: 37.5; y2: 313; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 37.5; y1: 313; x2: 37.5; y2: 319; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 37.5; y1: 319; x2: 198; y2: 319; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 198; y1: 319; x2: 198; y2: 390.5; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 198; y1: 390.5; x2: 220; y2: 390.5; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 220; y1: 390.5; x2: 220; y2: 393.5; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 220; y1: 393.5; x2: 226; y2: 393.5; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 226; y1: 393.5; x2: 226; y2: 390.5; tag: "wall"}
            }
        }
        Segment{ // wall large
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 226; y1: 390.5; x2: 232.5; y2: 390.5; tag: "wall"}
            }
        }
        Segment{ // wall kitchenette
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 232.5; y1: 390.5; x2: 232.5; y2: 384; tag: "wall"}
            }
        }
        Segment{ // wall kitchenette
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 232.5; y1: 384; x2: 228.5; y2: 384; tag: "wall"}
            }
        }
        Segment{ // wall kitchenette
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 228.5; y1: 384; x2: 228.5; y2: 295; tag: "wall"}
            }
        }
        Segment{ // wall kitchenette
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 228.5; y1: 295; x2: 232.5; y2: 295; tag: "wall"}
            }
        }
        Segment{ // wall kitchenette
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 232.5; y1: 295; x2: 232.5; y2: 289; tag: "wall"}
            }
        }
        Segment{ // wall d-shop
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 232.5; y1: 289; x2: 204.5; y2: 289; tag: "wall"}
            }
        }
        Segment{ // wall d-shop
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 204.5; y1: 289; x2: 204.5; y2: 0; tag: "wall"}
            }
        }
        Segment{ // wall d-shop
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 204.5; y1: 0; x2: 584.5; y2: 0; tag: "wall"}
            }
        }
        Segment{ // wall d-shop
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 584.5; y1: 0; x2: 584.5; y2: 275.5; tag: "wall"}
            }
        }
        Segment{ // wall d-shop
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 584.5; y1: 275.5; x2: 614.5; y2: 275.5; tag: "wall"}
            }
        }
        Segment{ // wall d-shop
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 614.5; y1: 275.5; x2: 614.5; y2: 270.5; tag: "wall"}
            }
        }
        Segment{ // wall health
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 614.5; y1: 270.5; x2: 590.5; y2: 270.5; tag: "wall"}
            }
        }
        Segment{ // wall health
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 590.5; y1: 270.5; x2: 590.5; y2: 0; tag: "wall"}
            }
        }
        Segment{ // wall health
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 590.5; y1: 0; x2: 1184.5; y2: 0; tag: "wall"}
            }
        }
        Segment{ // wall health
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1184.5; y1: 0; x2: 1184.5; y2: 236.5; tag: "wall"}
            }
        }
        Segment{ // wall health
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1184.5; y1: 236.5; x2: 1155.5; y2: 270.5; tag: "wall"}
            }
        }
        Segment{ // wall health
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1155.5; y1: 270.5; x2: 941; y2: 270.5; tag: "wall"}
            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 941; y1: 270.5; x2: 941; y2: 275.5; tag: "wall"}
            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 941; y1: 275.5; x2: 1144.5; y2: 275.5; tag: "wall"}
            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1144.5; y1: 275.5; x2: 1144.5; y2: 322; tag: "wall"}
            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1144.5; y1: 393.5; x2: 1144.5; y2: 445; tag: "wall"}
            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1144.5; y1: 445; x2: 1184.5; y2: 489; tag: "wall"}
            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1184.5; y1: 489; x2: 1018; y2: 489; tag: "wall"}
            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1018; y1: 489; x2: 1018; y2: 491; tag: "wall"}
            }
        }
        Segment{ // meeting
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1018; y1: 491; x2: 1184.5; y2: 491; tag: "wall"}
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
