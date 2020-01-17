import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.11

Rectangle{
    signal sigOkClick()
    signal sigCancelClick()
    property int cmbWidth: 200
    property int btnWidth: 100
    property var hoge: [{ foo: 111101, bar: "NEC VP POWER ON"},
                        { foo: 111102, bar: "NEC VP POWER OFF"},
                        { foo: 111103, bar: "NEC VP MUTE ON"},
                        { foo: 111104, bar: "NEC VP MUTE OFF"},
                        { foo: 111105, bar: "NEC VP HDMI ON"},
                        { foo: 111106, bar: "NEC VP HDMI OFF"}]
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
                text: "power on"
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
            Rectangle{
                height: 40
                width: childrenRect.width
                TextField {
                    width: 160
                    font.pointSize: 16
                    selectByMouse: true
                    text: "#FF0000"
                }
                Rectangle{
                    anchors.right: parent.right
                    width: parent.height
                    height: width
                    color: "#FF0000"
                }
            }
            Label{
                font.pixelSize: 24; text: qsTr("Button Source")
            }
            Rectangle{
                height: 40
                width: childrenRect.width
                TextField {
                    width: 160
                    font.pointSize: 16
                    selectByMouse: true
                    text: ""
                }
                Button{
                    anchors.right: parent.right
                    width: parent.height
                    height: width
                    text: "..."
                }
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
            Label{
                font.pixelSize: 24; text: qsTr("Press Source")
            }
            Rectangle{
                height: 40
                width: childrenRect.width
                TextField {
                    width: 160
                    font.pointSize: 16
                    selectByMouse: true
                    text: ""
                }
                Button{
                    anchors.right: parent.right
                    width: parent.height
                    height: width
                    text: "..."
                }
            }
        }
        Rectangle{
            id: list
            anchors.top: main.top
            anchors.left: main.right
            anchors.leftMargin: 10
            width: 200
            height: main.height
            color: "white"
            GridLayout {
                id: grid
                columns: 2
                rowSpacing: 5
                columnSpacing: 5
                anchors.margins: 5
                Repeater {
                    model: hoge
                    Text {
                        Layout.row: index
                        Layout.column: 0
                        font.pointSize: 12
                        text: modelData.foo
                    }
                }
                Repeater {
                    model: hoge
                    Label {
                        Layout.row: index
                        Layout.column: 1
                        font.pointSize: 12
                        text: modelData.bar
                    }
                }
            }
        }
        Rectangle{
            anchors.top: main.top
            anchors.left: list.right
            anchors.leftMargin: 10
            ColumnLayout{
                spacing: 10
                Button {
                    font.pixelSize: 24
                    text: qsTr("add")
                }
                Button {
                    font.pixelSize: 24
                    text: qsTr("edit")
                }
                Button {
                    font.pixelSize: 24
                    text: qsTr("up")
                }
                Button {
                    font.pixelSize: 24
                    text: qsTr("down")
                }
            }
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
