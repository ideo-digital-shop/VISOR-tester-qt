import QtQuick 2.2
import Lemma 1.0

Item {
    property bool noamIsConnected: false
    property bool isMasterModerator: true

    onNoamIsConnectedChanged: {
        if( !noamIsConnected ){
            isMasterModerator = true;
        }
        else{
            isMasterModerator = false;
            masterizer.pollMasters();
        }
    }
    NoamLemmaHears{
        topic: "pollForMaster"
        onNewEvent:{
            if( isMasterModerator ){
                noamLemma.speak("masterExists" , true);
            }
        }
    }

    NoamLemmaHears{
        topic: "masterExists"
        onNewEvent:{
            masterizer.killPoll();
        }
    }
    Timer{
        id: masterizer
        running: false
        repeat: false
        triggeredOnStart: false
        interval: 500
        onTriggered:{
            isMasterModerator = true;
        }
        function pollMasters(){
            noamLemma.speak( "pollForMaster" , true );
            masterizer.start();
        }
        function killPoll(){
            masterizer.stop();
        }
    }
}
