cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

project(multiMonitor)
set(QT_MIN_VERSION "5.15.0")
set(KF5_MIN_VERSION "5.0.0")

set(CMAKE_AUTOMOC ON)

# option(WITH_X11 "Build with X11 support. Building without is experimental" ON)
find_package(ECM 0.0.11 REQUIRED NO_MODULE)



# add_compile_options(-Wall -lX11 -lXrandr -lstdc++)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)
include(FeatureSummary)

find_package(X11 MODULE)
link_libraries(${X11_LIBRARIES})
include_directories(${X11_INCLUDE_DIR})

# find_package(Xrandr REQUIRED)

set_package_properties(X11 PROPERTIES DESCRIPTION "X11 libraries"
                        URL "https://www.x.org/"
                        TYPE OPTIONAL
                        )

find_package(Qt5 ${REQUIRED_QT_VERSION} CONFIG REQUIRED Quick DBus)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Plasma)
# target_link_libraries(-lX11 -lXrandr)


add_subdirectory(plugin)
# add_subdirectory(translations)


# set(PLASMA_RELATIVE_DATA_INSTALL_DIR "plasma/plasmoids/org.kde.plasma.multimonitor/contents")
# set(PLASMA_DATA_INSTALL_DIR "${KDE_INSTALL_DATADIR}/${PLASMA_RELATIVE_DATA_INSTALL_DIR}")

# install(DIRECTORY package/contents/images DESTINATION ${PLASMA_DATA_INSTALL_DIR})

plasma_install_package(package org.kde.plasma.multimonitor)

# install( DIRECTORY image/breeze-dark DESTINATION ${ICON_INSTALL_DIR})
