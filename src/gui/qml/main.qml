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
                if(!switch_showkey.checked) return;
                if(account.lock){
                   keypassDialog.open();
                   switch_showkey.checked=false;//if cancel keypassDialog,checked restore false
                   return;
                }else{
                    showkeystr=account.key;
                    hidekeystr="*************";
                }
            }
            switch_keylock.onCheckedChanged: {
                if(switch_keylock.checked){
                    account.lock = true;
                    showkeystr="key locked";
                    hidekeystr="key locked";
                }else{
                    if(account.lock){
                        keypassDialog.open();
                    }else{
                        showkeystr=account.key;
                        hidekeystr="*************";
                    }
                }
            }
        }
        Payment {
            btn_return.onClicked: {
                if(account.lock){
                    console.log("秘钥锁定，请解锁");
                    keypassDialog.open();
                    return;
                }
                var payment={
                "Account": "sender address",
                "Amount": "100000000",
                "Destination": "recever address",
                "TransactionType": "Payment",
                "Sequence":12,
                "Fee":10000
                };
                console.log("秘钥：",account.key);
                console.log(reciver_address.text,xrp_amount.text);
                payment.Account = account.id;
                payment.Destination = reciver_address.text;
                payment.Amount = xrp_amount.text;
                payment.Sequence = 1;
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
                input_pass.text="";
                var keystr=app.decryptKey(passtext);
                if(keystr===""){
                    prompt_info.text="密码错误，私钥解密失败！";
                    accountpage.switch_keylock.checked=true;
                    return;
                }
                prompt_info.text="私钥解密成功";
                keypassDialog.click(StandardButton.Ok);
                account.lock = false
                accountpage.switch_keylock.checked= false;
                account.key=keystr;
                accountpage.showkeystr=account.key;
                accountpage.hidekeystr="*************";
            }
        }
    }
}
