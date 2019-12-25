#ifndef CLVIEW_H
#define CLVIEW_H

#include <QQuickView>
#include <QDebug>

class ClView : public QQuickView
{
	Q_OBJECT

public:
	explicit ClView(QWindow *parent = nullptr) : QQuickView(parent)
	{
	}
	~ClView(){}
protected:
	// 閉じるイベント
	void closeEvent(QCloseEvent* ce)
	{
		qDebug() << "ahoaho";
		ce->ignore();
	}
};

#endif // CLVIEW_H
