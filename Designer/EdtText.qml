import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: _objText
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
        curImageFrame = _objText;
        curImageFrame.z = 2
        curImageMimi = frame;
        curImageMimi.visible = true
    }
    function setFrameRect() {
        tmpRect.x = _objText.x
        tmpRect.y = _objText.y
        tmpRect.width = _objText.width
        tmpRect.height = _objText.height
        jsonobj.setRect(model.i, tmpRect)
    }
    Rectangle { // 背景
        anchors.fill: parent
        color: "black"
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

    PinchArea {
        anchors.fill: parent
        pinch.target: _objText
        pinch.minimumRotation: -360
        pinch.maximumRotation: 360
        pinch.minimumScale: 0.1
        pinch.maximumScale: 10
        onPinchStarted: _objText.setFrameColor();
        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent
            drag.target: _objText
            onPressed: {
                _objText.setFrameColor();
                frame.border.width = 2
            }
            onPositionChanged: {
                if(pressed){
                    if(_objText.x > _screen.width - _objText.width) _objText.x = _screen.width - _objText.width
                    else if(_objText.x < 0) _objText.x = 0
                    if(_objText.y > _screen.height - _objText.height) _objText.y = _screen.height - _objText.height
                    else if(_objText.y < 0) _objText.y = 0
                }
            }
            onReleased: {
                _objText.setFrameRect()
                frame.border.width = 0
            }
            onDoubleClicked: {
                console.log("onDoubleClicked")
            }
            onWheel: {  //ホイール動作
                _objText.width += wheel.angleDelta.y / 120
                _objText.height += wheel.angleDelta.y / 120
            }
            onHoveredChanged: { //ホバー動作
                _objText.opacity = containsMouse? 0.6 : 1
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
                    if(_objText.width - mouseX > width * 2){
                        _objText.x += mouseX;
                        _objText.width -= mouseX;
                    }
                    if(_objText.height - mouseY > height * 2){
                        _objText.y += mouseY;
                        _objText.height -= mouseY;
                    }
                }
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
                    if(_objText.height - mouseY > height * 2){
                        _objText.y += mouseY;
                        _objText.height -= mouseY;
                    }
                }
                onReleased: _objText.setFrameRect()
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
                    if(_objText.width + mouseX > width * 2){
                        _objText.width += mouseX;
                    }
                    if(_objText.height + mouseY> height * 2){
                        _objText.y += mouseY;
                        _objText.height -= mouseY;
                    }
                }
                onReleased: _objText.setFrameRect()
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
                    if(_objText.width - mouseX > width * 2){
                        _objText.x += mouseX;
                        _objText.width -= mouseX;
                    }
                }
                onReleased: _objText.setFrameRect()
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
                    if(_objText.width + mouseX > width * 2){
                        _objText.width += mouseX;
                    }
                }
                onReleased: _objText.setFrameRect()
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
                    if(_objText.width - mouseX > width * 2){
                        _objText.x += mouseX;
                        _objText.width -= mouseX;
                    }
                    if(_objText.height + mouseY > height * 2){
                        _objText.height += mouseY;
                    }
                }
                onReleased: _objText.setFrameRect()
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
                    if(_objText.height + mouseY > height * 2){
                        _objText.height += mouseY;
                    }
                }
                onReleased: _objText.setFrameRect()
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
                    if(_objText.width + mouseX > width * 2){
                        _objText.width += mouseX;
                    }
                    if(_objText.height + mouseY > height * 2){
                        _objText.height += mouseY;
                    }
                }
                onReleased: _objText.setFrameRect()
            }
        }
    }
}
