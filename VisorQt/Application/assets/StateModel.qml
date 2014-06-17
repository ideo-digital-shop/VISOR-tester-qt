import QtQuick 2.0
import Lemma 1.0

Item {
    property bool isEventController: false
    property alias beamAngle: beamAngleSynch
    property alias repeatTime: repeatTimeSynch
    property alias distanceThresholdIn: distanceThresholdInSynch
    property alias useMode: useModeSynch
    property alias soundMode: soundModeSynch
    property alias feedbackMode: feedbackModeSynch
    property alias heroOrientationOffset: heroOrientationOffsetSynch
    property alias buttonFunctionMode: buttonFunctionModeSynch
    property alias flashlightScanMode: flashlightScanModeSynch
    property alias flashlightIsScanning: flashlightIsScanningSynch
    property alias headingSource: headingSourceSynch

    property bool halfButtonState: false
    property bool fullButtonState: false

    NoamLemmaHears{
        topic: "halfButtonState"
        onNewEvent:{
            if( value == 1 || value == true ) halfButtonState = true;
            else halfButtonState = false;
            console.debug("hb press: " + halfButtonState);
        }
    }
    NoamLemmaHears{
        topic: "fullButtonState"
        onNewEvent:{
            if( value == 1 || value == true ) fullButtonState = true;
            else fullButtonState = false;
            console.debug("hb press: " + fullButtonState);
        }
    }

    ///////////////

    SynchronizedVar{
        id: beamAngleSynch
        initialValue: 10
        synchMessageName: "beamAngleSynch"
    }
    SynchronizedVar{
        id: repeatTimeSynch
        initialValue: 5
        synchMessageName: "repeatTimeSynch"
    }
    SynchronizedVar{
        id: distanceThresholdInSynch
        initialValue: 240
        synchMessageName: "distanceThresholdInSynch"
    }
    SynchronizedVar{
        id: useModeSynch
        initialValue: "flashlight"
        synchMessageName: "useModeSynch"
    }
    SynchronizedVar{
        id: soundModeSynch
        initialValue: "stereo"
        synchMessageName: "soundModeSynch"
    }
    SynchronizedVar{
        id: feedbackModeSynch
        initialValue: "standing"
        synchMessageName: "feedbackModeSynch"
    }
    SynchronizedVar{
        id: heroOrientationOffsetSynch
        initialValue: 0
        synchMessageName: "heroOrientationOffsetSynch"
    }
    SynchronizedVar{
        id: buttonFunctionModeSynch
        initialValue: "flashlight"
        synchMessageName: "buttonFunctionModeSynch"
    }
    SynchronizedVar{
        id: flashlightScanModeSynch
        initialValue: "timer"
        synchMessageName: "flashlightScanModeSynch"
    }
    SynchronizedVar{
        id: flashlightIsScanningSynch
        initialValue: false
        synchMessageName: "flashlightIsScanningSynch"
    }
    SynchronizedVar{
        id: headingSourceSynch
        initialValue: "body"
        synchMessageName: "headingSourceSynch"
    }
}
