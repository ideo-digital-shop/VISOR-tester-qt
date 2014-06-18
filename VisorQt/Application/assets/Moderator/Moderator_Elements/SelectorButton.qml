import QtQuick 2.0

Button {
    signal selectedSignal( int childIndex )
    signal clearedSignal

    property int childIndex: -1
    property string selectionParameter: "wat"
    property bool enabled: true

    onClicked: {
        if(enabled && !active){
            active = true;
            selectedSignal( childIndex );
        }
    }

    function clearSelection(){
        active = false;
        clearedSignal();
    }
}
