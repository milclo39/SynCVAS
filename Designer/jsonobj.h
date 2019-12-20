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

#define FILENAME_JSON "SynCVAS.json"
#define OBJECT_LABEL "area01"

class JsonObj : public QObject
{
	Q_OBJECT

public:
	JsonObj(QObject *parent = nullptr) : QObject(parent)
	{
	}
	~JsonObj()
	{
	}
	Q_INVOKABLE void readCurrentJson()
	{
#ifdef Q_OS_WIN
		readJson(qApp->applicationDirPath() + "/" + FILENAME_JSON);
#else
		readJson("/sdcard/" + FILENAME_JSON);	// 何故かこのパスでルートを指す
#endif
	}
	Q_INVOKABLE void writeCurrentJson()
	{
#ifdef Q_OS_WIN
		writeJson(qApp->applicationDirPath() + "/" + FILENAME_JSON);
#else
		writeJson("/sdcard/" + FILENAME_JSON);
#endif
	}
	void readJson(QString strFile)
	{
		QFile file(strFile);
		file.open(QFile::ReadWrite);
		QTextStream in(&file);
		QJsonDocument jsonDoc = QJsonDocument::fromJson(in.readAll().toUtf8());
		file.close();
	
		QJsonObject obj = jsonDoc.object();
		m_clJsonObj = obj;
		QStringList keys = obj.keys();
		foreach(QString key, keys){
			qDebug() << "key = " << key;
			qDebug() << "value = " << obj.value(key).toString();
		}
		QJsonArray array = jsonDoc.object().value(OBJECT_LABEL).toArray();
		int idx = 0;
		foreach(QJsonValue value, array){
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
	}
	void writeJson(QString strFile)
	{
		QJsonArray array;
		for(int idx = 0; idx < m_nObjCount; idx++){
			QJsonObject obj;
			obj["id"] = m_stBtn[idx].id;
			obj["type"] = m_stBtn[idx].type;
			obj["x"] = m_stBtn[idx].rect.x();
			obj["y"] = m_stBtn[idx].rect.y();
			obj["width"] = m_stBtn[idx].rect.width();
			obj["height"] = m_stBtn[idx].rect.height();
			obj["text"] = m_stBtn[idx].text;
			obj["textpos"] = m_stBtn[idx].textpos;
			obj["image"] = m_stBtn[idx].image;
			obj["imagepos"] = m_stBtn[idx].imagepos;
			obj["src"] = m_stBtn[idx].src;
			obj["cmd"] = m_stBtn[idx].cmd;
			array.append(obj);
		}
		m_clJsonObj[OBJECT_LABEL] = array;
		QJsonDocument jsonDoc(m_clJsonObj);

		QFile file(strFile);
		file.open(QFile::WriteOnly);
		QTextStream out(&file);
		out << jsonDoc.toJson();
		file.close();
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

	Q_INVOKABLE qint32 addObjCount(){m_stBtn[m_nObjCount].id = m_nObjCount;return m_nObjCount++;}
	Q_INVOKABLE void setType(int idx, QString type){m_stBtn[idx].type = type;}
	Q_INVOKABLE void setRect(int idx, QRect rect){m_stBtn[idx].rect = rect;}
	Q_INVOKABLE void setText(int idx, QString text){m_stBtn[idx].text = text;}
	Q_INVOKABLE void setTextPos(int idx, qint32 textpos){m_stBtn[idx].textpos = textpos;}
	Q_INVOKABLE void setImage(int idx, QString image){m_stBtn[idx].image = image;}
	Q_INVOKABLE void setImagePos(int idx, qint32 imagepos){m_stBtn[idx].imagepos = imagepos;}
	Q_INVOKABLE void setSrc(int idx, QString src){m_stBtn[idx].src = src;}
	Q_INVOKABLE void setCmd(int idx, QString cmd){m_stBtn[idx].cmd = cmd;}

	Q_INVOKABLE void execMacro(qint32 id)
	{
		qDebug() << "execMacro:" << id;
	}

//ボタン情報構造体
struct stButton {
	qint32 id;		// ボタンID
	QString type;	// ボタンタイプ
	QRect rect;		// ボタン位置
	QString text;	// テキスト
	qint32 textpos;	// テキスト位置
	QString image;	// 画像
	qint32 imagepos;// 画像位置
	QString src;	// ボタン画像
	QString cmd;	// 送信コマンド
};

private:
	QJsonObject m_clJsonObj;	// 読みだしたJson情報
	qint32 m_nObjCount;			// オブジェクト数
	stButton m_stBtn[100];		// ボタン情報
};
#endif // JSONOBJ_H
