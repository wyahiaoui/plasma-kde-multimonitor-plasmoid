

#include "systempanel.h"
#include <iostream>

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
        screens.push_back(ScreenParams( XGetAtomName(display, info->name), i++, info->width, info->height, info->x, info->y));
        info++;
    }
    XCloseDisplay(display); 
    sort(screens.begin(), screens.end(),  compareScreen);
    return screens;
}

QString SystemPanel::homeDirectory() {
    const char *homedir = NULL;
    struct passwd* pwd = getpwuid(getuid());
    if (pwd)
    {
        homedir = pwd->pw_dir;
    }
    else if ((homedir = getenv("HOME")) == NULL) {
        homedir = getpwuid(getuid())->pw_dir;
    }
    return  QString::fromUtf8(homedir);
}



QString SystemPanel::read_file(const char *filename) {
    std::ifstream t(filename);
    std::string str;

    // t.seekg(0, std::ios::end);   
    // str.reserve(t.tellg());
    // t.seekg(0, std::ios::beg);

    str.assign((std::istreambuf_iterator<char>(t)),
                std::istreambuf_iterator<char>());
    return QString::fromUtf8(str.c_str());
}

void SystemPanel::write_file(const char *filename, const char* content) {
    std::ofstream plasmaConfig(filename);
    plasmaConfig >> content;
}