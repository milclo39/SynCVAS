#ifndef HELPER_H
#define HELPER_H

#include <QVariant>
#include <QDebug>
#include <QGuiApplication>
#include <QProcess>

class Helper : public QObject
{
    Q_OBJECT

public:
	Helper(QObject *parent = nullptr) : QObject(parent){}
	~Helper(){}
	Q_INVOKABLE void execProcess(bool exec)
	{
		if(exec){
			if(!m_clProc){
				m_clProc = new QProcess(this);
				m_clProc->start("SynCVAS.exe");
			}
		}
		else if(m_clProc){
			m_clProc->kill();
			m_clProc = nullptr;
		}
	}
private:
	QProcess *m_clProc = nullptr;
};
#endif // HELPER_H
