import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    width: 400
    height: 400
    property alias passtext: input_pass
    property alias btn_return: btn_return
    Label {
        id: label
        x: 49
        y: 157
        text: qsTr("钱包密码：")
    }

    TextInput {
        id: input_pass
        x: 126
        y: 157
        width: 80
        height: 20
        text: qsTr("Text Input")
        font.pixelSize: 12
    }

    Button {
        id: btn_return
        x: 262
        y: 146
        text: qsTr("确认")
    }

    Label {
        id: prompt_info
        x: 49
        y: 220
        text: qsTr("提示信息")
    }
}
