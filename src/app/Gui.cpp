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
#include "Gui.h"
Gui::Gui(QObject *parent) : QObject(parent)
{

}
void Gui::init(){

    engine = new QQmlApplicationEngine();
//    QQmlContext *context = engine->rootContext();
//    context->setContextProperty("cfg", DICT::cfg.get());

    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
    mainWin = qobject_cast<QWindow*>(engine->rootObjects().at(0));
    mainWin->setIcon(QIcon(":/img/logo.png"));
#ifdef Q_OS_WIN
    mainWin->setFlags(Qt::Dialog);
#else
    mainWin->setFlags(Qt::WindowStaysOnTopHint);
#endif
    engine->load(QUrl(QStringLiteral("qrc:/About.qml")));
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

