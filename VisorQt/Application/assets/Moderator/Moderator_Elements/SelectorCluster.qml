import QtQuick 2.0

Rectangle {
    id: root
    width: 100
    height: 100
    color: "#68555555"
    radius: 2

    property int nChildren: children.length
    property string labelText: "labelText"
    property alias mainLabel: mainLabel
    signal selectedSignal( var selectionParameter )

    Label{
        id: mainLabel
        anchors {top: parent.top; left: parent.left; topMargin: 8; leftMargin: 8}
        label: labelText
        color: "transparent"
    }

    Component.onCompleted:{
        for(var i=0; i<nChildren; i++){
            if(children[i].childIndex !== undefined )children[i].childIndex = i;
            if(children[i].selectedSignal) children[i].selectedSignal.connect(handleSelection);
        }
    }

    function handleSelection( genIndex ){
        for(var i=0; i<nChildren; i++){
            if( i != genIndex){
                if( children[i].clearSelection )children[i].clearSelection();
            }
            else{
                selectedSignal( children[i].selectionParameter );
            }
        }
    }
}
