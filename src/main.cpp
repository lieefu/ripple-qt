#include <QApplication>
#include <app/application.h>
int main(int argc, char *argv[])
{
//    std::string password="abc123";
//       cute::Wallet wallet;
////          if(wallet.isError){
////               if(wallet.setJsonData(cute::wallet_profile)){
////                   std::cout<<wallet.getJsonData()<<std::endl;
////                   wallet.encrypt(password);
////                   wallet.save();
////                   std::cout<<"isEmpty:"<<wallet.isEmpty<<"isLocked："<<wallet.isLocked<<std::endl;
////                   std::cout<<"errpass"<<wallet.decrypt("errpassqqq")<<wallet.getJsonData(3)<<std::endl;
////               }
////           }

//           std::cout<<"isError:"<<wallet.isError<<"isEmpty:"<<wallet.isEmpty<<"isLocked："<<wallet.isLocked<<std::endl;
//           if(wallet.isOK()&&!wallet.isLocked){
//               std::cout<<wallet.getJsonData(4)<<std::endl;
//               wallet.encrypt(password);
//               std::cout<<"encrypt after,isEmpty:"<<wallet.isEmpty<<"isLocked："<<wallet.isLocked<<std::endl;
//           }
//           if(wallet.isOK()&&wallet.isLocked){
//               wallet.decrypt(password);
//               std::cout<<"decrypt after,isEmpty:"<<wallet.isEmpty<<"isLocked："<<wallet.isLocked<<std::endl;
//               wallet.setKeyPass("paypassword");
//               std::cout<<wallet.getJsonData(4);
//           }
//    std::cout<<*ripple::createAccount()<<std::endl;
//    std::cout<<*ripple::getAccountFromKey("spuWjYgw5QCPX5dvpkpo6QQw4Pp2n");//rEU8BtyEgcNBmagdhBbJoLFjF1fKHR35t2
//    std::cout<<*ripple::createAccountFromStr("脑钱包");//
    ///////////////////////////////////////////////
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
//    QQmlApplicationEngine engine;
//    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

//#ifdef Q_OS_LINUX
//    QFont font;
//    font.setFamily("WenQuanYi Micro Hei");
//    qApp->setFont(font);
//#endif
    cute::app = std::make_unique<Application>();
    cute::app->run();

    return app.exec();
}
