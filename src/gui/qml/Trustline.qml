import QtQuick 2.4

TrustlineForm {
    btn_getlines.onClicked: {
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
        listView.currentIndex=1;
    }
}
