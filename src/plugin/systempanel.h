
#ifndef SYSTEM_PANEL_H
#define SYSTEM_PANEL_H


#include <QObject>
#include <QtQml>
#include <string>

class ScreenParams
{
    Q_GADGET
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(int x READ x WRITE setX)
    Q_PROPERTY(int y READ y WRITE setY)
    Q_PROPERTY(int height READ height WRITE setHeight)
    Q_PROPERTY(int width READ width WRITE setWidth)

public:
    ScreenParams() {}
    ScreenParams(std::string name, int width, int height, int x, int y) {
        m_name = QString::fromUtf8(name.c_str());
        m_x = x; 
        m_y = y;
        m_height = height;
        m_width = width;
    }
    ~ScreenParams() {

    }
    QString name() const { return m_name; }
    void setName(const QString &name) { m_name = name; }
    int x() const { return m_x; }
    void setX(const int x) { m_x = x; }
    int y() const { return m_y; }
    void setY(const int y) { m_y = y; }
    int height() const { return m_x; }
    void setHeight(const int height) { m_height = height; }
    int width() const { return m_x; }
    void setWidth(const int width) { m_width = width; }

private:
    QString m_name;
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
    int turnOffScreen();
    ScreenParams screenInfo();
    QString test();
};

#endif
