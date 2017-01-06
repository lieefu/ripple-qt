#ifndef WALLET_H
#define WALLET_H
#include <QString>
#include <QFile>
#include <util/libunity.h>

namespace cute {
const std::string wallet_profile=R"({
        "encrypt": false,
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
    Wallet();
    QString errMsg;
    bool isLocked{true};//私钥是否被加密
    bool isEmpty{false};
    bool isError{true};
    bool isEncrypted{false};
    bool isDecrypted();
    bool isOK();
    bool open();
    bool save();
    bool encrypt();
    bool encrypt(const std::string &password);
    bool decrypt();
    bool decrypt(const std::string &password);
    //设置支付密码，交易签署需要私钥时，输入此密码，解锁私钥。
    bool setKeyPass(const std::string &password);
    std::string decryptKey(const std::string &password,const std::string &keystr);
    bool setJsonData(const std::string &jsonstr);
    std::string getJsonData(const int indent = -1);
    bool setAccount(const std::string &id,const std::string &key,const std::string &name);
    std::string getAccount();
private:
    std::string wallet_filedata;
    Json wallet_jsondata;
    std::string wallet_password;
    std::string sign_password;
};
}
#endif // WALLET_H
