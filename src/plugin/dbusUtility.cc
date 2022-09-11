#include "dbusUtility.h"



void dBusPlasmaRefrech() {
    QDBusConnection bus = QDBusConnection::sessionBus();
    QDBusInterface dbus_iface("org.kde.plasmashell", "/PlasmaShell",
                              "org.kde.PlasmaShell", bus);
    dbus_iface.call("refreshCurrentShell");

}

DesktopEventWatcher::DesktopEventWatcher(QObject *parent) :
    QObject(parent)
{

    QDBusConnection::sessionBus().connect("org.kde.KScreen", "/backend", "org.kde.kscreen.Backend" ,"configChanged", this, SLOT(kscreenStatus()));

    this->status = "Change status text";
}