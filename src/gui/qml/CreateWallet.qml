import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("ripple-qt_创建新钱包")
    flags: Qt.Dialog
    CreateWalletForm {
        anchors.fill: parent
        btn_save.onClicked: {
            if(app.saveWallet(wallet_id.text,showkey,"walletname")){
                app.showMainWin();
                window.visible=false;
            }else{
                prompt_info.text = "钱包保存失败";
            }
        }
        btn_generator.onClicked: {
            var walletjson=JSON.parse(app.generatorWallet());
            setWallet(walletjson);
        }

        btn_key.onClicked: {
            var key = textField.text;
            var walletstr=app.getWalletFromKey(key);
            if(walletstr===""){
                prompt_info.text = "错误的私钥";
                return;
            }
            var walletjson=JSON.parse(walletstr);
            setWallet(walletjson);
        }
        btn_text.onClicked: {
            var data = textField.text;
            var walletjson=JSON.parse(app.generatorWalleFromStr(data));
            setWallet(walletjson);
        }
        function setWallet(walletjson){
            if(walletjson){
                wallet_id.text = walletjson.account_id;
                showkey = walletjson.master_seed;
                hidekey = "***************";
                generateWallet = true
            }
        }
    }
}
