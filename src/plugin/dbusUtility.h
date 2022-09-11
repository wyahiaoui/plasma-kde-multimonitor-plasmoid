#ifndef DBUS_UTILITY_H
#define DBUS_UTILITY_H

#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDBusInterface>
#include <QDBusReply>

#include <QDebug>
void dBusPlasmaRefrech();

#include <iostream>
#include <QtQml>
#include <QObject>


#include "systempanel.h"
// #include <QtQml/qqmlregistration.h>

class DesktopEventWatcher : public QObject
{
        Q_OBJECT
        Q_PROPERTY(QString status MEMBER status NOTIFY statusChanged)
        Q_PROPERTY(int config MEMBER config NOTIFY configChanged)
        // QML_ELEMENT
    private:
        QString status;
        int config;
    public:
        explicit DesktopEventWatcher(QObject *parent = nullptr);
        ~DesktopEventWatcher() {};
        void changeStatus()
        {
            std::cout << "changeStatus called" << std::endl; // The function definitely gets called!
            this->status = "Change status again!";
        }
        
        void setConfig(int dd)
        {
            config = dd;
            emit configChanged(dd);
        }

        void setStatus(QString value)
        {
            std::cout << "changeStatus Yes" << std::endl;

            if (value != status)
            {
                status = value;
                emit statusChanged(value);
            }
        }
    public slots:
        void outputStatus(const QString &status) {
            std::cout << "c++ " << status.toStdString() << std::endl;
        }

        void kscreenStatus() {
            setConfig(config + 1);
            std::cout << "kscreen " << status.toStdString() << std::endl;
            std::vector<ScreenParams>  vv = SystemPanel().screenInfo();
            for (const ScreenParams v : vv) {
                std::cout << "la " << v.name().toStdString() << "id: " << v.id() << std::endl;
            }
        }

    signals:
        void statusChanged(const QString &status);
        void configChanged(const int &value);

};

#endif