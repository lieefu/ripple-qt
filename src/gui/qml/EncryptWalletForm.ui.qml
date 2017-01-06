import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    width: 500
    height: 250
    property alias prompt_info: prompt_info
    property alias input_pass1: input_pass1
    property alias input_pass2: input_pass2
    property alias btn_return: btn_return
    Label {
        id: label
        x: 73
        y: 78
        text: qsTr("钱包密码：")
    }

    TextField {
        id: input_pass1
        x: 163
        y: 67
    }

    Button {
        id: btn_return
        x: 384
        y: 112
        text: qsTr("确认")
    }

    Label {
        id: label1
        x: 25
        y: 123
        text: qsTr("再次输入钱包密码：")
    }

    TextField {
        id: input_pass2
        x: 163
        y: 112
    }

    Label {
        id: prompt_info
        x: 34
        y: 198
        text: qsTr("提示信息")
    }


}
