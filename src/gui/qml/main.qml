import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: window
    property var account:{"lock":false}
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    flags: Qt.Dialog
    header:RowLayout {
        //width: childrenRect.width
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
            switch_showkey.onCheckedChanged: {
                console.log(switch_showkey.checked);
                if(account.lock&&switch_showkey.checked){
                    //app.showDecryptKeyWin();
//                    var component = Qt.createComponent("DecryptKey.qml")
//                                var window    = component.createObject(window)
//                                window.show()
                   keypassDialog.open();
                   switch_showkey.checked=false;
                }
            }
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
    Dialog {
        id: keypassDialog
        width: 500
        height: 250
        title: qsTr("ripple-qt_输入私钥密码")
        standardButtons: StandardButton.NoButton;
        PasswordForm {
            pass_label{
                text:"私钥密码:"
            }
            btn_return.onClicked: {
                var passtext=input_pass.text;
                var keystr=app.decryptKey(passtext);
                if(keystr===""){
                   prompt_info.text="密码错误，私钥解密失败！";

                    return;
                }
                prompt_info.text="私钥解密成功";
                accountpage.showkeystr=keystr
                keypassDialog.click(StandardButton.Ok);
                account.lock = false;
                account.key=accountpage.showkeystr=keystr;
                accountpage.hidekeystr = "***************";
                accountpage.switch_showkey.checked=true;
            }
        }
    }
}
