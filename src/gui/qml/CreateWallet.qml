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
                console.log("钱包保存失败");
            }
        }
        btn_generator.onClicked: {
            //console.log(app.generatorWallet());
            var walletjson=JSON.parse(app.generatorWallet());
            if(walletjson){
                wallet_id.text = walletjson.account_id;
                showkey = walletjson.master_seed;
                hidekey = "***************";
                generateWallet = true
            }
        }

        button1.onClicked: {
            console.log("Button Pressed. Entered text: " + textField1.text);
            app.setMessage(textField1.text);
        }
        function setMessage(msg){
            console.log("Response text: " + msg);
            return "qml page1 返回消息";
        }
    }
}
