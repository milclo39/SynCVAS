import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    signal sigDoubleClicked()
    id: _obj
    color: if(model.src !== "") {"transparent"} else {"blue"}
    x: model.x; y: model.y; width: model.w; height: model.h
    //smooth: true; antialiasing: true
    function setFrameColor() {
        //前の選択を非表示
        if (curImageFrame){
            curImageMimi.visible = false
            curImageFrame.z = 1
        }
        //選択されたフレームにフォーカス
        curImageFrame = _obj;
        curImageFrame.z = 2
        curImageMimi = frame;
        curImageMimi.visible = true
    }
    function setFrameRect() {
        tmpRect.x = _obj.x
        tmpRect.y = _obj.y
        tmpRect.width = _obj.width
        tmpRect.height = _obj.height
        jsonobj.setRect(model.i, tmpRect)
    }
    Image { // 背景ボタン
        anchors.fill: parent
        source: model.src
    }
    Image{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: model.image
    }
    Text {  // ボタン名称
        id: text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: if(model.textpos === 0) parent.verticalCenter
        anchors.bottom: if(model.textpos === 2) parent.bottom
        anchors.margins: 5
        text: model.text
        font.pixelSize: 24
        color: "white"
    }
    MouseArea { //右クリック判定
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: if (mouse.button === Qt.RightButton) menu.popup(mouse.x, mouse.y) 
        onPressAndHold: if (mouse.source === Qt.MouseEventNotSynthesized) menu.popup(mouse.x, mouse.y)
    }
    Menu {    // 右クリックメニュー
        id: menu
        MenuItem { text: qsTr("Cut"); onTriggered: {console.log("Cut")} }
        MenuItem { text: qsTr("Copy"); onTriggered: {console.log("Copy")} }
        MenuItem { text: qsTr("Paste"); onTriggered: {console.log("Paste")} }
        MenuItem { text: qsTr("Delete"); onTriggered: {console.log("Delete")} }
    }
    PinchArea {
        anchors.fill: parent
        pinch.target: _obj
        pinch.minimumRotation: -360
        pinch.maximumRotation: 360
        pinch.minimumScale: 0.1
        pinch.maximumScale: 10
        onPinchStarted: _obj.setFrameColor()
        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent
            drag.target: _obj
            onPressed: {
                _obj.setFrameColor()
                frame.border.width = 2
            }
            onPositionChanged: {
                if(pressed){
                    if(_obj.x > _screen.width - _obj.width) _obj.x = _screen.width - _obj.width
                    else if(_obj.x < 0) _obj.x = 0
                    if(_obj.y > _screen.height - _obj.height) _obj.y = _screen.height - _obj.height
                    else if(_obj.y < 0) _obj.y = 0
                }
            }
            onReleased: {
                _obj.setFrameRect()
                frame.border.width = 0
            }
            onClicked: {
                if(model.cmd !== "macro"){
                    jsonobj.execMacro(model.id)
                }
                else{
                    jsonobj.execMacro(model.id)
                }
            }
            onDoubleClicked: {
                sigDoubleClicked()
            }
            onWheel: {  //ホイール動作
                _obj.width += wheel.angleDelta.y / 120
                _obj.height += wheel.angleDelta.y / 120
            }
            onHoveredChanged: { //ホバー動作
                _obj.opacity = containsMouse? 0.6 : 1
            }
            focus: true
            Keys.onPressed: {   // カーソルキーで1dotづつ移動する
                if(curImageFrame){
                    switch(event.key) {
                    case Qt.Key_Left: curImageFrame.x -= 1; break;
                    case Qt.Key_Right: curImageFrame.x += 1; break;
                    case Qt.Key_Up: curImageFrame.y -= 1; break;
                    case Qt.Key_Down: curImageFrame.y += 1; break;
                    }
                    tmpRect.x = curImageFrame.x
                    tmpRect.y = curImageFrame.y
                    jsonobj.setRect(model.index, tmpRect)
                }
                event.accepted = true;
            }
        }
    }
    Rectangle {
        id: frame
        anchors.fill: parent
        color: "transparent"
        border.color: "gray"; border.width: 0
        visible: false
        Rectangle { // 左上
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeFDiagCursor
                onPositionChanged: {
                    if(_obj.width - mouseX > width * 2){
                        _obj.x += mouseX;
                        _obj.width -= mouseX;
                    }
                    if(_obj.height - mouseY > height * 2){
                        _obj.y += mouseY;
                        _obj.height -= mouseY;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
        Rectangle { // 上
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeVerCursor
                onPositionChanged: {
                    if(_obj.height - mouseY > height * 2){
                        _obj.y += mouseY;
                        _obj.height -= mouseY;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
        Rectangle { // 右上
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeBDiagCursor
                onPositionChanged: {
                    if(_obj.width + mouseX > width * 2){
                        _obj.width += mouseX;
                    }
                    if(_obj.height + mouseY> height * 2){
                        _obj.y += mouseY;
                        _obj.height -= mouseY;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
        Rectangle { // 左
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                onPositionChanged: {
                    if(_obj.width - mouseX > width * 2){
                        _obj.x += mouseX;
                        _obj.width -= mouseX;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
        Rectangle { // 右
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                onPositionChanged: {
                    if(_obj.width + mouseX > width * 2){
                        _obj.width += mouseX;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
        Rectangle { // 左下
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeBDiagCursor
                onPositionChanged: {
                    if(_obj.width - mouseX > width * 2){
                        _obj.x += mouseX;
                        _obj.width -= mouseX;
                    }
                    if(_obj.height + mouseY > height * 2){
                        _obj.height += mouseY;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
        Rectangle { // 下
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeVerCursor
                onPositionChanged: {
                    if(_obj.height + mouseY > height * 2){
                        _obj.height += mouseY;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
        Rectangle { // 右下
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: - width / 2
            width: mimisize; height: mimisize; color: mimicolor
            border.color: "white"; border.width: 1
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeFDiagCursor
                onPositionChanged: {
                    if(_obj.width + mouseX > width * 2){
                        _obj.width += mouseX;
                    }
                    if(_obj.height + mouseY > height * 2){
                        _obj.height += mouseY;
                    }
                }
                onReleased: _obj.setFrameRect()
            }
        }
    }
}
