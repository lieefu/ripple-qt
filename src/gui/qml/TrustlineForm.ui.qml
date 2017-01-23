import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias prompt_info: prompt_info
    property alias btn_getlines: btn_getlines
    property alias btn_set: btn_set
    property alias text_currency: text_currency
    property alias text_issuer: text_issuer
    property alias text_limit: text_limit
    property alias check_noripple: check_noripple
    property alias listView: listView

    Label {
        id: label
        x: 18
        y: 23
        text: qsTr("币种：")
    }
    TextField {
        id: text_currency
        x: 60
        y: 12
        width: 98
        text: qsTr("")
    }
    Label {
        id: label1
        x: 164
        y: 23
        text: qsTr("发行者：")
    }
    TextField {
        id: text_issuer
        x: 225
        y: 12
        width: 393
        height: 40
        text: qsTr("")
    }
    Label {
        id: label3
        x: 18
        y: 69
        text: qsTr("信任额度：")
    }
    TextField {
        id: text_limit
        x: 92
        y: 58
        width: 168
        height: 40
        text: qsTr("")
    }
    CheckBox {
        id: check_noripple
        x: 266
        y: 58
        text: qsTr("禁止同币种转换")
    }

    Button {
        id: btn_set
        x: 415
        y: 58
        text: qsTr("确定")
    }

    Button {
        id: btn_getlines
        x: 521
        y: 58
        text: qsTr("获取信任链")
    }
    Rectangle {
        x: 18
        y: 121
        width: 600; height: 300
        ListView {
            id: listView
            anchors.fill: parent
            model: trustlineModel
            highlight: Rectangle { color: "lightsteelblue"; radius: 5}
            focus: true
            delegate: Item {
                x: 5
                width: parent.width
                height: 20
                Row {
                    spacing: 5
                    Text {
                        width: 30
                        text: currency
                    }

                    Text {
                        width: 100
                        text: balance
                    }

                    Text {
                        width: 250
                        text: issuer
                    }
                    Text {
                        width: 100
                        text: limit
                    }
                    Text {
                        width: 20
                        text: no_ripple?"Yes":"No"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: listView.currentIndex = index
                    cursorShape: Qt.PointingHandCursor
                }
            }
            header: Rectangle {
                x: 5
                width: parent.width
                height: 20
                color: "#e5e5e5"
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
                        width: 250
                        text: "发行者"
                    }
                    Text {
                        width: 100
                        text: "限额"
                    }
                    Text {
                        width: 20
                        text: "禁止转换"
                    }
                }
            }
            flickableDirection: Flickable.VerticalFlick
        }
    }

    Label {
        id: prompt_info
        x: 24
        y: 97
        text: qsTr("提示信息")
    }

}
