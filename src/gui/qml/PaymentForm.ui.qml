import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias reciver_address: reciver_address
    property alias xrp_amount: xrp_amount
    property alias btn_return: btn_return
    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.top: parent.top
    }

    TextField {
        id: reciver_address
        x: 124
        y: 87
        width: 398
        height: 40
        text: qsTr("rXzxK7wpKLZ99qwXNiy5nFQUhYxFZq3Rd")
    }

    Label {
        id: label
        x: 46
        y: 98
        text: qsTr("Sent to:")
        font.pointSize: 12
        font.bold: true
    }

    TextField {
        id: xrp_amount
        x: 124
        y: 165
        text: qsTr("100000")
    }

    Label {
        id: label1
        x: 41
        y: 176
        text: qsTr("Amount:")
        font.pointSize: 12
        font.bold: true
    }

    Label {
        id: label2
        x: 330
        y: 178
        text: qsTr("XRP")
        font.pointSize: 12
        font.bold: true
    }

    Button {
        id: btn_return
        x: 343
        y: 251
        text: qsTr("确定")
    }
}
