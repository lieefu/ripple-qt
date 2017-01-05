import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: window
    property var account: null
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    flags: Qt.Dialog
    header: ToolBar {
        TabButton {
            text: qsTr("File")
            onClicked: menu.open();
            Menu {
                id: menu
                title: "File"
                MenuItem {
                    text: "Encrypt"
                    onTriggered: {
                        console.log("encrypt menu click");
                        app.showEncryptWin();
                        //window.visible = false;
                    }
                }
                MenuItem {
                    text: "Cut"
                }

                MenuItem {
                    text: "Copy"
                }

                MenuItem {
                    text: "Paste"
                }
            }
        }

    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        Page1 {
            id: accountpage
        }
        Page {
            Label {
                text: qsTr("Second page")
                anchors.centerIn: parent
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("First")
        }
        TabButton {
            text: qsTr("Second")
        }
    }
    onClosing:{
        //console.log("main windows is closing");
        visible = false;
        close.accepted = false;
    }
    function setAccount(accountstr){
        console.log("Response text: " + accountstr);
        account=JSON.parse(accountstr);
        accountpage.wallet_id.text=account["id"];
        if(account["lock"]){
            accountpage.hidekeystr=accountpage.showkeystr="is locked";
        }else{
            accountpage.showkeystr=account["key"];
        }

        console.log(account["id"]);
    }
}
