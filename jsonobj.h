#ifndef JSONOBJ_H
#define JSONOBJ_H

#include <QVariant>
#include <QDebug>
#include <QGuiApplication>
#include <QSettings>
#include <QRect>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>
#include <QEventLoop>
#include "network.h"

#define SLEEP(x) {QEventLoop loop; QTimer::singleShot(x, &loop, SLOT(quit())); loop.exec();}
#define FILENAME_JSON "SynCVAS.json"
#define OBJECT_LABEL "area01"

class JsonObj : public QObject
{
    Q_OBJECT

public:
	JsonObj(QObject *parent = 0) : QObject(parent)
	{
#ifdef Q_OS_WIN
		QFile file(qApp->applicationDirPath() + "/" + FILENAME_JSON);
#else
		QFile file("/sdcard/" FILENAME_JSON);	// 何故かこのパスでルートを指す
#endif
		file.open(QFile::ReadWrite);
		QTextStream in(&file);
//		in.setCodec("UTF-8");
		QJsonDocument jsonDoc = QJsonDocument::fromJson(in.readAll().toUtf8());
		file.close();
//		qDebug() << jsonDoc;
		QJsonObject obj = jsonDoc.object();
		QStringList keys = obj.keys();
#if 0
		foreach(QString key, keys){
			qDebug() << "key = " << key;
			qDebug() << "value = " << obj.value(key).toVariant();
		}
#endif
		// ボタンオブジェクトの保存
		QJsonArray arButton = jsonDoc.object().value(OBJECT_LABEL).toArray();
		int idx = 0;
		foreach(QJsonValue value, arButton){
			qDebug() << "value = " << value.toObject();
			m_stBtn[idx].id = value.toObject().value("id").toInt();
			m_stBtn[idx].type = value.toObject().value("type").toString();
			m_stBtn[idx].rect.setRect(value.toObject().value("x").toInt(), value.toObject().value("y").toInt()
								,value.toObject().value("width").toInt(), value.toObject().value("height").toInt());
			m_stBtn[idx].text = value.toObject().value("text").toString();
			m_stBtn[idx].textpos = value.toObject().value("textpos").toInt();
			m_stBtn[idx].image = value.toObject().value("image").toString();
			m_stBtn[idx].imagepos = value.toObject().value("imagepos").toInt();
			m_stBtn[idx].src = value.toObject().value("src").toString();
			m_stBtn[idx].cmd = value.toObject().value("cmd").toString();
			idx++;
		}
		m_nObjCount = idx;
		// マクロの保存（解析後回し）
		m_arMacro = jsonDoc.object().value("macro").toArray();
	}
	~JsonObj()
	{
	}
	Q_INVOKABLE qint32 getObjCount(){return m_nObjCount;}
	Q_INVOKABLE qint32 getId(int idx){return m_stBtn[idx].id;}
	Q_INVOKABLE QString getType(int idx){return m_stBtn[idx].type;}
	Q_INVOKABLE QRect getRect(int idx){return m_stBtn[idx].rect;}
	Q_INVOKABLE QString getText(int idx){return m_stBtn[idx].text;}
	Q_INVOKABLE qint32 getTextPos(int idx){return m_stBtn[idx].textpos;}
	Q_INVOKABLE QString getImage(int idx){return m_stBtn[idx].image;}
	Q_INVOKABLE qint32 getImagePos(int idx){return m_stBtn[idx].imagepos;}
	Q_INVOKABLE QString getSrc(int idx){return m_stBtn[idx].src;}
	Q_INVOKABLE QString getCmd(int idx){return m_stBtn[idx].cmd;}

	// マクロ実行
	Q_INVOKABLE void execMacro(qint32 id)
	{
		qDebug() << "execMacro:" << id;
		foreach(QJsonValue value, m_arMacro)
		{
			qDebug() << value.toObject().value("id").toInt();	// ここで該当するIDを判定
			foreach(QJsonValue jv, value.toObject().value("sequence").toArray())
			{
				if(jv.toObject().value("freecmd").isString())
				{	// 送信する
					QString str = jv.toObject().value("freecmd").toString();
					m_clNetwork.write(str.toLocal8Bit());
				}
				else if(!jv.toObject().value("wait").isNull())
				{	// 待つ
					SLEEP(jv.toObject().value("wait").toInt());
				}
			}
			break;
		}
	}

struct stButton {
	qint32 id;		// ボタンID
	QString type;	// ボタンタイプ
	QRect rect;		// ボタン位置
	QString text;	// テキスト
	qint32 textpos;	// テキスト位置
	QString image;	// 画像
	qint32 imagepos;// 画像位置
	QString src;	// ボタンベース画像
	QString cmd;	// 送信コマンド
	qint32 macro;	// マクロ
};

private:
	Network m_clNetwork;	// ネットワーククラス（マクロ実行用）
	qint32 m_nObjCount;		// オブジェクト数
	stButton m_stBtn[100];	// ボタン群
	QJsonArray m_arMacro;	// マクロ
};
#endif // JSONOBJ_H
