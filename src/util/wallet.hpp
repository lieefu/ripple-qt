#ifndef WALLET_HPP
#define WALLET_HPP
#include <QCryptographicHash>
#include <QString>
#include <QFile>
#include <QByteArray>
#include <util/libunity.h>

namespace cute {
const std::string wallet_profile=R"({
        "lock": false,
        "version": "1.0",
        "account":{
               "id":"rDoxWHE1usiA4FxBhSN463LZ7oLPK6b7Hw",
               "name":"roboter",
               "key":"private key",
               "lock":false
        }
    })";
const QString wallet_filename="ripple.key";
class Wallet{
public:
    Wallet(){
        open();
    }
    bool isLocked{false};
    bool isEmpty{false};
    bool isError{true};
    QString errMsg;
    bool isOK(){
        return !isError&&!isEmpty;
    }
    bool open(){
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
    bool save(){
        QFile file(wallet_filename);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
            return false;
        int size=file.write(QByteArray::fromStdString(wallet_filedata));
        file.close();
        return size>0;
    }
    bool encrypt(){
        if(wallet_password.empty()) return false;
        return encrypt(wallet_password);
    }

    bool encrypt(const std::string &password){//加密钱包数据
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
    bool decrypt(){
        if(wallet_password.empty()) return false;
        return decrypt(wallet_password);
    }
    bool decrypt(const std::string &password){//解密钱包数据
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
    bool setKeyPass(const std::string &password){
        if(isLocked) return false;
        Json account_jsondata=wallet_jsondata["account"];
        if(account_jsondata["lock"]) return false;
        std::string keyText=account_jsondata["key"].dump();
        //std::string plainText=wallet_jsondata.dump();
        if(keyText.empty()) return false;
        account_jsondata["lock"]=true;
        account_jsondata["key"]=cute::aesEncrypt(password,keyText);
        wallet_jsondata["account"]=account_jsondata;
        return encrypt();
    }

    bool setJsonData(const std::string &jsonstr){
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
    std::string getJsonData(const int indent = -1){
        return wallet_jsondata.dump(indent);
    }
private:
    std::string wallet_filedata;
    Json wallet_jsondata;
    std::string wallet_password;
    std::string sign_password;
};
}
#endif // WALLET_HPP
