#include <ripple/crypto/KeyType.h>
#include <ripple/protocol/Seed.h>
#include <ripple/protocol/SecretKey.h>
#include <ripple/protocol/AccountID.h>
#include <ripple/protocol/JsonFields.h>


#include <ripple/json/json_reader.h>
#include <ripple/protocol/STParsedJSON.h>
#include <ripple/protocol/STTx.h>
#include <ripple/basics/StringUtilities.h>
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
std::string tx_json_profile=R"({
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
                            )";
boost::optional<std::string> sign(std::string const tx_json_str,std::string const &key){
    auto seed= ripple::parseBase58<Seed>(key);

    auto keypair=ripple::generateKeyPair (keyType, *seed);
//    std::cout<<ripple::toBase58(calcAccountID(keypair.first))<<std::endl;
//    return boost::none;
    Json::Reader reader;
    Json::Value tx_json;
    if(!reader.parse (tx_json_str, tx_json)){
        std::cout<<"parse json error"<<reader.getFormatedErrorMessages()<<std::endl;
        return boost::none;
    }
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
    try
    {
        // If we're generating a multi-signature the SigningPubKey must be
        // empty, otherwise it must be the master account's public key.
        parsed.object->setFieldVL (sfSigningPubKey,keypair.first.slice());

        stpTrans = std::make_shared<STTx> (
            std::move (parsed.object.get()));
    }
    catch (std::exception&)
    {
        std::cout<<"Exception occurred constructing serialized transaction"<<std::endl;
        return boost::none;
    }
    stpTrans->sign (keypair.first, keypair.second);
    Json::Value jvResult;
    jvResult[jss::tx_json] = stpTrans->getJson (0);
    jvResult[jss::tx_blob] = strHex ( stpTrans->getSerializer ().peekData ());
    return jvResult.toStyledString();
}
}//end namespace
