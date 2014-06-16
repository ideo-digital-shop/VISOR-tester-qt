import QtQuick 2.0

Item {
    id: root
    width: 0
    height: 0
    property int heroSize: 30
    property real pixelsPerMeterScale: 1
    property variant heroModel

    x: pixelsPerMeterScale * privates.heroPositionMeters.x
    y: pixelsPerMeterScale * privates.heroPositionMeters.y
    rotation: privates.heroOrientation

    QtObject{
        id: privates
        property point heroPositionMeters: heroModel.heroPositionMeters
        property real heroOrientation: heroModel.heroOrientation
    }

    Canvas{
        id: heroPointerCanvas
        smooth: true
        antialiasing: true

        anchors.horizontalCenter: parent.horizontalCenter

        width: heroSize * .75
        height: heroSize * 1.5
        onPaint: {
            var ctx = heroPointerCanvas.getContext('2d')
            ctx.clearRect(0, 0, heroPointerCanvas.width, heroPointerCanvas.height)


            ctx.lineJoin = "round"
            ctx.strokeStyle = "#DD0"
            ctx.lineWidth = 1.5

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
        border.color: "#DD0"
        border.width: 1.5
    }
    Text{
        x:25
        y:-5
        color: "white"
        rotation: -root.rotation
        text: parseInt(privates.heroPositionMeters.x) + ", " + parseInt(privates.heroPositionMeters.y)
    }
}
