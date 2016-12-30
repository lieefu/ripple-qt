#include "ripple.h"
namespace ripple {
ripple::KeyType keyType = ripple::KeyType::secp256k1;
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
}//end namespace
