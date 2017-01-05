#include "wallet.h"

namespace cute {
Wallet::Wallet(){}
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
        isEncrypted=wallet_jsondata["encrypt"];
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
    isError=false;
    return size>0;
}
bool Wallet::encrypt(){
    if(wallet_password.empty()) return false;
    return encrypt(wallet_password);
}

bool Wallet::encrypt(const std::string &password){//加密钱包数据
    if(isEncrypted) return false;
    std::string accountText=wallet_jsondata["account"].dump();
    //std::string plainText=wallet_jsondata.dump();
    if(accountText.empty()) return false;
    isEncrypted=wallet_jsondata["encrypt"]=true;
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
    if(!isEncrypted) return true;
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
        isEncrypted=false;
        wallet_password=password;
        wallet_jsondata["account"]=account_jsondata;
        return true;
    }
    return false;
}
//设置支付密码，交易签署需要私钥时，输入此密码，解锁私钥。
bool Wallet::setKeyPass(const std::string &password){
    if(isEncrypted) return false;
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
        isEmpty=false;
        isEncrypted=wallet_jsondata["encrypt"];
        wallet_filedata=wallet_jsondata.dump();
        return save();
    }
    return false;
}
std::string Wallet::getJsonData(const int indent){
    return wallet_jsondata.dump(indent);
}
bool Wallet::setAccount(const std::string &id,const std::string &key,const std::string &name){
    if(this->isOK()) return false;
    Json json = Json::parse(cute::wallet_profile);
    json["account"]["id"] = id;
    json["account"]["key"] = key;
    json["account"]["name"] = name;
    std::cout<<json.dump(3)<<std::endl;
    return setJsonData(json.dump());

}
std::string Wallet::getAccount(){
    if(this->isEncrypted){
        return "";
    }else{
        return wallet_jsondata["account"].dump();
    }
}
}
