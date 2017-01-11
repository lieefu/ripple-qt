import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: window
    property var account
    property bool keylocked: app.accountKeyIsLocked
    property string keyshowstr: qsTr("key locked")
    property string keyhidestr: qsTr("*********")
    property var keypassDialogCallback;
    visible: true
    width: 640
    height: 480
    title: qsTr("Ripple-Qt")
    flags: Qt.Dialog
    header:RowLayout {
        width: childrenRect.width
        ToolButton{
            text: qsTr("Wallet")
            onClicked: menu.open();
            Menu {
                id: menu
                title: "Wallet"
                width: 120
                topMargin: 30
                leftMargin: 10
                MenuItem {
                    text: qsTr("EncryptWallet")
                    enabled: !app.walletIsEncrypted
                    onTriggered: {
                        console.log("encrypt menu click");
                        app.showEncryptWalletWin();
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
                    text: "AccountInfo"
                    onTriggered: tabBar.currentIndex = 0;
                }
            }
        }
        ToolButton{
            text: qsTr("Transaction")
            onClicked: menu1.open();
            Menu {
                id: menu1
                title: "Transaction"
                width: 120
                topMargin: 30
                leftMargin: 10
                MenuItem {
                    text: "Payment"
                    onTriggered: tabBar.currentIndex = 1;
                }
            }

        }
    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        AccountInfo {
            id: accountpage
            switch_showkey.onCheckedChanged: {
                if(switch_showkey.checked){
                    if(account.lock){
                        keypassDialog.open();
                        keypassDialogCallback=function(ok){
                           console.log("showkey call",ok);
                           if(!ok) switch_showkey.checked=false;
                        }
                    }
                }
            }
            switch_keylock.onCheckedChanged: {
                if(switch_keylock.checked){
                    keylocked=account.lock = true;
                    keyshowstr="key locked";
                }else{
                    if(account.lock){
                        keypassDialog.open();
                        keypassDialogCallback=null;
                    }
                }
            }
        }
        Payment {
            btn_return.onClicked: {
                if(account.lock){
                    console.log("秘钥锁定，请解锁");
                    keypassDialog.open();
                    keypassDialogCallback=null;
                    return;
                }
                var payment={
                    "Account": "sender address",
                    "Amount": "100000000",
                    "Destination": "recever address",
                    "TransactionType": "Payment",
                    "Sequence":176,
                    "Fee":10000
                };
                console.log("秘钥：",account.key);
                console.log(reciver_address.text,xrp_amount.text);
                payment.Account = "r4ct9csCtZC2ycncUWdna5RW5XUhSWmJ5Z";//account.id;
                payment.Destination = reciver_address.text;
                payment.Amount = xrp_amount.text;
                payment.Sequence = 176;
                var tx_json_str=JSON.stringify(payment);
                console.log(tx_json_str);
                var signjson_str= app.sign(tx_json_str,account.key);
                console.log(signjson_str);
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("AccountInfo")
        }
        TabButton {
            text: qsTr("Payment")
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
            keyshowstr="is locked";
        }else{
            keyshowstr=account["key"];
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
            btn_cancel.onClicked: {
                keypassDialog.click(StandardButton.Cancel);
            }
            btn_return.onClicked: {
                var passtext=input_pass.text;
                input_pass.text="";
                var keystr=app.decryptKey(passtext);
                if(keystr===""){
                    prompt_info.text="密码错误，私钥解锁失败！";
                    accountpage.switch_keylock.checked=true;
                    if(keypassDialogCallback) keypassDialogCallback(false);
                    return;
                }
                prompt_info.text="私钥解密成功";
                keypassDialog.click(StandardButton.Ok);
                keylocked=account.lock = false
                account.key=keystr;
                keyshowstr=account.key;
                if(keypassDialogCallback) keypassDialogCallback(true);
            }
        }
        onRejected: {
            //click red 'X' close dialog,no signal rejected emit
            //http://stackoverflow.com/questions/41509003/how-to-get-dialog-red-x-close-button-signal-in-qml
            console.log("on rejected");
            if(keypassDialogCallback) keypassDialogCallback(false);
        }
    }
}
