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
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDesktopServices>
#include "gui.h"
Gui::Gui(QObject *parent) : QObject(parent)
{

}
void Gui::init(){

    engine = new QQmlApplicationEngine();
    QQmlContext *context = engine->rootContext();
    context->setContextProperty("app", this);

    engine->load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    mainWin = qobject_cast<QWindow*>(engine->rootObjects().at(0));
    mainWin->setIcon(QIcon(":/img/logo.png"));
#ifdef Q_OS_WIN
    mainWin->setFlags(Qt::Dialog);
#else
    mainWin->setFlags(Qt::WindowStaysOnTopHint);
#endif
    engine->load(QUrl(QStringLiteral("qrc:/qml/About.qml")));
    aboutWin = qobject_cast<QWindow*>(engine->rootObjects().at(1));
    aboutWin->setIcon(QIcon(":/img/logo.png"));
}
//mainWin
void Gui::showMainWin(){
    //mainWin->hide();
    mainWin->showNormal();
}
void Gui::hideMainWin(){
    mainWin->hide();
}
bool Gui::mainWinIsVisible(){
    return mainWin->isVisible();
}
void Gui::showAboutWin(){
    aboutWin->show();
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

