#ifndef WALLET_HPP
#define WALLET_HPP
#include <QCryptographicHash>
#include <QString>
#include <QFile>
#include <QByteArray>
#include <util/libunity.h>

namespace cute {

const QString wallet_filename="ripple.key";
class Wallet{
public:
    bool isLocked{true};
    bool isEmpty{true};
    Wallet(){
        open();
    }
    bool open(){
        QFile file(wallet_filename);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
            std::cout<<"文件打开失败"<<std::endl;
            return false;
        }
        QByteArray filedata=file.readAll();
        file.close();
        if(filedata.isEmpty()){
           isEmpty=true;
           return true;
        }
        wallet_filedata=filedata.toStdString();
        isEmpty=false;
        try{
            json=Json::parse(wallet_filedata);
            isLocked=false;
        }catch(...){
            isLocked=true;
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
        std::string plainText=json.dump();
        if(plainText.empty()) return false;
        wallet_filedata=cute::aesEncrypt(password,plainText);
        wallet_password=password;
        return save();
    }
    bool decrypt(){
        if(wallet_password.empty()) return false;
        return decrypt(wallet_password);
    }
    bool decrypt(const std::string &password){//解密钱包数据
        if(!isLocked) return true;
        std::string plaintext=cute::aesDecrypt(password,wallet_filedata);
        if(plaintext.empty()){
            return false;
        }
        try{
            json= Json::parse(plaintext);
            std::cerr<<"json parse ok"<<std::endl;
        }catch(...){
            std::cerr<<"json parse error"<<std::endl;
            json.clear();
        }
        if(json.is_object()){
            isLocked=false;
            wallet_password=password;
        }
        return json.is_object();
    }
    bool setJsonData(std::string &jsonstr){
        try{
            json=Json::parse(jsonstr);
            //std::cout<<json.dump(4);
            wallet_filedata=json.dump();
        }catch(...){
            json.clear();
        }
        return json.is_object();
    }
    std::string getJsonData(const int indent = -1){
        return json.dump(indent);
    }

private:
    std::string wallet_filedata;
    Json json;
    std::string wallet_password;
    std::string sign_password;
};
}
#endif // WALLET_HPP
