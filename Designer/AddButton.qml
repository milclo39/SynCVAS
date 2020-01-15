import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: _btn_add
    color: "transparent"
    z: setting.z + 1
    property string selBtnImage: "bd.png"
    property int bak_x: 0
    property int bak_y: 0
    MouseArea {
        anchors.fill: parent
        drag.target: parent
        onPressed: {
            parent.border.width = 2
            cursorShape = Qt.DragCopyCursor
            bak_x = parent.x
            bak_y = parent.y
        }
        onReleased: {
            var strSrc = "btngr_0"+state_style+".png"
            parent.border.width = 0
            cursorShape = 0
            var i = jsonobj.addObjCount()
            tmpRect.x = parent.x
            tmpRect.y = parent.y - _screen.y
            tmpRect.width = parent.width
            tmpRect.height = parent.height
            objList.model.append({"i": i
                ,"id": 0,"type": "push"
                ,"x": tmpRect.x, "y": tmpRect.y, "w": tmpRect.width, "h": tmpRect.height
                ,"text": "button", "textpos": 0
                ,"src": strSrc, "cmd": "command"
                                     ,"image": selBtnImage
            })
            // ここで登録を行う
            jsonobj.setRect(i, tmpRect)
            jsonobj.setType(i, "push")
            jsonobj.setText(i, "button")
            jsonobj.setTextPos(i, 0)
            jsonobj.setSrc(i, "btngr_01.png")
            jsonobj.setCmd(i, "command")
            jsonobj.setImage(i, selBtnImage)
            parent.x = bak_x
            parent.y = bak_y
        }
    }
}
