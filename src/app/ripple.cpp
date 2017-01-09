#include <ripple/crypto/KeyType.h>
#include <ripple/protocol/Seed.h>
#include <ripple/protocol/SecretKey.h>
#include <ripple/protocol/AccountID.h>
#include <ripple/protocol/JsonFields.h>
#include "ripple.h"
namespace ripple {
ripple::KeyType keyType = ripple::KeyType::secp256k1;
boost::optional<std::string> getAccountFromSeed(ripple::Seed const &seed);
boost::optional<std::string> createAccount(){
    ripple::Seed seed = ripple::randomSeed ();
    return getAccountFromSeed(seed);
}
boost::optional<std::string> getAccountFromKey(std::string const &key){
    auto seed= ripple::parseBase58<Seed>(key);
    if(seed){
        return getAccountFromSeed(*seed);
    }else{
        return boost::none;
    }
}
boost::optional<std::string> createAccountFromStr(std::string const &data){
    auto seed = ripple::generateSeed(data);
    return getAccountFromSeed(seed);
}

boost::optional<std::string> getAccountFromSeed(Seed const &seed){
    assert(seed.size()>0);
    auto const publicKey = ripple::generateKeyPair (keyType, seed).first;
    Json::Value jsonobj (Json::objectValue);
    jsonobj[ripple::jss::account_id] = ripple::toBase58(calcAccountID(publicKey));
    jsonobj[ripple::jss::master_seed] = ripple::toBase58 (seed);
//    jsonobj[ripple::jss::master_seed_hex] = ripple::strHex (seed.data(), seed.size());
//    jsonobj[ripple::jss::master_key] = ripple::seedAs1751 (seed);
//    jsonobj[ripple::jss::public_key] = ripple::toBase58(ripple::TOKEN_ACCOUNT_PUBLIC, publicKey);
//    jsonobj[ripple::jss::key_type] = ripple::to_string (keyType);
//    jsonobj[ripple::jss::public_key_hex] = ripple::strHex (publicKey.data(), publicKey.size());
    return jsonobj.toStyledString();
}
string tx_json_profile=R"({
    "method": "sign",
    "params": [
        {
            "offline": false,
            "secret": "",
            "tx_json": {
               "TransactionType": "TrustSet",
               "Account": "rDoxWHE1usiA4FxBhSN463LZ7oLPK6b7Hw",
               "Fee": "12000",
               "Flags": 262144,
               "LimitAmount": {
                 "currency": "CNY",
                 "issuer": "rnuF96W4SZoCJmbHYBFoJZpR8eCaxNvekK",
                 "value": "0"
               },
               "Sequence": 26
           }
        }
    ]
})";
boost::optional<std::string> sign(std::string const tx_json_str,std::string const &key){
    Json::Value& tx_json(tx_json_str);
    STParsedJSONObject parsed (std::string (jss::tx_json), tx_json);
    if (parsed.object == boost::none)
    {
        Json::Value err;
        err [jss::error] = parsed.error [jss::error];
        err [jss::error_code] = parsed.error [jss::error_code];
        err [jss::error_message] = parsed.error [jss::error_message];
        std::cout<<err.toStyledString();
        return boost::none;
    }

    std::shared_ptr<STTx> stpTrans;
    Blob const& signingPubKey = keypair.publicKey.getAccountPublic();
    parsed.object->setFieldVL (sfSigningPubKey, signingPubKey);
    stpTrans = std::make_shared<STTx> (std::move (parsed.object.get()));
    stpTrans->sign (keypair.secretKey);
    //transactionPreProcessResult preprocResult =transactionPreProcessResult {std::move (stpTrans)};
    Json::Value jvResult;
    jvResult[jss::tx_json] = stpTrans->getJson (0);
    jvResult[jss::tx_blob] = strHex ( stpTrans->getSerializer ().peekData ());
    cout<<jvResult.toStyledString();
    return boost::none;
}
}//end namespace
