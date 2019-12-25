import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle{
    id: message
    property string messageText: qsTr("Are you sure?")
    signal sigYesClick()
    signal sigNoClick()
    width: 300
    height: 100
    border.width: 1
    Text{
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        text: messageText
        font.pointSize: 12
    }
    Row{
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        spacing: 10
        Button{
            id: btnYes
            text: qsTr("Yes")
            width: 120; height: 30
            onClicked: {
                sigYesClick()
                message.visible = false
            }
        }
        Button{
            id: btnNo
            text: qsTr("No")
            width: 120; height: 30
            onClicked: {
                sigNoClick()
                message.visible = false
            }
        }
    }
}
