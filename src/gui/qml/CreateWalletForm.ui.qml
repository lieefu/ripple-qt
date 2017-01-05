import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
Item {
    property alias btn_save: btn_save
    property alias btn_generator: btn_generator
    property alias wallet_id: wallet_id
    property alias wallet_key: wallet_key
    property alias textField1: textField1
    property alias button1: button1
    property string showkey: qsTr("wallet key.")
    property string hidekey: qsTr("wallet key")
    property bool generateWallet: false
    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.top: parent.top

        TextField {
            id: textField1
            placeholderText: qsTr("Text Field")
            echoMode: TextInput.Password
            selectByMouse: true
        }

        Button {
            id: button1
            text: qsTr("Press Me")
        }
    }

    Button {
        id: btn_generator
        x: 486
        y: 86
        text: qsTr("钱包生成器")
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
        x: 92
        y: 251
        text: qsTr("保存到钱包文件")
        enabled: !app.existWallet && generateWallet
    }
}
