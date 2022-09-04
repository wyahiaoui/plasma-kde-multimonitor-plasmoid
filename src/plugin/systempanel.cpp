/*
    Copyright (c) 2016 Carlos López Sánchez <musikolo{AT}hotmail[DOT]com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "systempanel.h"
#include <iostream>
#include <vector>
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>

SystemPanel::SystemPanel(QObject *parent) : QObject(parent) {
}

SystemPanel::~SystemPanel() {
}

int SystemPanel::turnOffScreen(){
    
    const int result = system("/usr/bin/xset dpms force off");
    
    return result;
}

ScreenParams SystemPanel::screenInfo(){
    
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
        screens.push_back(ScreenParams( XGetAtomName(display, info->name), info->width, info->height, info->x, info->y));
        std::cout << "Monitor " << i++ << " : " << XGetAtomName(display, info->name) << " " << info->height << " " << info->width << std::endl;
        std::cout << "Position: " << info->x << ", " << info->y << std::endl;
        info++;
        return ScreenParams( XGetAtomName(display, info->name), info->width, info->height, info->x, info->y);

    }
    XCloseDisplay(display); 
    return screens[0];
}

QString SystemPanel::test() {
    return QString("3asslema");
}