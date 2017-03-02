import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias switch_keylock: switch_keylock
    property alias switch_showkey: switch_showkey
    Label {
        id: label
        x: 25
        y: 9
        text: qsTr("钱包地址：")
        renderType: Text.QtRendering
    }

    Label {
        id: label1
        x: 45
        y: 105
        text: qsTr(" 私钥：")
    }

    TextArea {
        id: wallet_id
        x: 100
        y: 6
        text: account.id
        readOnly: true
        selectByMouse: true
    }

    TextArea {
        id: wallet_key
        x: 97
        y: 103
        text: switch_showkey.checked ? account.keyshowstr : account.keyhidestr
        readOnly: true
        selectByMouse: true
    }

    Switch {
        id: switch_showkey
        x: 466
        y: 108
        width: 123
        height: 14
        text: qsTr("显示私钥")
    }

    CheckBox {
        x: 35
        y: 368
        text: checked ? qsTr("钱包已加密") : qsTr("钱包未加密")
        enabled: false
        autoExclusive: false
        checked: app.walletIsEncrypted
    }

    CheckBox {
        x: 147
        y: 368
        text: checked ? qsTr("私钥密码(支付密码)已设置") : qsTr("私钥密码(支付密码)未设置")
        enabled: false
        autoExclusive: false
        checked: app.accountKeyIsLocked
    }
    Switch {
        id: switch_keylock
        x: 346
        y: 368
        visible: app.accountKeyIsLocked
        text: checked ? qsTr("私钥(支付密码)锁定") : qsTr("私钥密码(支付密码)已解锁")
        enabled: true
        autoExclusive: false
        checked: account.lock
    }

    Label {
        id: label2
        x: 25
        y: 43
        text: qsTr("XRP余额：")
    }

    Label {
        id: label_balance
        x: 106
        y: 47
        text: account.balance+" 冻结："+ account.freeze
        clip: false
    }

    Label {
        id: label3
        x: 22
        y: 75
        text: qsTr("Sequence:")
    }

    Label {
        id: label_seq
        x: 106
        y: 76
        text: account.sequence
    }

    ListView {
        id: listView
        x: 22
        y: 144
        width: childrenRect.width
        height: 180
        flickableDirection: Flickable.VerticalFlick
        model: account.currencyModel;
        header: Rectangle {
            x: 5
            width: parent.width
            height: 20
            color:"#f5f5f5"
            Row {
                id: rowhead
                spacing: 10
                Text {
                    width: 30
                    text: "货币"
                }
                Text {
                    width: 150
                    text: "余额"
                }
                Text {
                    width: 300
                    text: "发行者"
                }
            }
        }
        delegate: Item {
            x: 5
            width: parent.width
            height: 20
            Row {
                spacing: 10
                Text {
                    width: 30
                    text: currency
                }
                Text {
                    width: 150
                    text: balance
                }
                Text {
                    width: 300
                    text: issuer
                }
            }
        }
    }
}
