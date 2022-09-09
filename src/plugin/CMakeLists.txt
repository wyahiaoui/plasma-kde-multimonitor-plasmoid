set(plasmoidplugin_SRCS
    plasmoidplugin.cpp
    systempanel.cpp
    dbusUtility.cc
    )

find_package(X11 MODULE)
# find_package(DBus REQUIRED)

link_libraries(${X11_LIBRARIES})

# include_directories(${DBUS_INCLUDE_DIRS})
include_directories(${X11_INCLUDE_DIR})
add_library(plasmoidplugin SHARED ${plasmoidplugin_SRCS})

# target_link_libraries(plasmoidplugin "-lX11" "-lXrandr")
target_link_libraries(plasmoidplugin Qt5::Quick Qt5::Core KF5::Plasma ${X11_LIBRARIES} "-lXrandr" Qt5::DBus)

install(TARGETS plasmoidplugin DESTINATION ${QML_INSTALL_DIR}/org/kde/private/multimonitor)

install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/private/multimonitor)
