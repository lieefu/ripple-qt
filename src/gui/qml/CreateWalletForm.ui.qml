import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias btn_save: btn_save
    property alias btn_generator: btn_generator
    property alias wallet_id: wallet_id
    property alias wallet_key: wallet_key
    property string showkey: qsTr("wallet key.")
    property string hidekey: qsTr("wallet key")
    property bool generateWallet: false
    property alias btn_key: btn_key
    property alias textField: textField
    property alias btn_text: btn_text
    property alias prompt_info: prompt_info

        TextField {
            id: textField
            x: 59
            y: 20
            width: 300
            placeholderText: qsTr("Text Field")
            selectByMouse: true
        }
        Button {
            id: btn_key
            x: 375
            y: 20
            text: qsTr("私钥导入")
        }
        Button {
            id: btn_text
            x: 486
            y: 20
            text: qsTr("文本生成(脑钱包)")
        }

    Button {
        id: btn_generator
        x: 110
        y: 66
        width: 420
        height: 40
        text: qsTr("钱包随机生成器")
    }

    Label {
        id: label
        x: 92
        y: 121
        text: qsTr("钱包地址：")
        renderType: Text.QtRendering
    }

    Label {
        id: label1
        x: 112
        y: 166
        text: qsTr(" 私钥：")
    }

    TextArea {
        id: wallet_id
        x: 173
        y: 113
        text: qsTr("wallet address")
        readOnly: true
        selectByMouse: true
    }

    TextArea {
        id: wallet_key
        x: 167
        y: 162
        text: switch1.checked ? showkey : hidekey
        readOnly: true
        selectByMouse: true
    }

    Switch {
        id: switch1
        x: 486
        y: 158
        width: 123
        height: 14
        text: qsTr("显示私钥")
    }

    Button {
        id: btn_save
        x: 430
        y: 239
        text: qsTr("保存到钱包文件")
        enabled: !app.existWallet && generateWallet
    }

    Label {
        id: prompt_info
        x: 92
        y: 222
        text: qsTr("提示信息")
    }
}
