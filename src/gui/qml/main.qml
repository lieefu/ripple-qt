import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "../js/JsUtil.js" as JsUtil
ApplicationWindow {
    id: window
    property Account account: Account{}
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
                MenuItem {
                    text: "TrustLine"
                    onTriggered: tabBar.currentIndex = 2;
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
                    account.lock = true;
                    account.keyshowstr="key locked";
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
                    "Amount": "1",
                    "Destination": "recever address",
                    "TransactionType": "Payment",
                    "Sequence":176,
                    "Fee":10000
                };
                console.log("秘钥：",account.key);
                console.log(reciver_address.text,xrp_amount.text);
                payment.Account = account.id;
                payment.Destination = reciver_address.text;
                payment.Amount = JsUtil.xrptodrop(xrp_amount.text);
                payment.Sequence = account.sequence ;
                var tx_json_str=JSON.stringify(payment);
                var signjson_str= app.sign(tx_json_str,account.key);
                console.log(signjson_str);
                var signjson = JSON.parse(signjson_str);
                var retstr = app.ripplecmd("submit "+signjson.tx_blob);
                console.log(retstr);
                var retjson = JSON.parse(retstr);
                retjson = retjson.result;
                if(retjson["engine_result"]==="tesSUCCESS"){
                    prompt_info.text = "payment success";
                    getAccountInfo(account.id);
                }else{
                    prompt_info.text = retjson["engine_result_message"];
                }
            }
        }
        Trustline{

        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {text: qsTr("AccountInfo")}
        TabButton {text: qsTr("Payment")}
        TabButton {text: qsTr("TrustLine")}
    }
    onClosing:{
        console.log("main windows is closing");
        //visible = false;
        //close.accepted = false;
    }
    function setAccount(accountstr){
        console.log("Response text: " + accountstr);
        var accountJson=JSON.parse(accountstr);
        account.id=accountJson["id"];
        account.key=accountJson["key"]
        account.lock = accountJson["lock"];
        if(account.lock){
            console.log("私钥密码已经设置");
            account.keyshowstr="is locked";
        }else{
            account.keyshowstr=account["key"];
        }
        console.log(account.id);
        setTimeout(function(){getAccountInfo(account.id)},1000);
        //getAccountInfo("rnTYGCErsTL8QSByDM8WVMVuhF6iqyYZYF");
        //getAccountInfo(account.id);
        //getAccountlines("rnTYGCErsTL8QSByDM8WVMVuhF6iqyYZYF")
        //getAccountlines("rKiCet8SdvWxPXnAgYarFUXMh1zCPz432Y")//不打算支持网关钱包地址

    }
    Timer {id: timer}
    function setTimeout(cb,delayTime) {
        //timer = new Timer();
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }
    function getAccountInfo(id){
        var accountinfostr=app.ripplecmd("account_info "+id);
        console.log(accountinfostr);
        var accountinfo = JSON.parse(accountinfostr);
        accountinfo  = accountinfo.result;
        if(accountinfo.account_data){
            var account_data = accountinfo.account_data;
            account.balance = JsUtil.droptoxrp_comma(account_data.Balance);
            account.sequence = account_data.Sequence;
            account.freeze = account_data.OwnerCount * 5 + 20;
            getAccountlines(account.id);
        }else{
            account.balance = accountinfo.error_message;
            account.sequence = "0";
        }
    }
    function getAccountlines(id){
        var accountlinesstr=app.ripplecmd("account_lines "+id);
        console.log(accountlinesstr);
        var accountlines = JSON.parse(accountlinesstr);
        accountlines  = accountlines.result;
        var lines = accountlines.lines;
        for(var i=0;i<lines.length; ++i){
            var balance = lines[i].balance
            if(balance === "0") continue;
            var currency = lines[i].currency
            if(currency.length>3){
                if(currency==="0158415500000000C1F76FF6ECB0BAC600000000") crurrency="XAU";
            }
            account.currencyModel.append({
                                             currency: currency,
                                             issuer: lines[i].account,
                                             balance:balance,
                                             limit:lines[i].limit,
                                             no_ripple: lines[i].no_ripple
                                         });
        }


        //        while(accountlines.status==="success"){//网关地址是发行货币，余额是负值，有成千上万行lines，不打算支持网关钱包地址
        //            var lines = accountlines.lines;
        //            console.log(lines.length);
        //            var marker = accountlines.marker;
        //            if(marker){
        //                var ledger_index = accountlines.ledger_current_index;
        //                if(accountlines.ledger_index) ledger_index = accountlines.ledger_index;
        //                accountlinesstr=app.ripplecmd("account_lines "+id+"  "+ledger_index+" 400 "+marker);
        //                console.log(accountlinesstr);
        //                accountlines = JSON.parse(accountlinesstr);
        //                accountlines  = accountlines.result;
        //            }else {
        //                //console.log(accountlinesstr);
        //                break;
        //            }
        //        }
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
                console.log("私钥解密成功");
                keypassDialog.click(StandardButton.Ok);
                account.lock = false
                account.key=keystr;
                account.keyshowstr=account.key;
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
