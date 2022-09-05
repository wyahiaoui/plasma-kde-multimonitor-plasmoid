

#include "systempanel.h"
#include <iostream>
#include <vector>
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>
bool compareScreen(ScreenParams i1, ScreenParams i2)
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
    
        std::cout << "Monitor " << i << " : " << XGetAtomName(display, info->name) << " " << info->height << " " << info->width << std::endl;
        std::cout << "Position: " << info->x << ", " << info->y << std::endl;
        // ScreenParams screen = ScreenParams( XGetAtomName(display, info->name), i++, info->width, info->height, info->x, info->y);
        // std::cout << "paras" << screen.width() << screen.height() << std::endl;
        screens.push_back(ScreenParams( XGetAtomName(display, info->name), i++, info->width, info->height, info->x, info->y));
        // i++;
        info++;
        // return ScreenParams( XGetAtomName(display, info->name), info->width, info->height, info->x, info->y);

    }
    XCloseDisplay(display); 
    sort(screens.begin(), screens.end(),  compareScreen);
    return screens;
}

QString SystemPanel::test() {
    return QString("3asslema");
}
