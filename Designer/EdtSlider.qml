import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: _objSlider
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
        curImageFrame = _objSlider;
        curImageFrame.z = 2
        curImageMimi = frame;
        curImageMimi.visible = true
    }
    function setFrameRect() {
        tmpRect.x = _objSlider.x
        tmpRect.y = _objSlider.y
        tmpRect.width = _objSlider.width
        tmpRect.height = _objSlider.height
        jsonobj.setRect(model.i, tmpRect)
    }
    Rectangle{
        anchors.fill: parent
        color: "silver"
        Image{anchors.centerIn: parent; source: "slider.png"}
    }
    Text {  // ボタン名称
        id: text
        anchors.margins: 5
        text: model.text
        font.pixelSize: 24
        color: "white"
    }

    PinchArea {
        anchors.fill: parent
        pinch.target: _objSlider
        pinch.minimumRotation: -360
        pinch.maximumRotation: 360
        pinch.minimumScale: 0.1
        pinch.maximumScale: 10
        onPinchStarted: _objSlider.setFrameColor();
        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent
            drag.target: _objSlider
            onPressed: {
                _objSlider.setFrameColor();
                frame.border.width = 2
            }
            onPositionChanged: {
                if(pressed){
                    if(_objSlider.x > _screen.width - _objSlider.width) _objSlider.x = _screen.width - _objSlider.width
                    else if(_objSlider.x < 0) _objSlider.x = 0
                    if(_objSlider.y > _screen.height - _objSlider.height) _objSlider.y = _screen.height - _objSlider.height
                    else if(_objSlider.y < 0) _objSlider.y = 0
                }
            }
            onReleased: {
                _objSlider.setFrameRect()
                frame.border.width = 0
            }
            onDoubleClicked: {
                console.log("dohaodoahfo")
            }
            onWheel: {  //ホイール動作
                _objSlider.width += wheel.angleDelta.y / 120
                _objSlider.height += wheel.angleDelta.y / 120
            }
            onHoveredChanged: { //ホバー動作
                _objSlider.opacity = containsMouse? 0.6 : 1
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
                    if(_objSlider.width - mouseX > width * 2){
                        _objSlider.x += mouseX;
                        _objSlider.width -= mouseX;
                    }
                    if(_objSlider.height - mouseY > height * 2){
                        _objSlider.y += mouseY;
                        _objSlider.height -= mouseY;
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
                    if(_objSlider.height - mouseY > height * 2){
                        _objSlider.y += mouseY;
                        _objSlider.height -= mouseY;
                    }
                }
                onReleased: _objSlider.setFrameRect()
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
                    if(_objSlider.width + mouseX > width * 2){
                        _objSlider.width += mouseX;
                    }
                    if(_objSlider.height + mouseY> height * 2){
                        _objSlider.y += mouseY;
                        _objSlider.height -= mouseY;
                    }
                }
                onReleased: _objSlider.setFrameRect()
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
                    if(_objSlider.width - mouseX > width * 2){
                        _objSlider.x += mouseX;
                        _objSlider.width -= mouseX;
                    }
                }
                onReleased: _objSlider.setFrameRect()
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
                    if(_objSlider.width + mouseX > width * 2){
                        _objSlider.width += mouseX;
                    }
                }
                onReleased: _objSlider.setFrameRect()
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
                    if(_objSlider.width - mouseX > width * 2){
                        _objSlider.x += mouseX;
                        _objSlider.width -= mouseX;
                    }
                    if(_objSlider.height + mouseY > height * 2){
                        _objSlider.height += mouseY;
                    }
                }
                onReleased: _objSlider.setFrameRect()
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
                    if(_objSlider.height + mouseY > height * 2){
                        _objSlider.height += mouseY;
                    }
                }
                onReleased: _objSlider.setFrameRect()
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
                    if(_objSlider.width + mouseX > width * 2){
                        _objSlider.width += mouseX;
                    }
                    if(_objSlider.height + mouseY > height * 2){
                        _objSlider.height += mouseY;
                    }
                }
                onReleased: _objSlider.setFrameRect()
            }
        }
    }
}
