set(plasmoidplugin_SRCS
    plasmoidplugin.cpp
    systempanel.cpp
    )

find_package(X11 MODULE)
link_libraries(${X11_LIBRARIES})
include_directories(${X11_INCLUDE_DIR})
add_library(plasmoidplugin SHARED ${plasmoidplugin_SRCS})

# target_link_libraries(plasmoidplugin "-lX11" "-lXrandr")
target_link_libraries(plasmoidplugin Qt5::Quick Qt5::Core KF5::Plasma "-lX11" "-lXrandr")

install(TARGETS plasmoidplugin DESTINATION ${QML_INSTALL_DIR}/org/kde/private/multimonitor)

install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/private/multimonitor)
