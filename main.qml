import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Network 1.0
import JsonObj 1.0

ApplicationWindow {
    id: _root
    visible: true
    width: scrWidth; height: scrHeight
    title: "Cvas Controller"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

    property int pxport: 5136
    property int pjport: 4352
    property int scrWidth: 1024//800
    property int scrHeight: 600//480
    property int i: 0

    Component.onCompleted: {
        for(i = 0; i < jsonobj.getObjCount(); i++){
            switch(jsonobj.getType(i)){
            case "group":   // グループ
                frmobj.model.append({"id": jsonobj.getId(i),"type": jsonobj.getType(i)
                    ,"x": jsonobj.getRect(i).x, "y": jsonobj.getRect(i).y
                    ,"w": jsonobj.getRect(i).width, "h": jsonobj.getRect(i).height
                    ,"text": jsonobj.getText(i), "textpos": jsonobj.getTextPos(i)
                    ,"backcolor": "transparent"
                    ,"src": jsonobj.getSrc(i), "cmd": jsonobj.getCmd(i)
                })
                break;
            case "text":    // テキスト
                textobj.model.append({"id": jsonobj.getId(i),"type": jsonobj.getType(i)
                    ,"x": jsonobj.getRect(i).x, "y": jsonobj.getRect(i).y
                    ,"w": jsonobj.getRect(i).width, "h": jsonobj.getRect(i).height
                    ,"text": jsonobj.getText(i), "textpos": jsonobj.getTextPos(i)
                })
                break;
            case "slider":  // スライダー
                sliderobj.model.append({"id": jsonobj.getId(i),"type": jsonobj.getType(i)
                    ,"x": jsonobj.getRect(i).x, "y": jsonobj.getRect(i).y
                    ,"w": jsonobj.getRect(i).width, "h": jsonobj.getRect(i).height
                    ,"text": jsonobj.getText(i), "textpos": jsonobj.getTextPos(i)
                })
                break;
            default:    // ボタン
                btnobj.model.append({"id": jsonobj.getId(i),"type": jsonobj.getType(i)
                    ,"x": jsonobj.getRect(i).x, "y": jsonobj.getRect(i).y
                    ,"w": jsonobj.getRect(i).width, "h": jsonobj.getRect(i).height
                    ,"text": jsonobj.getText(i), "textpos": jsonobj.getTextPos(i)
                    ,"image": jsonobj.getImage(i), "imagepos": jsonobj.getImagePos(i)
                    ,"src": jsonobj.getSrc(i), "cmd": jsonobj.getCmd(i)
                })
                break;
            }
        }
    }
    Network { id: network }
    JsonObj { id: jsonobj }
    onClosing: {
        network.setIpaddr(txtIpaddr.text)
        network.setMacaddr(txtMacaddr.text)
        network.close()
    }
    // 背景
    Image{ anchors.fill: parent; source: "qrc:/background.png" }
//    Image{ anchors.fill: parent; source: "file:///sdcard/back.png" }
    // 枠
    Repeater {
        id: frmobj
        model: ListModel {}
        Rectangle {
            color: "transparent"
            border.width: 1
            x: model.x; y: model.y; width: model.w; height: model.h
            radius: 10
//            MouseArea { anchors.fill: parent; drag.target: parent } // D&Dで動かす
        }
    }
    // オブジェクト列挙
    Repeater {
        id: btnobj
        model: ListModel {}
        Rectangle {
            color: "transparent"
            x: model.x; y: model.y; width: model.w; height: model.h
            Image{  // dynamic（領域に合わせてリサイズ）
                visible: true
                anchors.fill: parent
                source: model.src
            }
            Image{  // static（画像サイズそのまま）
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter;
                source: model.image
            }
            Text{   // 文字
                id: text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: if(model.textpos === 0) parent.verticalCenter
                anchors.bottom: if(model.textpos === 2) parent.bottom
                text: model.text
                font.pixelSize: 24
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
//                drag.target: parent
                onClicked: {
                    if(model.cmd !== ""){
                        network.connectToHost(txtIpaddr.text, pxport)
                        network.write(model.cmd)
                        //network.wakeOnLan(txtIpaddr.text, txtMacaddr.text)
                    }
                    else{
                        jsonobj.execMacro(model.id)
                    }
                }
                onHoveredChanged: {parent.opacity = containsMouse? 0.6 : 1}
                onPressed: {parent.scale = 1.1}
                onReleased: {parent.scale = 1.0}
            }
        }
    }
    // スライダー
    Repeater {
        id: sliderobj
        model: ListModel {}
        Rectangle {
            color: "lightgray"
            x: model.x; y: model.y; width: model.w; height: model.h
            border.width: 1
//            MouseArea{ anchors.fill: parent; drag.target: parent } // D&Dで動かす
            RowLayout{
                id: volumebar
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter;
                Text{text: model.text}
                Slider {
                    id:slider
                    Layout.fillWidth: true
                    from: 0;to: 10;stepSize: 1;value: 5
                    onPositionChanged: {
                        network.connectToHost(txtIpaddr.text, pxport)
                        network.write("{\"audio volume\":"+value+"}")
                    }
                    hoverEnabled: true
                    handle: Rectangle { // スライダーつまみの色変えテク
                      x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                      y: slider.topPadding + slider.availableHeight / 2 - height / 2
                      implicitWidth: 26
                      implicitHeight: 26
                      radius: 13
                      color: if(mutebtn.state !== "on") "deepskyblue"
                            else "lightgray"
                      border.color: if(mutebtn.state !== "on") "darkblue"
                            else "lightgray"
                    }
                }
                // ボリューム表示
                Text{text: slider.value}
                // ミュートボタン
                Rectangle {
                    id: mutebtn
                    color: "transparent"
                    width: 32; height: 32
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            network.connectToHost(txtIpaddr.text, pxport)
                            if(mutebtn.state === "on"){
                                network.write("{\"audio volume\":"+slider.value+"}")
                                slider.enabled = true
                                mutebtn.state = "off"
                            }
                            else{
                                network.write("{\"audio volume\":0}")
                                slider.enabled = false
                                mutebtn.state = "on"
                            }
                        }
                        Image{
                            anchors.fill: parent
                            source: if(mutebtn.state !== "on"){"qrc:/mt0.png"}
                                    else{"qrc:/mt1.png"}
                        }
                        onHoveredChanged: {
                            parent.opacity = containsMouse? 0.6 : 1
                        }
                    }
                    states: [
                        State {name: "on"},
                        State {name: "off"}
                    ]
                }
            }
        }
    }
    // フレーム/テキスト
    Repeater {
        id: textobj
        model: ListModel {}
        Rectangle {
            color: "transparent"
            x: model.x; y: model.y; width: model.w; height: model.h
//            MouseArea { anchors.fill: parent; drag.target: parent } // D&Dで動かす
            Text{   // 文字
                visible: model.type === "text"
                anchors.fill: parent
                text: model.text
                font.pixelSize: 24
                color: "black"
            }
        }
    }
    // 設定画面
    Rectangle{
        id: setting
        visible: false
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            drag.target: parent
        }
        Column {
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Row{
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "IP Address:"
                }
                TextField {
                    id: txtIpaddr
                    width: 200
                    font.pointSize: 16
                    placeholderText: qsTr("*.*.*.*")
                    selectByMouse: true
                    text: network.getIpaddr()
                }
            }
            Row{
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "MAC Address:"
                }
                TextField {
                    id: txtMacaddr
                    width: 200
                    font.pointSize: 16
                    placeholderText: qsTr("************")
                    selectByMouse: true
                    text: network.getMacaddr()
                }
            }
        }
        // 終了
        Image {
            id: endbtn
            anchors.right: parent.right
            anchors.top: parent.top
            source: "qrc:/end.png"
            width: 60; height: 60
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    _root.close()
                }
                onHoveredChanged: {parent.opacity = containsMouse? 0.6 : 1}
                onPressed: {parent.scale = 1.2}
                onReleased: {parent.scale = 1.0}
            }
        }
    }
    // 設定ボタン
    Image{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        source: "qrc:/setting.png"
        z: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(setting.visible){
                    setting.visible = false
                }
                else{
                    setting.visible = true
                }
            }
            onHoveredChanged: {parent.opacity = containsMouse? 0.6 : 1}
            onPressed: {parent.scale = 1.1}
            onReleased: {parent.scale = 1.0}
        }
    }
}
