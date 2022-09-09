

#include "systempanel.h"
#include <iostream>

#include "dbusUtility.h"


static bool compareScreen(ScreenParams i1, ScreenParams i2)
{
    return (i1.x() < i2.x());
}

SystemPanel::SystemPanel(QObject *parent) : QObject(parent) {
}

SystemPanel::~SystemPanel() {
}

int SystemPanel::turnOffScreen(){
    
    const int result = system("/usr/bin/xset dpms force off");
    
    return result;
}

int SystemPanel::monitorCount(){
    int monitor_count = 0;
    auto display = XOpenDisplay(NULL);
    if (display == NULL)
    {
        std::cout << "Failed to open display!" << std::endl;
        return {};
    }
    auto wnd = XDefaultRootWindow(display);
    XRRMonitorInfo *info = XRRGetMonitors(display, wnd, 0, &monitor_count);
    return monitor_count;
}

std::vector<ScreenParams> SystemPanel::screenInfo(){
    
    int monitor_count = 0;

    auto display = XOpenDisplay(NULL);
    if (display == NULL)
    {
        std::cout << "Failed to open display!" << std::endl;
        return {};
    }

    auto wnd = XDefaultRootWindow(display);

    // 0 = active, 1 = inactive, call it twice to get a full list, if there are 
    // inactive monitors
    XRRMonitorInfo *info = XRRGetMonitors(display, wnd, 0, &monitor_count);
    std::cout << "There are " << monitor_count << " monitor(s) in system." << std::endl;

    int i = 0;
    std::vector<ScreenParams> screens;
    while (i < monitor_count)
    {
        screens.push_back(ScreenParams( XGetAtomName(display, info->name), i++, info->width, info->height, info->x, info->y));
        info++;
    }
    XCloseDisplay(display); 
    sort(screens.begin(), screens.end(),  compareScreen);
    return screens;
}

static const char * homeDirectory() {
    const char *homedir = NULL;
    struct passwd* pwd = getpwuid(getuid());
    if (pwd)
    {
        homedir = pwd->pw_dir;
    }
    else if ((homedir = getenv("HOME")) == NULL) {
        homedir = getpwuid(getuid())->pw_dir;
    }
    return  homedir;
}



QString SystemPanel::read_file(const char *filename) {
    std::ifstream t(std::string(homeDirectory()) + std::string(filename));
    std::string str;

    // t.seekg(0, std::ios::end);   
    // str.reserve(t.tellg());
    // t.seekg(0, std::ios::beg);

    str.assign((std::istreambuf_iterator<char>(t)),
                std::istreambuf_iterator<char>());
    return QString::fromUtf8(str.c_str());
}

void SystemPanel::write_file(QString content) {
    std::ofstream plasmaConfig(std::string(homeDirectory()) + std::string(DST_FILE));
    // std::ofstream plasmaConfig(std::string("ttPlamas"));
    plasmaConfig << content.toStdString();
    dBusPlasmaRefrech();
    // std::system("kquitapp5 plasmashell || killall plasmashell");
    // std::system("kstart5 plasmashell");
    // std::system("qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell");
}


int lid_state() {
    // dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames
    // qdbusviewer
    // https://sleeplessbeastie.eu/2013/02/26/how-to-automate-kde-using-d-bus/
    //  cat /proc/acpi/button/lid/LID/state 
    // qdbus org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement isLidClosed
    // qdbus org.kde.KScreen /backend getConfig
    // less /sys/firmware/acpi/interrupts/sci
    // udevadm monitor
    return 0;
}