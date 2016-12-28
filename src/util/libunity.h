#ifndef LIBUNITY_H
#define LIBUNITY_H
#include <string>
#include <libs/json.hpp>

namespace cute {
    using Json = nlohmann::json;
    std::string aesEncrypt(const std::string &passwd,const std::string &source);
    std::string aesDecrypt(const std::string &passwd,const std::string &source);
}

#endif // LIBUNITY_H
