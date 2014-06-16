import QtQuick 2.0

Button {
    signal selectedSignal( int childIndex )
    signal clearedSignal

    property int childIndex: -1
    property var selectionParameter

    onClicked: {
        if(!active){
            active = true;
            selectedSignal( childIndex );
        }
    }

    function clearSelection(){
        active = false;
        clearedSignal();
    }
}
