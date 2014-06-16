import QtQuick 2.0
import Lemma 1.0

Item {
    property bool noamIsConnected: false
    property bool waitingForResponse: false
    property string synchMessageName: "synchMessageName"

    function get(){
        return privates.value;
    }

    function set( inValue ){
        if( noamIsConnected ){
            noamLemma.speak( synchMessageName , inValue );
            responseTimeout.start();
        }
        else{
            privates.value = inValue;
        }
    }

    QtObject {
        id: privates
        property var value: initialValue
    }

    NoamLemmaHears{
        topic: synchMessageName
        onNewEvent:{
            privates.value = value;
            responseTimeout.stop();
        }
    }

    NoamConnectionStatus{
        onConnectionEstablished: noamIsConnected = true;
        onConnectionLost: noamIsConnected = false;
    }

    Timer{
        id: responseTimeout
        interval: 1500
        running: false
        repeat: true
        triggeredOnStart: false
        onTriggered:{
            console.warn("failed to get response on synch variable: " + synchMessageName);
        }
    }
}
