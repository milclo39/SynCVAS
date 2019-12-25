import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: device
    property string curIpAddr: txtIpaddr.text
    property string curPort: txtPort.text
    property int cmbWidth: 200
    property int btnWidth: 100
    Text{id: title; font.pixelSize: 24; text: qsTr("DeviceSetting")}
    Rectangle{
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        width: 768; height: 432
        color: "skyblue"
        Grid{
            id: ip
            anchors.top: parent.top
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 2
            spacing: 10
            Label{
                font.pixelSize: 24; text: qsTr("IP Address")
            }
            TextField {
                id: txtIpaddr
                width: 200
                font.pointSize: 16
                placeholderText: "*.*.*.*"
                selectByMouse: true
                text: ""
            }
            Label{
                font.pixelSize: 24; text: qsTr("Port")
            }
            TextField {
                id: txtPort
                width: 200
                font.pointSize: 16
                selectByMouse: true
                text: ""
            }
        }
        Grid{
            anchors.top: ip.bottom
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 4
            spacing: 10
            // 1段目
            Label{
                font.pixelSize: 20
                text: "COM1"
            }
            ComboBox{
                id: combo1
                width: cmbWidth
                model: [qsTr("Projector"), qsTr("Monitor"), qsTr("player"), qsTr("Switcher"), qsTr("other")]
                onCurrentIndexChanged:{
                    //console.log(currentIndex)
                }
            }
            ComboBox{
                id: combo2
                width: cmbWidth
                model: [qsTr("ELMO"), qsTr("PANNA"), qsTr("SQNY"), qsTr("RICHON"), qsTr("other")]
                onCurrentIndexChanged:{
                    //console.log(currentIndex)
                }
            }
            Button{
                id: button1
                width: btnWidth
                text: qsTr("Macro")
                onClicked:{}
            }
            // 2段目
            Label{
                font.pixelSize: 20
                text: "COM2"
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("Projector"), qsTr("Monitor"), qsTr("player"), qsTr("Switcher"), qsTr("other")]
                onCurrentIndexChanged:{
                }
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("ELMO"), qsTr("PANNA"), qsTr("SQNY"), qsTr("RICHON"), qsTr("other")]
                onCurrentIndexChanged:{
                }
            }
            Button{
                width: btnWidth
                text: qsTr("Macro")
                onClicked:{}
            }
            // 3段目
            Label{
                font.pixelSize: 20
                text: "COM3"
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("Projector"), qsTr("Monitor"), qsTr("player"), qsTr("Switcher"), qsTr("other")]
                onCurrentIndexChanged:{
                }
            }
            ComboBox{
                width: cmbWidth
                model: [qsTr("ELMO"), qsTr("PANNA"), qsTr("SQNY"), qsTr("RICHON"), qsTr("other")]
                onCurrentIndexChanged:{
                }
            }
            Button{
                width: btnWidth
                text: qsTr("Macro")
                onClicked:{}
            }
            // 4段目
            Label{
                font.pixelSize: 20
                text: qsTr("IR")
            }
            Text{text: " "}
            ComboBox{
                width: cmbWidth
                model: [qsTr("ELMO"), qsTr("PANNA"), qsTr("SQNY"), qsTr("RICHON"), qsTr("other")]
                onCurrentIndexChanged:{
                }
            }
            Button{
                width: btnWidth
                text: qsTr("Macro")
                onClicked:{}
            }
            // 5段目
            Label{
                font.pixelSize: 20
                text: qsTr("Ry")
            }
            Text{text: " "}
            Text{text: " "}
            Button{
                width: btnWidth
                text: qsTr("Macro")
                onClicked:{}
            }
        }
    }
}