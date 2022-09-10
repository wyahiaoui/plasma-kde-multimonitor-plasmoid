
#ifndef SYSTEM_PANEL_H
#define SYSTEM_PANEL_H

#define DST_FILE "/.config/plasma-org.kde.plasma.desktop-appletsrc"

// #define DST_FILE "/TTplasma-org.kde.plasma.desktop-appletsrc"

#include <QObject>
#include <QtQml>
#include <string>
#include <fstream>
#include <streambuf>
#include <vector>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>

class ScreenParams
{
    Q_GADGET
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(int x READ x WRITE setX)
    Q_PROPERTY(int y READ y WRITE setY)
    Q_PROPERTY(int height READ height WRITE setHeight)
    Q_PROPERTY(int width READ width WRITE setWidth)

public:
    ScreenParams() {}
    ScreenParams(std::string name, int id, int width, int height, int x, int y) {
        m_name = QString::fromUtf8(name.c_str());
        m_id = id;
        m_width = width;
        m_height = height;
        m_x = x; 
        m_y = y;
    }
    ~ScreenParams() {

    }
    QString name() const { return m_name; }
    void setName(const QString &name) { m_name = name; }
    int id() const { return m_id; }
    void setId(const int id) { m_id = id; }
    int x() const { return m_x; }
    void setX(const int x) { m_x = x; }
    int y() const { return m_y; }
    void setY(const int y) { m_y = y; }
    int height() const { return m_height; }
    void setHeight(const int height) { m_height = height; }
    int width() const { return m_width; }
    void setWidth(const int width) { m_width = width; }

private:
    QString m_name;
    int m_id;
    int m_x;
    int m_y;
    int m_height;
    int m_width;
};

Q_DECLARE_METATYPE(ScreenParams)

class SystemPanel : public QObject
{
    Q_OBJECT
    // QML_ELEMENT
public:
    SystemPanel( QObject *parent = 0);
    ~SystemPanel();
    // Q_INVOKABLE 
public Q_SLOTS:
    int refresh();
    int monitorCount();
    std::vector<ScreenParams> screenInfo();
    QString read_file(const char *filename =  DST_FILE);
    void write_fileRefresh(QString content, const char *filename =  nullptr);
    void write_fileDst(QString content, QString filename);
};

#endif
