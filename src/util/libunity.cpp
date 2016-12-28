#include "libunity.h"
#include <cryptopp/sha.h>
#include <cryptopp/filters.h>
#include <cryptopp/hex.h>
#include <cryptopp/modes.h>
#include <cryptopp/aes.h>
#include <cryptopp/config.h>
#include <cryptopp/base64.h>
#include <cryptopp/osrng.h>
#include <cryptopp/gzip.h>

#include <iostream>
#include <string>

std::string cute::aesEncrypt(const std::string &passwd,const std::string &source){
    std::string plaintext,ciphertext,encodedText;
    //Key and IV setup
    //AES encryption uses a secret key of a variable length (128-bit, 196-bit or 256-
    //bit). This key is secretly exchanged between two parties before communication
    //begins. DEFAULT_KEYLENGTH= 16 bytes MAX_KEYLENGTH=32 bytes
    byte key[ CryptoPP::AES::MAX_KEYLENGTH ], iv[ CryptoPP::AES::BLOCKSIZE ];
    //memset( key, 0x1A, CryptoPP::AES::MAX_KEYLENGTH );
    //memset( iv, 0x00, CryptoPP::AES::BLOCKSIZE );
    CryptoPP::AutoSeededRandomPool prng;
    // Extract BLOCKSIZE bytes of random bits
    CryptoPP::RandomNumberSource(prng, CryptoPP::AES::BLOCKSIZE, true, new CryptoPP::ArraySink( iv, CryptoPP::AES::BLOCKSIZE ));
    //std::cout<<CryptoPP::Bytes2Hex()
//    std::cout<<"iv:"<<std::hex;;
//    for(int i=0;i<CryptoPP::AES::BLOCKSIZE;i++){
//        std::cout<<(int)iv[i];
//    }
//    std::cout<<std::dec<<std::endl;
    CryptoPP::SHA256 sha256;
    CryptoPP::StringSource(passwd, true, new CryptoPP::HashFilter(sha256, new CryptoPP::ArraySink(key,CryptoPP::AES::MAX_KEYLENGTH)));
//    std::cout<<"key:"<<std::hex;
//    for(int i=0;i<CryptoPP::AES::MAX_KEYLENGTH;i++){
//        std::cout<<(int)key[i];
//    }
//    std::cout<<std::dec<<std::endl;

    CryptoPP::StringSource(source,true,new CryptoPP::Gzip(new CryptoPP::StringSink(plaintext)));

    CryptoPP::AES::Encryption aesEncryption(key, CryptoPP::AES::MAX_KEYLENGTH);
    CryptoPP::CBC_Mode_ExternalCipher::Encryption cbcEncryption( aesEncryption, iv );

//    CryptoPP::StreamTransformationFilter stfEncryptor(cbcEncryption, new CryptoPP::Base64Encoder(new CryptoPP::StringSink( ciphertext ) ));
//    stfEncryptor.Put( reinterpret_cast<const unsigned char*>( plaintext.c_str() ), plaintext.length() + 1 );
//    stfEncryptor.MessageEnd();
    auto stfEncryptor=new CryptoPP::StreamTransformationFilter(cbcEncryption, new CryptoPP::StringSink( ciphertext ) );
    CryptoPP::StringSource(plaintext,true,stfEncryptor);

    std::cout << "Cipher Text (" << ciphertext.size() << " bytes)"<< std::endl;
    ciphertext.append((char*)iv,CryptoPP::AES::BLOCKSIZE);

    //
    // Dump Cipher Text
    //
    std::cout << "Cipher Text (" << ciphertext.size() << " bytes)" <<"ciphertext"<< std::endl;
    CryptoPP::StringSource(ciphertext, true,
            new CryptoPP::Base64Encoder(
                new CryptoPP::StringSink(encodedText)
    ));
    //std::cout << "out_ciphertext Text (" << out_ciphertext.size() << " bytes)" <<out_ciphertext<< std::endl;
    //std::cout << std::endl << std::endl;
    return encodedText;
}
std::string cute::aesDecrypt(const std::string &passwd,const std::string &source){

    byte key[ CryptoPP::AES::MAX_KEYLENGTH ], iv[ CryptoPP::AES::BLOCKSIZE ];
    std::string decodedText,ciphertext,decryptedtext,plaintext;

    CryptoPP::SHA256 sha256;
    CryptoPP::StringSource(passwd, true, new CryptoPP::HashFilter(sha256, new CryptoPP::ArraySink(key,CryptoPP::AES::MAX_KEYLENGTH)));
//    std::cout<<"key:"<<std::hex;
//    for(int i=0;i<CryptoPP::AES::MAX_KEYLENGTH;i++){
//        std::cout<<(int)key[i];
//    }
//    std::cout<<std::dec<<std::endl;
    CryptoPP::StringSource(source, true,
            new CryptoPP::Base64Decoder(
                new CryptoPP::StringSink(decodedText)
    ));
    ciphertext=decodedText.substr(0,decodedText.size()-CryptoPP::AES::BLOCKSIZE);
    //restore iv
    CryptoPP::StringSource(decodedText.substr(decodedText.size()-CryptoPP::AES::BLOCKSIZE),true,new CryptoPP::ArraySink(iv,CryptoPP::AES::BLOCKSIZE));
//    std::cout<<"iv:"<<std::hex;
//    for(int i=0;i<CryptoPP::AES::BLOCKSIZE;i++){
//        std::cout<<(int)iv[i];
//    }
//    std::cout<<std::dec<<std::endl;

    CryptoPP::AES::Decryption aesDecryption(key, CryptoPP::AES::MAX_KEYLENGTH);
    CryptoPP::CBC_Mode_ExternalCipher::Decryption cbcDecryption( aesDecryption, iv );

    auto stfDecryptor=new CryptoPP::StreamTransformationFilter(cbcDecryption, new CryptoPP::StringSink( decryptedtext ) );
    try{
        CryptoPP::StringSource(ciphertext,true,stfDecryptor);
        CryptoPP::StringSource(decryptedtext,true,new CryptoPP::Gunzip(new CryptoPP::StringSink(plaintext)));
        return plaintext;
    }catch(...){
        return std::string();
    }

}
