#ifndef RIPPLE_H
#define RIPPLE_H
#include <ripple/crypto/KeyType.h>
#include <ripple/protocol/Seed.h>
#include <ripple/protocol/SecretKey.h>
#include <ripple/protocol/AccountID.h>
#include <ripple/protocol/JsonFields.h>
namespace ripple {
boost::optional<std::string> createAccount();
boost::optional<std::string> createAccountFromStr(std::string const &data);
boost::optional<std::string> getAccountFromSeed(ripple::Seed const &seed);
boost::optional<std::string> getAccountFromKey(std::string const &key);
}
#endif // RIPPLE_H
