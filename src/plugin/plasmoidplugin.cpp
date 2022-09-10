
#include "plasmoidplugin.h"
#include "systempanel.h"
#include "dbusUtility.h"

#include <QtQml>
#include <QDebug>

void PlasmoidPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.private.multimonitor"));
    
   
    // qmlRegisterType<DesktopEventWatcher>(uri, 1, 0, "DesktopEventWatcher");
    qmlRegisterType<SystemPanel>(uri, 1, 0, "SystemPanel");
    // qmlRegisterType<ScreenParams>(uri, 1, 0, "ScreenParams");
    // qRegisterMetaType<ScreenParams>();
    qRegisterMetaType<std::vector<ScreenParams>>();
}
