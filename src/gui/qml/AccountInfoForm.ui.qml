import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias switch_keylock: switch_keylock
    property alias wallet_id: wallet_id
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
        text: switch_showkey.checked ? keyshowstr : keyhidestr
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
        x: 27
        y: 305
        text: checked?qsTr("钱包已加密"):qsTr("钱包未加密")
        enabled: false
        autoExclusive: false
        checked: app.walletIsEncrypted
    }

    CheckBox {
        x: 139
        y: 305
        text: checked?qsTr("私钥密码(支付密码)已设置"):qsTr("私钥密码(支付密码)未设置")
        enabled: false
        autoExclusive: false
        checked: app.accountKeyIsLocked
    }
    Switch {
        id: switch_keylock
        x: 338
        y: 305
        visible: app.accountKeyIsLocked
        text: checked?qsTr("私钥(支付密码)锁定"):qsTr("私钥密码(支付密码)已解锁")
        enabled: true
        autoExclusive: false
        checked: keylocked
    }
}
