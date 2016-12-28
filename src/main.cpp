#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <iostream>

#include <ripple/crypto/KeyType.h>
#include <boost/optional.hpp>
#include <ripple/protocol/Seed.h>
#include <ripple/protocol/SecretKey.h>
#include <ripple/protocol/AccountID.h>
#include <ripple/protocol/JsonFields.h>
int main(int argc, char *argv[])
{
    std::cout << __cplusplus << (__cplusplus >201103L)  <<std::endl;
    ripple::KeyType keyType = ripple::KeyType::secp256k1;
    boost::optional<ripple::Seed> seed;
    seed = ripple::randomSeed ();
    auto const publicKey = ripple::generateKeyPair (keyType, *seed).first;
    Json::Value obj (Json::objectValue);

    obj[ripple::jss::master_seed] = ripple::toBase58 (*seed);
    obj[ripple::jss::master_seed_hex] = ripple::strHex (seed->data(), seed->size());
    obj[ripple::jss::master_key] = ripple::seedAs1751 (*seed);
    obj[ripple::jss::account_id] = ripple::toBase58(calcAccountID(publicKey));
    obj[ripple::jss::public_key] = ripple::toBase58(ripple::TOKEN_ACCOUNT_PUBLIC, publicKey);
    obj[ripple::jss::key_type] = ripple::to_string (keyType);
    obj[ripple::jss::public_key_hex] = ripple::strHex (publicKey.data(), publicKey.size());
    std::cout << obj.toStyledString()<<std::endl;
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
