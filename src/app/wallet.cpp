#include "wallet.h"

namespace cute {
Wallet::Wallet(){
    open();
}
bool Wallet::isOK(){
    return !isError&&!isEmpty;
}
bool Wallet::open(){
    QFile file(wallet_filename);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        isEmpty=true;
        isError=true;
        errMsg="wallet file open error";
        return false;
    }
    QByteArray filedata=file.readAll();
    file.close();
    isError=false;
    if(filedata.isEmpty()){
        isEmpty=true;
        return true;
    }
    wallet_filedata=filedata.toStdString();
    isEmpty=false;
    try{
        wallet_jsondata=Json::parse(wallet_filedata);
        isLocked=wallet_jsondata["lock"];
    }catch(...){
        isError=true;
        errMsg="wallet data error";
    }
    return true;
}
bool Wallet::save(){
    QFile file(wallet_filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return false;
    int size=file.write(QByteArray::fromStdString(wallet_filedata));
    file.close();
    return size>0;
}
bool Wallet::encrypt(){
    if(wallet_password.empty()) return false;
    return encrypt(wallet_password);
}

bool Wallet::encrypt(const std::string &password){//加密钱包数据
    if(isLocked) return false;
    std::string accountText=wallet_jsondata["account"].dump();
    //std::string plainText=wallet_jsondata.dump();
    if(accountText.empty()) return false;
    isLocked=wallet_jsondata["lock"]=true;
    wallet_jsondata["account"]=cute::aesEncrypt(password,accountText);
    wallet_filedata=wallet_jsondata.dump();
    wallet_password=password;
    return save();
}
bool Wallet::decrypt(){
    if(wallet_password.empty()) return false;
    return decrypt(wallet_password);
}
bool Wallet::decrypt(const std::string &password){//解密钱包数据
    if(!isLocked) return true;
    std::string cryptdata=wallet_jsondata["account"];
    //std::cout <<"cryptdata:"<<cryptdata<<std::endl;
    std::string accountText=cute::aesDecrypt(password,cryptdata);
    if(accountText.empty()){
        return false;
    }
    Json account_jsondata;
    try{
        account_jsondata=Json::parse(accountText);
        std::cout<<"json parse ok"<<std::endl;
    }catch(...){
        std::cout<<"json parse error"<<std::endl;
        return false;
    }
    if(account_jsondata.is_object()){
        isLocked=false;
        wallet_password=password;
        wallet_jsondata["account"]=account_jsondata;
        return true;
    }
    return false;
}
//设置支付密码，交易签署需要私钥时，输入此密码，解锁私钥。
bool Wallet::setKeyPass(const std::string &password){
    if(isLocked) return false;
    Json account_jsondata=wallet_jsondata["account"];
    if(account_jsondata["lock"]) return false;
    std::string keyText=account_jsondata["key"];
    //std::string plainText=wallet_jsondata.dump();
    if(keyText.empty()) return false;
    account_jsondata["lock"]=true;
    account_jsondata["key"]=cute::aesEncrypt(password,keyText);
    wallet_jsondata["account"]=account_jsondata;
    return encrypt();
}

bool Wallet::setJsonData(const std::string &jsonstr){
    try{
        wallet_jsondata=Json::parse(jsonstr);
        //std::cout<<json.dump(4);

    }catch(...){
        wallet_jsondata.clear();
        std::cout << "jsonstr is not json data"<<std::endl;
    }
    if(wallet_jsondata.is_object()){
        isError=false;
        wallet_filedata=wallet_jsondata.dump();
        return true;
    }
    return false;
}
std::string Wallet::getJsonData(const int indent){
    return wallet_jsondata.dump(indent);
}
}
