import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle{
    id: setting
    Text{id: title; font.pixelSize: 24; text: qsTr("SystemSetting")}
    Rectangle{
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        width: 768; height: 432
        color: "skyblue"
        Rectangle{
            Column{
                width: 200
                Text{font.pixelSize: 24; text: qsTr("Operation macro")}
                Text{font.pixelSize: 24; text: qsTr("Ry1 macro")}
                Text{font.pixelSize: 24; text: qsTr("Ry2 macro")}
                Text{font.pixelSize: 24; text: qsTr("Ry3 macro")}
                Text{font.pixelSize: 24; text: qsTr("Ry4 macro")}
            }
        }
    }
}