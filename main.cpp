#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "network.h"
#include "jsonobj.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<Network>("Network", 1, 0, "Network");
    qmlRegisterType<JsonObj>("JsonObj", 1, 0, "JsonObj");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
