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
#include <QObject>
#include <QWindow>
#include <app/application.h>
class QQmlApplicationEngine;
class Gui : public QObject
{
    Q_OBJECT
public:
    explicit Gui(QObject *parent = 0);

signals:
    ;
    //outer send signal to wint;

public slots:
    void registerClick();
public:
    void init();
    void showMainWin();
    void hideMainWin();
    bool mainWinIsVisible();
    void showAboutWin();

    QWindow* mainWin;
    QWindow* aboutWin;
private:
    QQmlApplicationEngine *engine;

};
namespace cute{
extern std::unique_ptr<Gui> gui;
}
#endif // GUI_H
