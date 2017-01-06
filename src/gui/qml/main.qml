import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: window
    property var account
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    flags: Qt.Dialog
    header:RowLayout {
        width: childrenRect.width
        ToolButton{
            text: qsTr("File")
            onClicked: menu.open();
            Menu {
                id: menu
                title: "File"
                width: 120
                topMargin: 30
                leftMargin: 10
                MenuItem {
                    text: qsTr("EncryptWallet")
                    enabled: !app.walletIsEncrypted
                    onTriggered: {
                        console.log("encrypt menu click");
                        app.showEncryptWalletWin();
                        //window.visible = false;
                    }
                }
                MenuItem {
                    text: qsTr("EncryptKey")
                    enabled: !app.accountKeyIsLocked
                    onTriggered: {
                        console.log("EncryptKey menu click");
                        app.showEncryptKeyWin();
                        //window.visible = false;
                    }
                }

                MenuItem {
                    text: "Copy"
                }

                MenuItem {
                    text: "Paste"
                }
            }
        }
        ToolButton{
            text: qsTr("Setting")
            onClicked: menu1.open();
            Menu {
                id: menu1
                title: "File"
                width: 120
                topMargin: 30
                leftMargin: 10
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
        console.log("main windows is closing");
        //visible = false;
        //close.accepted = false;
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
