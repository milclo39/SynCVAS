import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1
import Helper 1.0
import JsonObj 1.0

ApplicationWindow {
    id: _root
    visible: true
    width: 800; height: 600
    title: "SynCVAS Designer"

    property int pxport: 5136
    property int pjport: 4352
    property int btnsize: 200
    property int i: 0
    property int mimisize: 8
    property string mimicolor: "navy"
    property rect tmpRect;
    property string nonselcolor: "skyblue"
    property string selectcolor: "blue"

    //プロパティ
    property variant path: []
    property int highestZ: 0
    property real defaultSize: 100
    property var curImageFrame: undefined
    property var curImageMimi: undefined
    property string curIpAddr: setting.curIpAddr
    property string curMacAddr: setting.curMacAddr

    Component.onCompleted: {
        for(i = 0; i < jsonobj.getObjCount(); i++){
            switch(jsonobj.getType(i)){
            case "group":   // グループ
                frmobj.model.append({"i": i
                    ,"id": jsonobj.getId(i),"type": jsonobj.getType(i)
                    ,"x": jsonobj.getRect(i).x, "y": jsonobj.getRect(i).y
                    ,"w": jsonobj.getRect(i).width, "h": jsonobj.getRect(i).height
                    ,"text": jsonobj.getText(i), "textpos": jsonobj.getTextPos(i)
                    ,"src": jsonobj.getSrc(i), "cmd": jsonobj.getCmd(i)
                })
                break;
            case "text":    // テキスト
                textobj.model.append({"i": i
                    ,"id": jsonobj.getId(i),"type": jsonobj.getType(i)
                    ,"x": jsonobj.getRect(i).x, "y": jsonobj.getRect(i).y
                    ,"w": jsonobj.getRect(i).width, "h": jsonobj.getRect(i).height
                    ,"text": jsonobj.getText(i), "textpos": jsonobj.getTextPos(i)
                })
                break;
            case "slider":  // スライダー
                sliderobj.model.append({"i": i
                    ,"id": jsonobj.getId(i),"type": jsonobj.getType(i)
                    ,"x": jsonobj.getRect(i).x, "y": jsonobj.getRect(i).y
                    ,"w": jsonobj.getRect(i).width, "h": jsonobj.getRect(i).height
                    ,"text": jsonobj.getText(i), "textpos": jsonobj.getTextPos(i)
                })
                break;
            default:
                objList.model.append({"i": i
                    ,"id": jsonobj.getId(i),"type": jsonobj.getType(i)
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
    Helper { id: helper }
    JsonObj { id: jsonobj }
    onClosing: {
    }
    // モードメニュー
    RowLayout{
        id: modemenu
//        anchors.left: parent.left; anchors.top: parent.top
        width: parent.width; height: 30
        state: "DESIGN"
        Rectangle{Layout.fillHeight: true;Layout.fillWidth: true
            color: if(modemenu.state === "DESIGN") {"blue"} else {"black"}
            Text{anchors.centerIn: parent; text:"DESIGN"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {modemenu.state = "DESIGN"}}
        }
        Rectangle{Layout.fillHeight: true;Layout.fillWidth: true
            color: if(modemenu.state === "DEVICE") {"blue"} else {"black"}
            Text{anchors.centerIn: parent; text:"DEVICE"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {modemenu.state = "DEVICE"}}
        }
        Rectangle{Layout.fillHeight: true;Layout.fillWidth: true
            color: if(modemenu.state === "PREVIEW") {"blue"} else {"black"}
            Text{anchors.centerIn: parent; text:"PREVIEW"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {modemenu.state = "PREVIEW"}}
        }
        Rectangle{Layout.fillHeight: true;Layout.fillWidth: true
            color: if(modemenu.state === "SYSTEM") {"blue"} else {"black"}
            Text{anchors.centerIn: parent; text:"SYSTEM"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {modemenu.state = "SYSTEM"}}
        }
        onStateChanged: {
            helper.execProcess(modemenu.state === "PREVIEW")    // プレビュー実行
        }
        states: [
            State {name: "DESIGN"},
            State {name: "DEVICE"},
            State {name: "PREVIEW"},
            State {name: "SYSTEM"}
        ]
    }
    // トップメニュー
    RowLayout{
        id: topmenu
        anchors.top: modemenu.bottom
        anchors.topMargin: 5
        width: parent.width; height: 50
        Rectangle{id: btn_1; Layout.fillHeight: true; Layout.fillWidth: true; color: "silver"
            Text{anchors.centerIn: parent;text:"Create"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {}}
        }
        Rectangle{id: btn_2; Layout.fillHeight: true; Layout.fillWidth: true; color: "silver"
            Text{anchors.centerIn: parent;text:"Import"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {}}
        }
        Rectangle{id: btn_3; Layout.fillHeight: true; Layout.fillWidth: true; color: "silver"
            Text{anchors.centerIn: parent;text:"Export"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {}}
        }
        Rectangle{id: btn_4; Layout.fillHeight: true; Layout.fillWidth: true; color: "silver"
            Text{anchors.centerIn: parent;text:"Add\nPage"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {}}
        }
        Rectangle{id: btn_5; Layout.fillHeight: true; Layout.fillWidth: true; color: "silver"
            Text{anchors.centerIn: parent;text:"Remove\nPage"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {}}
        }

        Rectangle{id: btn_style; Layout.fillHeight: true; Layout.fillWidth: true
            color: if(topmenu.state === "Style") {selectcolor} else {nonselcolor}
            Text{anchors.centerIn: parent;text:"Style"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {topmenu.state = "Style"}}
        }
        Rectangle{id: btn_bground; Layout.fillHeight: true;Layout.fillWidth: true
            color: if(topmenu.state === "BackGround") {selectcolor} else {nonselcolor}
            Text{anchors.centerIn: parent; text:"Back\nGround"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {topmenu.state = "BackGround"}}
        }
        Rectangle{id: btn_button; Layout.fillHeight: true;Layout.fillWidth: true
            color: if(topmenu.state === "Button") {selectcolor} else {nonselcolor}
            Text{anchors.centerIn: parent; text:"Button"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {topmenu.state = "Button"}}
        }
        Rectangle{id: btn_text; Layout.fillHeight: true;Layout.fillWidth: true
            color: if(topmenu.state === "Text") {selectcolor} else {nonselcolor}
            Text{anchors.centerIn: parent; text:"Text"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {topmenu.state = "Text"}}
        }
        Rectangle{id: btn_slide; Layout.fillHeight: true;Layout.fillWidth: true
            color: if(topmenu.state === "Slide") {selectcolor} else {nonselcolor}
            Text{anchors.centerIn: parent; text:"Slide"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {topmenu.state = "Slide"}}
        }
        Rectangle{id: btn_frame; Layout.fillHeight: true;Layout.fillWidth: true
            color: if(topmenu.state === "Group") {selectcolor} else {nonselcolor}
            Text{anchors.centerIn: parent; text:"Group"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {topmenu.state = "Group"}}
        }
        states: [
            State {name: "Style"},
            State {name: "BackGround"},
            State {name: "Button"},
            State {name: "Text"},
            State {name: "Slide"},
            State {name: "Group"}
        ]
    }
    // スタイルサブメニュー
    Rectangle{
        id: stylemenu
        anchors.top: topmenu.bottom; anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        width: 540; height: 72
        visible: topmenu.state === "Style"
        RowLayout{
            anchors.fill: parent
            Image{source: "btngr_01.png"}
            Image{source: "btngr_02.png"}
            Image{source: "btngr_03.png"}
            Image{source: "btngr_04.png"}
            Image{source: "btngr_05.png"}
            Image{source: "btngr_06.png"}
        }
    }
    // 背景サブメニュー   
    Rectangle{
        id: backmenu
        anchors.top: topmenu.bottom; anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        width: 216; height: 72
        visible: topmenu.state === "BackGround"
        RowLayout{
            Rectangle{width: 72; height: 72; color: "pink"; Text{anchors.centerIn: parent; text:"Single"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {backimage.source = ""}}}
            Rectangle{width: 72; height: 72; color: "white"; Image{anchors.fill: parent; source: "background.png"}
            MouseArea{anchors.fill: parent; onClicked: {backimage.source = "background.png"}}}
            Rectangle{width: 72; height: 72; color: "pink"; Text{anchors.centerIn: parent; text:"File"; color: "white"}
            MouseArea{anchors.fill: parent; onClicked: {console.log("file!")}}}
        }
    }
    // ボタンメニュー
    Rectangle{
        id: submenu
        anchors.top: topmenu.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        width: 600; height: 72
        visible: topmenu.state === "Button"
        RowLayout{
            Image{id: btn_pageprev; source: "pageprev.png"}
            Rectangle{width: 72; height: 72; color: "pink"; Image{id: btn_bd; source: "bd.png"}}
            Rectangle{width: 72; height: 72; color: "pink"; Image{id: btn_cam; source: "cam.png"}}
            Rectangle{width: 72; height: 72; color: "pink"; Image{id: btn_dvi; source: "dvi.png"}}
            Rectangle{width: 72; height: 72; color: "pink"; Image{id: btn_hdmi; source: "hdmi.png"}}
            Rectangle{width: 72; height: 72; color: "pink"; Image{id: btn_pc; source: "pc.png"}}
            Rectangle{width: 72; height: 72; color: "pink"; Image{id: btn_rgb; source: "rgb.png"}}
            Image{id: btn_pagenext; source: "pagenext.png"}
            Image{id: btn_plus; source: "plus.png"}
        }
    }
    // 追加ボタン
    AddButton{x: 160; y: submenu.y; width: btn_bd.width; height: 72; selBtnImage: btn_bd.source; visible: submenu.visible}
    AddButton{x: 240; y: submenu.y; width: btn_cam.width; height: 72; selBtnImage: btn_cam.source; visible: submenu.visible}
    AddButton{x: 320; y: submenu.y; width: btn_dvi.width; height: 72; selBtnImage: btn_dvi.source; visible: submenu.visible}
    AddButton{x: 400; y: submenu.y; width: btn_hdmi.width; height: 72; selBtnImage: btn_hdmi.source; visible: submenu.visible}
    AddButton{x: 480; y: submenu.y; width: btn_pc.width; height: 72; selBtnImage: btn_pc.source; visible: submenu.visible}
    AddButton{x: 560; y: submenu.y; width: btn_rgb.width; height: 72; selBtnImage: btn_rgb.source; visible: submenu.visible}

    // テキストメニュー
    Rectangle{
        id: submenutext
        anchors.top: topmenu.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        width: 300; height: 72
        color: "pink"
        visible: topmenu.state === "Text"
        Text{anchors.centerIn: parent; text: "I am Text. Drag me!"}
    }
    // 追加テキスト
    AddText{x: 160; y: submenutext.y; width: submenutext.width; height: 72; visible: submenutext.visible}

    // スライダーメニュー
    Rectangle{
        id: submenuslider
        anchors.top: topmenu.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        width: 300; height: 72
        visible: topmenu.state === "Slide"
        color: "pink"
        Text{anchors.centerIn: parent; text: "I am Slider. Drag me!"}
    }
    // 追加テキスト
    AddSlider{x: 160; y: submenuslider.y; width: submenuslider.width; height: 72; visible: submenuslider.visible}

    // グループメニュー
    Rectangle{
        id: submenugroup
        anchors.top: topmenu.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        width: 300; height: 72
        visible: topmenu.state === "Group"
        color: "pink"
        Text{anchors.centerIn: parent; text: "I am Group. Drag me!"}
    }
    // 追加テキスト
    AddGroup{x: 160; y: submenugroup.y; width: submenugroup.width; height: 72; visible: submenugroup.visible}

    Rectangle{
        anchors.left: _screen.right
        anchors.top: _screen.top
        width: parent.width - _screen.width
        height: 32
        color: "silver"
        Text{
            anchors.centerIn: parent
            text: "1"
            color: "white"
        }
    }
    // スクリーン
    Rectangle{
        id: _screen
        x: 0; y: 120
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 768; height: 432
        // 背景
        Image{ id: backimage; anchors.fill: parent; source: "qrc:/background.png" }
        MouseArea {
            anchors.fill: parent
            onPressed: {    // 背景を触ったら選択解除
                if (curImageFrame){
                    curImageMimi.visible = false
                    curImageFrame = null
                    curImageMimi = null
                }
            }
        }
        // オブジェクト列挙
        Repeater {
            id: frmobj
            model: ListModel {}
            EdtText{
                id: _objFrame
            }
        }
        Repeater {
            id: textobj
            model: ListModel {}
            EdtText{
                id: _objText
            }
        }
        Repeater {
            id: sliderobj
            model: ListModel {}
            EdtText{
                id: _objSlide
            }
        }
        Repeater {
            id: objList
            model: ListModel {}
            EdtButton{
                id: _obj
            }
        }
    }
    // 機器設定
    Rectangle{
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height - modemenu.height
        visible: modemenu.state === "DEVICE"
        z: 100
        Text{anchors.centerIn: parent; text: "device"}
    }
    // プレビュー
    Rectangle{
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height - modemenu.height
        visible: modemenu.state === "PREVIEW"
        z: 100
        Text{anchors.centerIn: parent; text: "preview running..."}
    }
    // 設定画面
    Setting{
        id: setting
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height - modemenu.height
        visible: modemenu.state === "SYSTEM"
        z: 100
    }
}
