import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    width: 500
    height: 250
    property alias passtext: input_pass
    property alias btn_return: btn_return
    Label {
        id: label
        x: 49
        y: 94
        text: qsTr("钱包密码：")
    }

    TextInput {
        id: input_pass
        x: 126
        y: 94
        width: 80
        height: 20
        text: qsTr("Text Input")
        font.pixelSize: 12
    }

    Button {
        id: btn_return
        x: 262
        y: 83
        text: qsTr("确认")
    }

    Label {
        id: prompt_info
        x: 49
        y: 157
        text: qsTr("提示信息")
    }
}
