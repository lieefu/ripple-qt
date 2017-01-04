import QtQuick 2.7

Page1Form {
    btn_save.onClicked: {
        console.log("保存wallet：",app.saveWallet(wallet_id.text,showkey,"walletname"));
    }

    btn_generator.onClicked: {
        //console.log(app.generatorWallet());
        var walletjson=JSON.parse(app.generatorWallet());
        if(walletjson){
            wallet_id.text = walletjson.account_id;
            showkey = walletjson.master_seed;
            hidekey = "***************";
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
