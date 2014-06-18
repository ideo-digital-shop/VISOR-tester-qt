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

         // walls large
        Segment{
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 220; y1: 393.5; x2: 226; y2: 393.5; tag: "wall"}
                ListElement{type: "linear"; x1: 226; y1: 393.5; x2: 226; y2: 390.5; tag: "wall"}
                ListElement{type: "linear"; x1: 226; y1: 390.5; x2: 232.5; y2: 390.5; tag: "wall"}
            }
        }

        // walls kitchenette
        Segment{
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 232.5; y1: 390.5; x2: 232.5; y2: 384; tag: "wall"}
                ListElement{type: "linear"; x1: 232.5; y1: 384; x2: 228.5; y2: 384; tag: "wall"}
                ListElement{type: "linear"; x1: 228.5; y1: 384; x2: 228.5; y2: 295; tag: "wall"}
                ListElement{type: "linear"; x1: 228.5; y1: 295; x2: 232.5; y2: 295; tag: "wall"}
                ListElement{type: "linear"; x1: 232.5; y1: 295; x2: 232.5; y2: 289; tag: "wall"}

            }
        }

        // wall d-shop
        Segment{
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 232.5; y1: 289; x2: 204.5; y2: 289; tag: "wall"}
                ListElement{type: "linear"; x1: 204.5; y1: 289; x2: 204.5; y2: 0; tag: "wall"}
                ListElement{type: "linear"; x1: 204.5; y1: 0; x2: 584.5; y2: 0; tag: "wall"}
                ListElement{type: "linear"; x1: 584.5; y1: 0; x2: 584.5; y2: 275.5; tag: "wall"}

            }
        }
        Segment{ // wall communal
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 584.5; y1: 275.5; x2: 614.5; y2: 275.5; tag: "wall"}

                ListElement{type: "linear"; x1: 941; y1: 275.5; x2: 1144.5; y2: 275.5; tag: "wall"}
                ListElement{type: "linear"; x1: 1144.5; y1: 275.5; x2: 1144.5; y2: 322; tag: "wall"}
                ListElement{type: "linear"; x1: 1144.5; y1: 393.5; x2: 1144.5; y2: 445; tag: "wall"}
                ListElement{type: "linear"; x1: 1144.5; y1: 445; x2: 1184.5; y2: 489; tag: "wall"}
                ListElement{type: "linear"; x1: 1184.5; y1: 489; x2: 1018; y2: 489; tag: "wall"}
                ListElement{type: "linear"; x1: 1018; y1: 489; x2: 1018; y2: 491; tag: "wall"}
                ListElement{type: "linear"; x1: 650; y1: 275.5; x2: 870; y2: 275.5; tag: "wall"}
                ListElement{type: "linear"; x1: 905; y1: 275.5; x2: 940; y2: 275.5; tag: "wall"}
            }
        }
        Segment{ // Door to health
            segmentType: "Place"
            segmentName: "Exit"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 615; y1: 275.5; x2: 650; y2: 275.5; tag: "door"}
            }
        }
        Segment{ // Door to health near entrance
            segmentType: "Place"
            segmentName: "Exit"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 870; y1: 275.5; x2: 905; y2: 275.5; tag: "door"}
            }
        }


        Segment{ // meeting
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1018; y1: 491; x2: 1184.5; y2: 491; tag: "wall"}
                ListElement{type: "linear"; x1: 1018; y1: 491; x2: 1018; y2: 562; tag: "wall"}
            }
        }

        Segment{ // TK, DS, 6B and 6A Offices Walls
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1018; y1: 562; x2: 632; y2: 562; tag: "wall"}
            }
        }

        Segment{ // 6A Office Door
            segmentType: "Thing"
            segmentName: "FrontDesk"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 656; y1: 561; x2: 593; y2: 561; tag: "wall"}
                ListElement{type: "linear"; x1: 656; y1: 561; x2: 656; y2: 555; tag: "wall"}
                ListElement{type: "linear"; x1: 593; y1: 561; x2: 593; y2: 555; tag: "wall"}
                ListElement{type: "linear"; x1: 656; y1: 555; x2: 593; y2: 555; tag: "wall"}
            }
        }

        Segment{ // 7B and 7A Office Wall
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 593; y1: 562; x2: 378; y2: 562; tag: "wall"}
            }
        }

        // Bathroom walls
        Segment{
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 378; y1: 562; x2: 378; y2: 439; tag: "wall"}
                ListElement{type: "linear"; x1: 378; y1: 562; x2: 378; y2: 439; tag: "wall"}
                ListElement{type: "linear"; x1: 378; y1: 439; x2: 285; y2: 439; tag: "wall"}
                ListElement{type: "linear"; x1: 285; y1: 439; x2: 285; y2: 463; tag: "wall"}
                // Door here
                ListElement{type: "linear"; x1: 285; y1: 500; x2: 285; y2: 715; tag: "wall"}
                ListElement{type: "linear"; x1: 225; y1: 430; x2: 225; y2: 715; tag: "wall"}
            }
        }

        Segment{ // Bathroom Door
            segmentType: "Place"
            segmentName: "Exit"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 285; y1: 463; x2: 285; y2: 500; tag: "door"}
            }
        }

        Segment{ // Door to other side
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 225; y1: 430; x2: 225; y2: 715; tag: "door"}
            }
        }

        Segment{ // Exit Pass
            segmentType: "Place"
            segmentName: "Exit"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 991; y1: 330; x2: 991; y2: 277; tag: "exit"}
            }
        }
        Segment{ // Exit Pass
            segmentType: "Place"
            segmentName: "Exit"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 227; y1: 397; x2: 227; y2: 432; tag: "exit"}
            }
        }
        Segment{ // Restroom Pass
            segmentType: "Place"
            segmentName: "Restroom"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 285; y1: 572; x2: 224; y2: 572; tag: "exit"}
            }
        }

        // Kitchenette Island
        Segment{
            segmentName: "Kitchen"
            segmentType: "Place"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 284; y1: 390; x2: 316; y2: 390; tag: "kitchen"}
                ListElement{type: "linear"; x1: 316; y1: 390; x2: 316; y2: 290; tag: "kitchen"}
                ListElement{type: "linear"; x1: 316; y1: 290; x2: 284; y2: 290; tag: "kitchen"}
                ListElement{type: "linear"; x1: 284; y1: 290; x2: 284; y2: 296; tag: "kitchen"}
                ListElement{type: "linear"; x1: 284; y1: 296; x2: 310; y2: 296; tag: "kitchen"}
                ListElement{type: "linear"; x1: 310; y1: 296; x2: 310; y2: 384; tag: "kitchen"}
                ListElement{type: "linear"; x1: 310; y1: 384; x2: 284; y2: 384; tag: "kitchen"}
                ListElement{type: "linear"; x1: 284; y1: 384; x2: 284; y2: 390; tag: "kitchen"}
            }
        }

        // Trash Cans
        Segment{
            segmentName: "Recycling"
            segmentType: "Thing"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 300; y1: 437; x2: 300; y2: 425; tag: "recycling"}
                ListElement{type: "linear"; x1: 300; y1: 425; x2: 365; y2: 425; tag: "recycling"}
                ListElement{type: "linear"; x1: 365; y1: 425; x2: 365; y2: 437; tag: "recycling"}
                ListElement{type: "linear"; x1: 365; y1: 437; x2: 300; y2: 437; tag: "recycling"}
            }
        }

        // Phone Booths
        Segment{ // wall phone booth
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1045; y1: 328; x2: 991; y2: 328; tag: "phone booth"}
                ListElement{type: "linear"; x1: 991; y1: 328; x2: 991; y2: 438; tag: "phone booth"}
                ListElement{type: "linear"; x1: 991; y1: 438; x2: 1045; y2: 438; tag: "phone booth"}
                ListElement{type: "linear"; x1: 1045; y1: 438; x2: 1045; y2: 328; tag: "phone booth"}
            }

        }

        // Big Main Table
        Segment{
            segmentName: "Table"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 485; y1: 385; x2: 485; y2: 445; tag: "table"}
                ListElement{type: "linear"; x1: 485; y1: 445; x2: 630; y2: 445; tag: "table"}
                ListElement{type: "linear"; x1: 630; y1: 445; x2: 630; y2: 385; tag: "table"}
                ListElement{type: "linear"; x1: 630; y1: 385; x2: 485; y2: 385; tag: "table"}
            }
        }
        // Single Big Main Table Chair
        Segment{
            segmentName: "Chair"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 605; y1: 370; x2: 605; y2: 385; tag: "chair"}
                ListElement{type: "linear"; x1: 605; y1: 385; x2: 620; y2: 385; tag: "chair"}
                ListElement{type: "linear"; x1: 620; y1: 385; x2: 620; y2: 370; tag: "chair"}
                ListElement{type: "linear"; x1: 620; y1: 370; x2: 605; y2: 370; tag: "chair"}
            }
        }


        // Small Main Table
        Segment{
            segmentName: "Table"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 700; y1: 385; x2: 700; y2: 445; tag: "table"}
                ListElement{type: "linear"; x1: 700; y1: 445; x2: 785; y2: 445; tag: "table"}
                ListElement{type: "linear"; x1: 785; y1: 445; x2: 785; y2: 385; tag: "table"}
                ListElement{type: "linear"; x1: 785; y1: 385; x2: 700; y2: 385; tag: "table"}
            }
        }

        // Stationary Whiteboard and Table Obstacles near kitchen
        Segment{
            segmentName: "Table"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 315; y1: 220; x2: 315; y2: 290; tag: "table"}
                ListElement{type: "linear"; x1: 315; y1: 290; x2: 345; y2: 290; tag: "table"}
                ListElement{type: "linear"; x1: 345; y1: 290; x2: 345; y2: 220; tag: "table"}
                ListElement{type: "linear"; x1: 345; y1: 220; x2: 315; y2: 220; tag: "table"}
            }
        }

        // Meeting Booth
        Segment{
            segmentName: "PhoneBooth"
            segmentType: "Thing"
            isTarget: true
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 291; y1: 66; x2: 291; y2: 0; tag: "meeting booth"}
                ListElement{type: "linear"; x1: 291; y1: 0; x2: 379; y2: 0; tag: "meeting booth"}
                ListElement{type: "linear"; x1: 379; y1: 0; x2: 379; y2: 66; tag: "meeting booth"}
                ListElement{type: "linear"; x1: 379; y1: 66; x2: 291; y2: 66; tag: "meeting booth"}
            }
        }


        // D Shop EE Table
        Segment{
            segmentName: "Table"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 484; y1: 100; x2: 584; y2: 100; tag: "table"}
                ListElement{type: "linear"; x1: 584; y1: 100; x2: 584; y2: 0; tag: "table"}
                ListElement{type: "linear"; x1: 584; y1: 0; x2: 484; y2: 0; tag: "table"}
                ListElement{type: "linear"; x1: 484; y1: 0; x2: 484; y2: 100; tag: "table"}
            }
        }
        // Chair
        Segment{
            segmentName: "Chair"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 450; y1: 50; x2: 466; y2: 50; tag: "chair"}
                ListElement{type: "linear"; x1: 466; y1: 50; x2: 466; y2: 66; tag: "chair"}
                ListElement{type: "linear"; x1: 466; y1: 66; x2: 450; y2: 66; tag: "chair"}
                ListElement{type: "linear"; x1: 450; y1: 66; x2: 450; y2: 50; tag: "chair"}

            }
        }


        // D-shop center Table obstacle
        Segment{
            segmentName: "Table"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 381; y1: 140; x2: 381; y2: 172; tag: "table"}
                ListElement{type: "linear"; x1: 381; y1: 172; x2: 451; y2: 172; tag: "table"}
                ListElement{type: "linear"; x1: 451; y1: 172; x2: 451; y2: 140; tag: "table"}
                ListElement{type: "linear"; x1: 451; y1: 140; x2: 381; y2: 140; tag: "table"}
            }
        }
        // Chair - bottom
        Segment{
            segmentName: "Chair"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 400; y1: 177; x2: 400; y2: 193; tag: "chair"}
                ListElement{type: "linear"; x1: 400; y1: 193; x2: 416; y2: 193; tag: "chair"}
                ListElement{type: "linear"; x1: 416; y1: 193; x2: 416; y2: 177; tag: "chair"}
                ListElement{type: "linear"; x1: 416; y1: 177; x2: 400; y2: 177; tag: "chair"}
            }
        }
        // Chair - left
        Segment{
            segmentName: "Chair"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 381; y1: 145; x2: 381; y2: 161; tag: "chair"}
                ListElement{type: "linear"; x1: 381; y1: 161; x2: 365; y2: 161; tag: "chair"}
                ListElement{type: "linear"; x1: 365; y1: 161; x2: 365; y2: 145; tag: "chair"}
                ListElement{type: "linear"; x1: 365; y1: 145; x2: 381; y2: 145; tag: "chair"}
            }
        }


        // Tall 'Circular' Tables
        Segment{
            segmentName: "Table"
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 560; y1: 245; x2: 560; y2: 275; tag: "table"}
                ListElement{type: "linear"; x1: 560; y1: 275; x2: 530; y2: 275; tag: "table"}
                ListElement{type: "linear"; x1: 530; y1: 275; x2: 530; y2: 245; tag: "table"}
                ListElement{type: "linear"; x1: 530; y1: 245; x2: 560; y2: 245; tag: "table"}
            }
        }

        // Cabinets
        Segment{
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1142; y1: 277; x2: 1052; y2: 277; tag: "cabinet"}
                ListElement{type: "linear"; x1: 1052; y1: 277; x2: 1052; y2: 293; tag: "cabinet"}
                ListElement{type: "linear"; x1: 1052; y1: 293; x2: 1142; y2: 293; tag: "cabinet"}
                ListElement{type: "linear"; x1: 1142; y1: 293; x2: 1142; y2: 277; tag: "cabinet"}

            }
        }
        Segment{
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 860; y1: 277; x2: 788; y2: 277; tag: "cabinet"}
                ListElement{type: "linear"; x1: 788; y1: 277; x2: 788; y2: 293; tag: "cabinet"}
                ListElement{type: "linear"; x1: 788; y1: 293; x2: 860; y2: 293; tag: "cabinet"}
                ListElement{type: "linear"; x1: 860; y1: 293; x2: 860; y2: 277; tag: "cabinet"}

            }
        }
        Segment{
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 787; y1: 277; x2: 715; y2: 277; tag: "cabinet"}
                ListElement{type: "linear"; x1: 715; y1: 277; x2: 715; y2: 293; tag: "cabinet"}
                ListElement{type: "linear"; x1: 715; y1: 293; x2: 787; y2: 293; tag: "cabinet"}
                ListElement{type: "linear"; x1: 787; y1: 293; x2: 787; y2: 277; tag: "cabinet"}

            }
        }


        // Copy Machine
        Segment{
            segmentType: "Unknown"
            segmentName: ""
            segmentSections: ListModel{
                ListElement{type: "linear"; x1: 1110; y1: 485; x2: 1094; y2: 485; tag: "fax machine"}
                ListElement{type: "linear"; x1: 1094; y1: 485; x2: 1094; y2: 461; tag: "fax machine"}
                ListElement{type: "linear"; x1: 1094; y1: 461; x2: 1110; y2: 461; tag: "fax machine"}
                ListElement{type: "linear"; x1: 1110; y1: 461; x2: 1110; y2: 485; tag: "fax machine"}

            }
        }



//        Segment{ // Far west loop, lower curve
//            id: seg2
//            segmentSections: ListModel{
//                ListElement{type: "linear"; x1: -1400; y1: 6100; x2: -1400; y2: 6400}
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
