cmake_minimum_required(VERSION 3.1)

add_subdirectory(rippled)

INCLUDE_DIRECTORIES(./)
aux_source_directory(./cryptopp CRYPTOPP_SRC)
add_library(cryptopp ${CRYPTOPP_SRC})
target_compile_options(cryptopp PRIVATE -DNDEBUG -g2 -O2 -fPIC -march=native -pipe)


