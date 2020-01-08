#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTextCodec>
#include <QTranslator>
#include "helper.h"
#include "jsonobj.h"
#include "ClView.h"

void supportLocalize()
{
	QTextCodec::setCodecForLocale(QTextCodec::codecForLocale());

	QLocale clLocale = QLocale::system().language();

	if(clLocale.language() == QLocale::Japanese){
		QLocale::setDefault( QLocale( QLocale::Japanese ) );
		QTranslator *pTrans = new QTranslator();
		if(pTrans->load(":/lang/ja") == true){
			qApp->installTranslator(pTrans);
		}
	}
	else{
		QLocale::setDefault( QLocale( QLocale::English ) );
		QTranslator *pTrans = new QTranslator();
		if(pTrans->load(":/lang/en") == true){
			 qApp->installTranslator(pTrans);
		}
	}
}

int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QGuiApplication app(argc, argv);
	supportLocalize();
	qmlRegisterType<Helper>("Helper", 1, 0, "Helper");
	qmlRegisterType<JsonObj>("JsonObj", 1, 0, "JsonObj");
#if 1
	QQmlApplicationEngine engine;
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
#else
	ClView view;
	QObject::connect(view.engine(), SIGNAL(quit()), qApp, SLOT(quit()));
	view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
#endif
	return app.exec();
}
