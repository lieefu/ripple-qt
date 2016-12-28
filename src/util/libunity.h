#ifndef LIBUNITY_H
#define LIBUNITY_H
#include <string>

namespace cute {
    std::string aesEncrypt(const std::string &passwd,const std::string &source);
    std::string aesDecrypt(const std::string &passwd,const std::string &source);
}

#endif // LIBUNITY_H
