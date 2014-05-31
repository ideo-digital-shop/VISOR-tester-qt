import QtQuick 2.0
import Lemma 1.0

Item {
    id: root
    width: 0
    height: 0
    property int heroSize: 30
    property real pixelsPerMeterScale: 1
    property point heroPositionMeters: Qt.point(0,0)

    NoamLemmaHears{
        topic: "heroOrientation"
        onNewEvent:{
            root.rotation = value;
        }
    }

    QtObject{
        id: privates
        property point heroPosition: Qt.point( root.x , root.y )
        onHeroPositionChanged:{
            var hp = new Object();
            hp.x = heroPosition.x / pixelsPerMeterScale;
            hp.y = heroPosition.y / pixelsPerMeterScale;
            heroPositionMeters = Qt.point( hp.x , hp.y );
            if(!throttleTimer.running){
                noamLemma.speak( "heroPosition" , hp );
                throttleTimer.start();
            }
        }
    }

    Timer{
        id: throttleTimer
        interval: 30
        running: false
        repeat: false
    }

    Canvas{
        id: heroPointerCanvas
        smooth: true
        antialiasing: true

        anchors.horizontalCenter: parent.horizontalCenter

        width: heroSize*.75
        height: heroSize*1.5
        onPaint: {
            var ctx = heroPointerCanvas.getContext('2d')
            ctx.clearRect(0, 0, heroPointerCanvas.width, heroPointerCanvas.height)


            ctx.lineJoin = "round"
            ctx.strokeStyle = "white"
            ctx.lineWidth = 3

            ctx.beginPath()
            ctx.moveTo(0, 0)//start point
            ctx.lineTo(heroPointerCanvas.width/2 , heroPointerCanvas.height)
            ctx.lineTo(width , 0)
            ctx.stroke()
        }
    }


    Rectangle{
        id: heroIcon
        smooth: true
        antialiasing: true
        width: heroSize
        height: heroSize
        radius: heroSize / 2
        anchors.centerIn: parent
        color: "#D80"
        border.color: "white"
        border.width: 3
    }
}
