import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    width: 500
    height: 250
    property alias pass_label: pass_label
    property alias input_pass: input_pass
    property alias btn_return: btn_return
    property alias prompt_info: prompt_info
    Label {
        id: pass_label
        x: 49
        y: 81
        text: qsTr("密码：")
    }

    Button {
        id: btn_return
        x: 361
        y: 70
        text: qsTr("确认")
    }

    Label {
        id: prompt_info
        x: 49
        y: 133
        text: qsTr("提示信息")
    }

    TextField {
        id: input_pass
        x: 115
        y: 70
        text: qsTr("")
    }
}
