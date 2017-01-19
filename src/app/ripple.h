#ifndef RIPPLE_H
#define RIPPLE_H
#include <boost/optional.hpp>
namespace ripple {
boost::optional<std::string> createAccount();
boost::optional<std::string> createAccountFromStr(std::string const &data);
boost::optional<std::string> getAccountFromKey(std::string const &key);
boost::optional<std::string> sign(std::string const tx_json,std::string const &key);
boost::optional<std::string> apicmd(const std::vector<std::string>& vCmd);
bool init();
}
#endif // RIPPLE_H
