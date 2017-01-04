#include <QMenu>
#include <QAction>
#include <QDesktopWidget>
#include <QApplication>
#include <QClipboard>
#include <QMimeData>
#include <QThread>
#include "app/application.h"
#include <gui/gui.h>

std::unique_ptr<Application> cute::app = std::make_unique<Application>();
std::unique_ptr<cute::Wallet> cute::wallet = std::make_unique<cute::Wallet>();
Application::Application(){
}

void Application::init(){
    cute::wallet->open();
    cute::gui = std::make_unique<Gui>();
    cute::gui->init();
}
void Application::close(){
    closeSystrayIcon();
}
void Application::showSystrayIcon(){
    if(trayIcon!=nullptr) return;
    trayIcon = new QSystemTrayIcon(QIcon(":/img/logo.png"),qApp);

    cuteMenu = new QMenu("菜单");
    //cuteMenu->setLayoutDirection(Qt::LeftToRight);
    showMainWinAction = new QAction(QIcon(":/img/main.ico"),QObject::tr("显示主窗口"),qApp);
    //helpAction =new QAction(QIcon(":/img/help.png"),QObject::tr("帮助"),qApp);
    quitAction = new QAction(QIcon(":/img/quit.png"),QObject::tr("退出程序"), qApp);

    aboutAction=new QAction(QIcon(":/img/about.png"),QObject::tr("关于"),qApp);


    cuteMenu->addAction(showMainWinAction);
    //cuteMenu->addAction(helpAction);
    cuteMenu->addAction(aboutAction);
    cuteMenu->addAction(quitAction);

    trayIcon->setContextMenu(cuteMenu);
    QObject::connect(showMainWinAction,&QAction::triggered,[&](){cute::gui->showMainWin();});

    QObject::connect(aboutAction,&QAction::triggered,[&](){cute::gui->showAboutWin();});
    QObject::connect(quitAction,&QAction::triggered,[&](){close();qApp->quit();});


    //Qt bug:Ubuntu 14.04 Qt 5.6 QSystemTrayIcon doesn't emit activated signal
    QObject::connect(trayIcon,&QSystemTrayIcon::activated,
                     [&](QSystemTrayIcon::ActivationReason reason) {
        switch (reason) {
        case QSystemTrayIcon::Trigger:
        case QSystemTrayIcon::DoubleClick:
            if(cute::gui->mainWinIsVisible()){
                cute::gui->hideMainWin();
            }else{
                cute::gui->showMainWin();
            }
            break;
        case QSystemTrayIcon::MiddleClick:
        default:;
        }
    });
    trayIcon->setToolTip(QObject::tr("ripple-qt %1").arg("1.0"));
    trayIcon->show();
}
void Application::closeSystrayIcon(){
    trayIcon->deleteLater();
    cuteMenu->deleteLater();
}
void Application::run(){
    init();
    showSystrayIcon();
}

