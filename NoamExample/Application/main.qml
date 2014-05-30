import QtQuick 2.2
import QtQuick.Window 2.1
import Lemma 1.0

Rectangle {
    visible: true
    width: 400
    height: 400

    property int clickCount: 0
    property bool noamIsConnected: false
    property string recMessage: ""

    //Text display of received noam message
    Text {
        id: sampleText
        text:{
            if( noamIsConnected ){
                if( !recMessage ) return qsTr("Click the mouse to send a message.");
                else return recMessage;
            }
            else return qsTr("Looking for Noam Hosts...");
        }
        anchors.centerIn: parent
    }

    //Track Noam connection status
    NoamConnectionStatus{
        onConnectionEstablished: noamIsConnected = true;
        onConnectionLost: noamIsConnected = false;
    }

    //Send Noam message
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(noamIsConnected){    //removing this conditional will cause messages to queue when not connected
                clickCount++;
                noamLemma.speak("sampleMessage", "Mouse clicked " + clickCount.toString() + " times.");
            }
        }
    }

    //Hear Noam message
    NoamLemmaHears{
        topic: "sampleMessage"
        onNewEvent:{
            recMessage = value;
        }
    }
}
