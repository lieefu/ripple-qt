import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias wallet_id: wallet_id
    property string showkeystr: qsTr("wallet key.")
    property string hidekeystr: qsTr("*************")
    property alias switch_showkey: switch_showkey
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
        text: switch_showkey.checked ? showkeystr : hidekeystr
        readOnly: true
        selectByMouse: true
    }

    Switch {
        id: switch_showkey
        x: 486
        y: 158
        width: 123
        height: 14
        text: qsTr("显示私钥")
    }

    CheckBox {
        x: 134
        y: 290
        text: checked?qsTr("钱包已加密"):qsTr("钱包未加密")
        enabled: false
        autoExclusive: false
        checkable: false
        checked: app.walletIsEncrypted
    }

    CheckBox {
        x: 243
        y: 290
        text: checked?qsTr("秘钥已锁定(支付密码)"):qsTr("秘钥未锁定(支付密码)")
        enabled: false
        autoExclusive: false
        checkable: false
        checked: account.lock
    }
}
