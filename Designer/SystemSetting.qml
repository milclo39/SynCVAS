import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: setting
    property string curIpAddr: txtIpaddr.text
    property string curMacAddr: txtMacaddr.text
    Text{id: title; font.pixelSize: 24; text: "SystemSetting"}
    Column{
        spacing: btnsize / 12
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Row{
            Label{
                anchors.verticalCenter: parent.verticalCenter
                text: "IP Address:"
            }
            TextField {
                id: txtIpaddr
                width: btnsize
                font.pointSize: 16
                placeholderText: qsTr("*.*.*.*")
                selectByMouse: true
                text: ""
            }
        }
        Row{
            Label{
                anchors.verticalCenter: parent.verticalCenter
                text: "MAC Address:"
            }
            TextField {
                id: txtMacaddr
                width: btnsize
                font.pointSize: 16
                placeholderText: qsTr("************")
                selectByMouse: true
                text: ""
            }
        }
    }
}