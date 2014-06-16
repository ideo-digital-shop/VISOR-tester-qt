import QtQuick 2.0

Item {
    property alias beamAngle: beamAngleSynch
    property alias repeatTime: repeatTimeSynch
    property alias distanceThresholdIn: distanceThresholdInSynch
    property alias useMode: useModeSynch
    property alias soundMode: soundModeSynch
    property alias feedbackMode: feedbackModeSynch

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
        initialValue: "simple"
        synchMessageName: "soundModeSynch"
    }
    SynchronizedVar{
        id: feedbackModeSynch
        initialValue: "standing"
        synchMessageName: "feedbackModeSynch"
    }
}
