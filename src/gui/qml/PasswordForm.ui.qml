import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    width: 500
    height: 250
    property alias pass_label: pass_label
    property alias input_pass: input_pass
    property alias btn_return: btn_return
    property alias btn_cancel: btn_cancel
    property alias prompt_info: prompt_info
    Label {
        id: pass_label
        x: 70
        y: 66
        text: qsTr("密码：")
    }

    Button {
        id: btn_return
        x: 136
        y: 145
        text: qsTr("确认")
    }

    Label {
        id: prompt_info
        x: 70
        y: 116
        text: qsTr("提示信息")
    }

    TextField {
        id: input_pass
        x: 136
        y: 55
        width: 237
        height: 40
        text: qsTr("")
    }

    Button {
        id: btn_cancel
        x: 273
        y: 145
        text: qsTr("取消")
    }
}
