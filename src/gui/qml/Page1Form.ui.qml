import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias wallet_id: wallet_id
    property string showkeystr: qsTr("wallet key.")
    property string hidekeystr: qsTr("*************")
    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.top: parent.top
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
        text: switch1.checked ? showkeystr : hidekeystr
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

    RadioButton {
        id: radio_walletencypt
        x: 134
        y: 290
        text: qsTr("钱包加密")
        checkable: false
        checked: app.walletIsEncrypted
    }

    RadioButton {
        id: radioButton
        x: 243
        y: 290
        text: qsTr("秘钥锁定(支付密码)")
        checkable: false
        checked: app.accountIsLocked
    }
}
