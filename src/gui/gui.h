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
#ifndef GUI_H
#define GUI_H
#include <memory>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDesktopServices>
#include <QWindow>

class QQmlApplicationEngine;
class Gui : public QObject
{
    Q_OBJECT
public:
    explicit Gui(QObject *parent = 0);
    QString licenceinfo(){
        return licenceinformation;
    }
 signals:
   void existWalletChanged(bool);
   void walletIsEncryptedChanged(bool);
   void accountKeyIsLockedChanged(bool);
   void newMessagePosted(const QString &msg);
    //outer send signal to wint;

public slots://qml invoked
    void setMessage(const QString &text);
    void registerClick();
public:
    Q_PROPERTY(QString licenceinfo READ licenceinfo)
    Q_PROPERTY(bool existWallet READ existWallet NOTIFY existWalletChanged)
    Q_PROPERTY(bool walletIsEncrypted READ walletIsEncrypted NOTIFY walletIsEncryptedChanged)
    Q_PROPERTY(bool accountKeyIsLocked READ accountKeyIsLocked NOTIFY accountKeyIsLockedChanged)
    bool existWallet();
    bool walletIsEncrypted();
    bool accountKeyIsLocked();
Q_INVOKABLE const QString generatorWallet();
Q_INVOKABLE const QString getWalletFromKey(const QString &key);
Q_INVOKABLE const QString generatorWalleFromStr(const QString &text);
Q_INVOKABLE bool saveWallet(const QString id,const QString key,const QString name);
Q_INVOKABLE void showMainWin();
Q_INVOKABLE void showEncryptWalletWin();
Q_INVOKABLE void showEncryptKeyWin();
Q_INVOKABLE void showDecryptKeyWin();
Q_INVOKABLE bool encryptWallet(const QString pass);
Q_INVOKABLE bool decryptWallet(const QString pass);
Q_INVOKABLE bool encryptKey(const QString pass);
Q_INVOKABLE const QString decryptKey(const QString pass);
Q_INVOKABLE const QString sign(const QString tx_json_str,const QString key);
Q_INVOKABLE const QString ripplecmd(const QString &cmdstr);
    void init();
    void hideMainWin();
    bool mainWinIsVisible();
    void showAboutWin();

    QWindow* mainWin{nullptr};
    QWindow* createWalletWin{nullptr};
    QWindow* encryptWalletWin{nullptr};
    QWindow* encryptKeyWin{nullptr};
    QWindow* decryptKeyWin{nullptr};
    QWindow* aboutWin{nullptr};
private:
    QQmlApplicationEngine *engine;
    QString versioninformation=QObject::tr("Ripple-qt 1.0.0");
    //所有使用本软件全部或者部分代码的程序设计人员请保留lience信息，并在所发布的软件关于窗口中进行显示。
    QString licenceinformation=QObject::tr("<h2>%1</h2>"
                                         "Ripple-qt依据<a href='http://www.shanbay.com'><b>扇贝网</b></a>公开的API设计，扇贝网是我最喜欢的背单词学英语网站，提供<br>"
                                         "英文阅读、炼句、听力以及背单词服务,网站清爽无广告。<br> "
                                         "Copyright(C) 2016 Lieefu Way  All rights reserved.<br>"
                                         "<p>完全遵循LGPL v3协议,未经作者允许不得作为商业用途。<a href='http://git.oschina.net/lieefu/ShanbayDict'><b>Ripple-qt开源(码云)</b></a></p>"
                                         "<p><h3>软件作者:Lieefu Way<br>email:lieefu@gmail.com<br>新浪微博：<a href='http://weibo.com/207899158'>http://weibo.com/207899158</a><br>"
                                         "QQ:53336158 Ripple-qt QQ群：56937187</h3</p>"
                                         "<p>本软件有多个平台的版本包含linux、mac和windows。</p>").arg(versioninformation);

};
namespace cute{
extern std::unique_ptr<Gui> gui;
}
#endif // GUI_H
