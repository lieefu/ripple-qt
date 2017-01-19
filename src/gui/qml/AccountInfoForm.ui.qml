import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias switch_keylock: switch_keylock
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
        y: 217
        text: qsTr(" 私钥：")
    }

    TextArea {
        id: wallet_id
        x: 167
        y: 118
        text: account.id
        readOnly: true
        selectByMouse: true
    }

    TextArea {
        id: wallet_key
        x: 164
        y: 215
        text: switch_showkey.checked ? account.keyshowstr : account.keyhidestr
        readOnly: true
        selectByMouse: true
    }

    Switch {
        id: switch_showkey
        x: 486
        y: 209
        width: 123
        height: 14
        text: qsTr("显示私钥")
    }

    CheckBox {
        x: 35
        y: 310
        text: checked ? qsTr("钱包已加密") : qsTr("钱包未加密")
        enabled: false
        autoExclusive: false
        checked: app.walletIsEncrypted
    }

    CheckBox {
        x: 147
        y: 310
        text: checked ? qsTr("私钥密码(支付密码)已设置") : qsTr("私钥密码(支付密码)未设置")
        enabled: false
        autoExclusive: false
        checked: app.accountKeyIsLocked
    }
    Switch {
        id: switch_keylock
        x: 346
        y: 310
        visible: app.accountKeyIsLocked
        text: checked ? qsTr("私钥(支付密码)锁定") : qsTr("私钥密码(支付密码)已解锁")
        enabled: true
        autoExclusive: false
        checked: account.lock
    }

    Label {
        id: label2
        x: 92
        y: 155
        text: qsTr("XRP余额：")
    }

    Label {
        id: label_balance
        x: 173
        y: 159
        text: account.balance
        clip: false
    }

    Label {
        id: label3
        x: 89
        y: 187
        text: qsTr("Sequence:")
    }

    Label {
        id: label_seq
        x: 173
        y: 188
        text: account.sequence
    }
}
