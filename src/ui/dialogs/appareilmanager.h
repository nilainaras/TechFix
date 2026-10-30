#ifndef APPAREILMANAGER_H
#define APPAREILMANAGER_H

#include <QObject>

class AppareilManager : public QObject
{
    Q_OBJECT
public:
    explicit AppareilManager(QObject *parent = nullptr);

signals:
};

#endif // APPAREILMANAGER_H
