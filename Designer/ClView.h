#ifndef CLVIEW_H
#define CLVIEW_H

#include <QQuickView>

class ClView : public QQuickView
{
	Q_OBJECT

public:
	explicit ClView(QWindow *parent = nullptr) : QQuickView(parent)
	{
	}
	~ClView(){}
};

#endif // CLVIEW_H
