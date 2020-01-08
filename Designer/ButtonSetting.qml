import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    signal sigOkClick()
    signal sigCancelClick()
    property int cmbWidth: 200
    property int btnWidth: 100
    Rectangle{
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        width: parent.width; height: 600
        color: "skyblue"
        Text{id: title; font.pixelSize: 24; text: qsTr("ButtonSetting")}
        Grid{
            id: main
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.margins: 30
            anchors.leftMargin: 150
            columns: 2
            spacing: 10
            Label{
                font.pixelSize: 24;text: qsTr("ID")
            }
            Text{
                font.pixelSize: 24;text: "1"
            }
            Label{
                font.pixelSize: 24;text: qsTr("Type")
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("Projector"), qsTr("Monitor"), qsTr("player"), qsTr("Switcher"), qsTr("other")]
                onCurrentIndexChanged:{
                    //console.log(currentIndex)
                }
            }
            Label{
                font.pixelSize: 24; text: qsTr("Text")
            }
            TextField {
                width: 200
                font.pointSize: 16
                selectByMouse: true
                text: ""
            }
            Label{
                font.pixelSize: 24;text: qsTr("Text Position")
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("UP"), qsTr("DOWN")]
                onCurrentIndexChanged:{
                    //console.log(currentIndex)
                }
            }
            Label{
                font.pixelSize: 24; text: qsTr("Text Color")
            }
            TextField {
                width: 200
                font.pointSize: 16
                selectByMouse: true
                text: ""
            }
            Label{
                font.pixelSize: 24; text: qsTr("Button Source")
            }
            TextField {
                width: 200
                font.pointSize: 16
                selectByMouse: true
                text: ""
            }
            Label{
                font.pixelSize: 24;text: qsTr("Back Button Color")
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("RED"), qsTr("GREEN")]
                onCurrentIndexChanged:{
                    //console.log(currentIndex)
                }
            }
            Label{
                font.pixelSize: 24;text: qsTr("Device")
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("[ELMO]Projector"), qsTr("[ELMO]Switcher")]
                onCurrentIndexChanged:{
                    //console.log(currentIndex)
                }
            }
            Label{
                font.pixelSize: 24;text: qsTr("Press Action")
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("NONE"), qsTr("WIDE")]
                onCurrentIndexChanged:{
                    //console.log(currentIndex)
                }
            }
        }
        Rectangle{
            color: "white"
            anchors.top: main.top
            anchors.left: main.right
            anchors.leftMargin: 10
            width: main.width
            height: main.height
        }

        Row{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10
            spacing: 10
            Button{
                text: qsTr("OK")
                width: 120; height: 30
                onClicked: {
                    sigOkClick()
                }
            }
            Button{
                text: qsTr("Cancel")
                width: 120; height: 30
                onClicked: {
                    sigCancelClick()
                }
            }
        }
    }
}
