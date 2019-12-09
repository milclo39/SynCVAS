import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: _group_add
    color: "transparent"
    z: setting.z + 1
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
            parent.border.width = 0
            cursorShape = 0
            var i = jsonobj.addObjCount()
            tmpRect.x = parent.x
            tmpRect.y = parent.y - _screen.y
            tmpRect.width = parent.width
            tmpRect.height = parent.height
            textobj.model.append({"i": i
                ,"id": i,"type": "group"
                ,"x": tmpRect.x, "y": tmpRect.y, "w": tmpRect.width, "h": tmpRect.height
                ,"text": "", "textpos": 0
            })
            // ここで登録を行う
            jsonobj.setRect(i, tmpRect)
            jsonobj.setType(i, "group")
            jsonobj.setText(i, "")
            jsonobj.setTextPos(i, 0)
            parent.x = bak_x
            parent.y = bak_y
        }
    }
}
