import QtQuick 2.4

TrustlineForm {
    listView.onCurrentItemChanged:{
        var item = listView.model.get(listView.currentIndex);
        text_currency.text = item.currency;
        text_issuer.text = item.issuer;
        text_limit.text = item.limit;
        check_noripple.checked = item.no_ripple;
        console.log(listView.model.get(listView.currentIndex).issuer + ' selected');
    }

    btn_getlines.onClicked: {
        trustlineModel.clear();
        getAccountlines(account.id);
    }
    property ListModel trustlineModel :ListModel {}
    function getAccountlines(id){
        var accountlinesstr=app.ripplecmd("account_lines "+id);
        console.log(accountlinesstr);
        var accountlines = JSON.parse(accountlinesstr);
        accountlines  = accountlines.result;
        var lines = accountlines.lines;
        for(var i=0;i<lines.length; ++i){
            var balance = lines[i].balance
            var currency = lines[i].currency
            if(currency.length>3){
                if(currency==="0158415500000000C1F76FF6ECB0BAC600000000") crurrency="XAU";
            }
            trustlineModel.append({
                                      currency: currency,
                                      issuer: lines[i].account,
                                      balance:balance,
                                      limit:lines[i].limit,
                                      no_ripple: lines[i].no_ripple
                                  });
        }
    }
    btn_set.onClicked: {
        if(account.lock){
            console.log("秘钥锁定，请解锁");
            keypassDialog.open();
            keypassDialogCallback=null;
            return;
        }
        var TrustSet={
            "TransactionType": "TrustSet",
            "Account": "",
            "LimitAmount": {
                "currency": "CNY",
                "issuer": "rnuF96W4SZoCJmbHYBFoJZpR8eCaxNvekK",
                "value": "0"
            },
            "Sequence":0,
            "Fee":10000,
            "Flags": 131072
        };

        console.log("秘钥：",account.key);
        TrustSet.Account = account.id;
        TrustSet.Sequence = account.sequence ;
        TrustSet.Flags = check_noripple.checked?131072:262144;
        var LimitAmount = TrustSet.LimitAmount;
        LimitAmount.currency = text_currency.text;
        LimitAmount.issuer = text_issuer.text;
        LimitAmount.value = text_limit.text;
        var tx_json_str=JSON.stringify(TrustSet);
        var signjson_str= app.sign(tx_json_str,account.key);
        console.log(signjson_str);
        var signjson = JSON.parse(signjson_str);
        var retstr = app.ripplecmd("submit "+signjson.tx_blob);
        console.log(retstr);
        var retjson = JSON.parse(retstr);
        retjson = retjson.result;
        if(retjson["engine_result"]==="tesSUCCESS"){
            prompt_info.text = "TrustSet success";
            getAccountInfo(account.id);
        }else{
            prompt_info.text = retjson["engine_result_message"];
        }
    }

}

//"tx_json": {
//                   "TransactionType": "TrustSet",
//                   "Account": "rDoxWHE1usiA4FxBhSN463LZ7oLPK6b7Hw",
//                   "Fee": "12000",
//                   "Flags": 262144,
//                   "LimitAmount": {
//                     "currency": "CNY",
//                     "issuer": "rnuF96W4SZoCJmbHYBFoJZpR8eCaxNvekK",
//                     "value": "0"
//                   },
//                   "Sequence": 26
//               }

//https://ripple.com/build/transactions/#trustset
//TrustSet Flags
//Transactions of the TrustSet type support additional values in the Flags field, as follows:

//Flag Name	Hex Value	Decimal Value	Description
//tfSetfAuth	0x00010000	65536	Authorize the other party to hold issuances from this account. (No effect unless using the asfRequireAuth AccountSet flag.) Cannot be unset.
//tfSetNoRipple	0x00020000	131072	Blocks rippling between two trustlines of the same currency, if this flag is set on both. (See No Ripple for details.)
//tfClearNoRipple	0x00040000	262144	Clears the No-Rippling flag. (See No Ripple for details.)
//tfSetFreeze	0x00100000	1048576	Freeze the trustline.
//tfClearFreeze	0x00200000	2097152	Unfreeze the trustline.
