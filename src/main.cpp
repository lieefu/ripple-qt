#include <QApplication>
#include <app/application.h>
int main(int argc, char *argv[])
{

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

#ifdef Q_OS_LINUX
    QFont font;
    font.setFamily("WenQuanYi Micro Hei");
    qApp->setFont(font);
#endif
    cute::app = std::make_unique<Application>();
    cute::app->run();

    return app.exec();
}
