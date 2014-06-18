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
    property alias targetObject: targetObjectSynch
    property alias motorIntensity: motorIntensitySynch
    property alias motorDuration: motorDurationSynch
    property alias vibeMode: vibeModeSynch
    property alias buttonEnabled: buttonEnabledSynch

    property bool halfButtonState: false
    property bool fullButtonState: false

    NoamLemmaHears{
        topic: "BTN2"
        onNewEvent:{
            if(!buttonEnabled.get())return;
            if( value == 1 || value == true ) halfButtonState = true;
            else halfButtonState = false;
            b1ResetTimer.restart();
            console.debug("hb press: " + halfButtonState);
        }
    }
    Timer{
        id: b1ResetTimer
        interval: 275
        running: false
        repeat: false
        onTriggered: halfButtonState = false;
    }

    NoamLemmaHears{
        topic: "BTN3"
        onNewEvent:{
            if(!buttonEnabled.get())return;
            if( value == 1 || value == true ) fullButtonState = true;
            else fullButtonState = false;
            b2ResetTimer.restart();
            console.debug("hb press: " + fullButtonState);
        }
    }
    Timer{
        id: b2ResetTimer
        interval: 275
        running: false
        repeat: false
        onTriggered: fullButtonState = false;
    }

    ///////////////

    SynchronizedVar{
        id: beamAngleSynch
        initialValue: 10
        synchMessageName: "beamAngleSynch"
    }
    SynchronizedVar{
        id: repeatTimeSynch
        initialValue: 2
        synchMessageName: "repeatTimeSynch"
    }
    SynchronizedVar{
        id: distanceThresholdInSynch
        initialValue: 360
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
    SynchronizedVar{
        id: targetObjectSynch
        initialValue: "none"
        synchMessageName: "targetObjectSynch"
    }
    SynchronizedVar{
        id: motorIntensitySynch
        initialValue: "4095"
        synchMessageName: "motorIntensitySynch"
    }
    SynchronizedVar{
        id: motorDurationSynch
        initialValue: "500"
        synchMessageName: "motorDurationSynch"
    }
    SynchronizedVar{
        id: vibeModeSynch
        initialValue: 0
        synchMessageName: "vibeModeSynch"
    }
    SynchronizedVar{
        id: buttonEnabledSynch
        initialValue: 1
        synchMessageName: "buttonEnabledSynch"
    }
}
