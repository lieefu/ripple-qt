import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    width: 400
    height: 400
    property alias prompt_info: prompt_info
    property alias input_pass1: input_pass1
    property alias input_pass2: input_pass2
    property alias btn_return: btn_return
    Label {
        id: label
        x: 73
        y: 137
        text: qsTr("钱包密码：")
    }

    TextInput {
        id: input_pass1
        x: 163
        y: 137
        width: 80
        height: 20
        font.pixelSize: 12
    }

    Button {
        id: btn_return
        x: 283
        y: 160
        text: qsTr("确认")
    }

    Label {
        id: prompt_info
        x: 49
        y: 220
        text: qsTr("提示信息")
    }

    Label {
        id: label1
        x: 25
        y: 182
        text: qsTr("再次输入钱包密码：")
    }

    TextInput {
        id: input_pass2
        x: 163
        y: 181
        width: 80
        height: 20
        font.pixelSize: 12
    }
}
