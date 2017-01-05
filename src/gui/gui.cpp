/****************************************************************************
**
** Copyright (C) 2016 lieefu Way.
** All rights reserved.
** Contact: lieefu@gmail.com
**
** This file is part of the ShanbayDict.
**
** $BEGIN_LICENSE:LGPL$
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 3 as published by the Free Software Foundation and
** appearing in the file LICENSE included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 3 requirements will be met:
** http://www.gnu.org/licenses/lgpl.html.
**
** $END_LICENSE$
**                                                    2016/5/5
****************************************************************************/
#include <QDebug>
#include <app/application.h>
#include "gui.h"
std::unique_ptr<Gui> cute::gui;
Gui::Gui(QObject *parent) : QObject(parent){
}
void Gui::init(){
    //engine = std::make_unique<QQmlApplicationEngine>();
    engine = new QQmlApplicationEngine();//Qt 的类对象具有自动释放资源能力，只能new使用，而且无需delete，不能使用std::unique_ptr机制
    engine->rootContext()->setContextProperty("app", this);
    if(!this->existWallet()){
        engine->load(QUrl(QStringLiteral("qrc:/qml/CreateWallet.qml")));
        createWalletWin = qobject_cast<QWindow*>(engine->rootObjects().last());
        createWalletWin->setIcon(QIcon(":/img/logo.png"));
        return;
    }
    if(this->walletIsEncrypted()){
        engine->load(QUrl(QStringLiteral("qrc:/qml/DecryptWallet.qml")));
        createWalletWin = qobject_cast<QWindow*>(engine->rootObjects().last());
        createWalletWin->setIcon(QIcon(":/img/logo.png"));
        return;
    }
    showMainWin();
}
//mainWin
void Gui::showMainWin(){
    if(mainWin){
        mainWin->showNormal();
        return;
    }
    qDebug()<<"首次显示main windows";
    engine->load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    mainWin = qobject_cast<QWindow*>(engine->rootObjects().last());
    mainWin->setIcon(QIcon(":/img/logo.png"));
//#ifdef Q_OS_WIN
//    mainWin->setFlags(Qt::Dialog);
//#else
//    mainWin->setFlags(Qt::WindowStaysOnTopHint);
//#endif
    QVariant arg= QString::fromStdString(cute::wallet->getAccount());
    QMetaObject::invokeMethod(mainWin, "setAccount",Q_ARG(QVariant, arg));
    cute::app->showSystrayIcon();
}
void Gui::hideMainWin(){
    mainWin->hide();
}
void Gui::showEncryptWin(){
    if(encryptWin){
        encryptWin->showNormal();
        return;
    }
    engine->load(QUrl(QStringLiteral("qrc:/qml/EncryptWallet.qml")));
    encryptWin = qobject_cast<QWindow*>(engine->rootObjects().last());
}
bool Gui::mainWinIsVisible(){
    return mainWin->isVisible();
}
void Gui::showAboutWin(){
    if(aboutWin){
        aboutWin->show();
        return;
    }
    engine->load(QUrl(QStringLiteral("qrc:/qml/About.qml")));
    aboutWin = qobject_cast<QWindow*>(engine->rootObjects().last());
    aboutWin->setIcon(QIcon(":/img/logo.png"));
}
void Gui::registerClick(){
    QDesktopServices::openUrl(QUrl("http://www.shanbay.com/referral/ref/9e54b69ab8/"));
}
void Gui::setMessage(const QString &text){//qml内可以直接调用 app的slot
    qDebug()<<"我收到消息："+text;
    QVariant returnedValue;
    QVariant msg= "我收到消息："+text;
    QMetaObject::invokeMethod(mainWin, "setMessage",//调用qml内的fucntion
            Q_RETURN_ARG(QVariant, returnedValue),
            Q_ARG(QVariant, msg));
    qDebug()<<"我收到返回消息："+returnedValue.toString();
}
const QString Gui::generatorWallet(){
    qDebug()<<"button generator click!";
    return QString::fromStdString(ripple::createAccount().get());
}
bool Gui::existWallet(){
    qDebug()<<"存在钱包："<< cute::wallet->isOK();
    return cute::wallet->isOK();
}
bool Gui::walletIsEncrypted(){
    qDebug()<<"钱包是否加密："<< cute::wallet->isEncrypted;
    return cute::wallet->isEncrypted;
}
bool Gui::saveWallet(const QString id, const QString key, const QString name){
    bool ret=cute::wallet->setAccount(id.toStdString(),key.toStdString(),name.toStdString());
    qDebug()<<"baocun hou存在钱包："<< cute::wallet->isOK();
    emit existWalletChanged(cute::wallet->isOK());
    return ret;
}

