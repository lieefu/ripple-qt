import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias btn_getlines: btn_getlines
    property alias listView: listView
    ListView {
        id: listView
        x: 18
        y: 54
        width: rowhead.width
        height: 180
        model: trustlineModel
        highlight: Rectangle { color: "red"; radius: 5 }
        focus: true
        onCurrentItemChanged: console.log(model.get(listView.currentIndex).issuer + ' selected');
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
                    width: 150
                    text: balance
                }

                Text {
                    width: 300
                    text: issuer
                    MouseArea {
                                       anchors.fill: parent
                                       onClicked: listView.currentIndex = index
                   }
                }


            }
        }
        header: Rectangle {
            x: 5
            width: parent.width
            height: 20
            color: "#f5f5f5"
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
        flickableDirection: Flickable.VerticalFlick
    }

    Button {
        id: btn_getlines
        x: 18
        y: 8
        text: qsTr("获取信任链")
    }
}
