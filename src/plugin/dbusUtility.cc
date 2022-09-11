#include "dbusUtility.h"

#include "systempanel.h"

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
    std::vector<ScreenParams>  vv = SystemPanel().screenInfo();
    for (const ScreenParams v : vv) {
        std::cout << "la " << v.name().toStdString() << "id: " << v.id() << std::endl;
    }
    this->status = "Change status text";
}