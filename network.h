#ifndef NETWORK_H
#define NETWORK_H

#include <QTcpSocket>
#include <QUdpSocket>
#include <QNetworkProxy>
#include <QVariant>
#include <QDebug>
#include <QGuiApplication>
#include <QSettings>
#include <QRect>

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class Network : public QObject
{
    Q_OBJECT

public:
	Network(QObject *parent = 0) : QObject(parent)
	{
		m_pclSocket = new QTcpSocket(this);
		//m_pclSocket->setProxy(QNetworkProxy::NoProxy);
		QNetworkProxyFactory::setUseSystemConfiguration(false);
		connect(m_pclSocket, SIGNAL(connected()), this, SLOT(tcpConnect()));
		connect(m_pclSocket, SIGNAL(disconnected()), this, SLOT(tcpDisconnect()));
		connect(m_pclSocket, SIGNAL(readyRead()), this, SLOT(slotReadyReadLan()));
		connect(m_pclSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(error()));

#ifdef Q_OS_WIN
		QSettings settings(qApp->applicationDirPath() + "\\setting.ini", QSettings::IniFormat);
#else
		QSettings settings("/sdcard/setting.ini", QSettings::NativeFormat);
#endif
		m_strIpaddr = settings.value("IPADDR", "192.168.1.100").toString();
		m_strMacaddr = settings.value("MACADDR", "00099A000000").toString();
	}
	~Network()
	{
		QSettings settings(qApp->applicationDirPath() + "\\setting.ini", QSettings::IniFormat);
		settings.setValue("IPADDR", m_strIpaddr);
		settings.setValue("MACADDR", m_strMacaddr);
	}
	Q_INVOKABLE QString getIpaddr(){return m_strIpaddr;}
	Q_INVOKABLE QString getMacaddr(){return m_strMacaddr;}
	Q_INVOKABLE void setIpaddr(QString str){m_strIpaddr = str;}
	Q_INVOKABLE void setMacaddr(QString str){m_strMacaddr = str;}
	Q_INVOKABLE QRect getRect(int idx){return m_clRect[idx];}
	Q_INVOKABLE void connectToHost(QString strIp, quint16 port)
	{
		if(m_pclSocket->isOpen()){
			m_pclSocket->close();	// 一旦閉じる
		}
		m_pclSocket->connectToHost(strIp, port);
	}
	QByteArray StrToArray(QString data)
	{
		QByteArray arStr;
		while(data.size()){
			arStr.append(data.left(2).toInt(NULL, 16));
			data.remove(0, 2);
		}
		return arStr;
	}
	Q_INVOKABLE void write(QString data)
	{
		m_arReadData = "";
		QStringList strlist = data.split("\\");
		if(strlist.count() < 2){
			m_pclSocket->write(data.toLocal8Bit());
		}
		else{
			QByteArray arData;
			for(int i = 0; i < strlist.count(); i++){
				if(i % 2){
					arData.append(StrToArray(strlist[1]));	// バイナリ変換
				}
				else{
					arData.append(strlist[0].toLocal8Bit());// 無変換
				}
			}
			m_pclSocket->write(arData);
		}
	}
	Q_INVOKABLE QByteArray read(void)
	{
		return m_arReadData;
	}
	Q_INVOKABLE void close()
	{
		m_pclSocket->close();
	}
	Q_INVOKABLE void wakeOnLan(QString strIpaddr, QString strMac)
	{
		QByteArray baMac = QByteArray::fromHex(strMac.toLocal8Bit());
		QByteArray ba6FF = QByteArray::fromHex("FFFFFFFFFFFF");
		QByteArray ba16Mac;
		for (int i = 0; i < 16; i++){
			ba16Mac += baMac;
		}
		QHostAddress FakeAddress;
		FakeAddress.setAddress(strIpaddr);
		QByteArray baWOLSignal = ba6FF + ba16Mac;
		QUdpSocket udpSocket;
		udpSocket.writeDatagram(baWOLSignal, baWOLSignal.size(), FakeAddress, 9);
		qDebug() << "wakeOnLan:" << strIpaddr << "," << strMac;
	}

private:
	QTcpSocket *m_pclSocket;
	QString m_strIpaddr;
	QString m_strMacaddr;
	QByteArray m_arReadData;
	QRect m_clRect[100];

private slots:
	void tcpConnect()
	{
		qDebug() << "connected";
	}
	void tcpDisconnect()
	{
		qDebug() << "disconnected";
	}
	void slotReadyReadLan()
	{
		m_arReadData = m_pclSocket->readAll();
		qDebug() << "recv:" << m_arReadData;
	}
	void error()
	{
		qDebug() << m_pclSocket->errorString();
	}
};
#endif // NETWORK_H
