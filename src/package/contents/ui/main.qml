
import QtQuick 2.1
import QtQuick.Layouts 1.11
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents3

import org.kde.private.multimonitor 1.0 as WW;

// import "../code/widgetHandler.js" as WidgetHandler
Item {
    id: root
    // property var desktopWatcherPlugin: WW.DesktopEventWatcher {}
    property var str: "freeeee"
    readonly property int minButtonSize: units.iconSizes.small
    readonly property int medButtonSize: units.iconSizes.medium
    readonly property int maxButtonSize: units.iconSizes.large
    Layout.minimumWidth: minButtonSize * screenViews.columns
    Layout.minimumHeight: minButtonSize * screenViews.rows

    Layout.maximumWidth: maxButtonSize * screenViews.columns
    Layout.maximumHeight: maxButtonSize * screenViews.rows
    
    readonly property int iconSize: {
        var value = 0
        if(plasmoid.formFactor != PlasmaCore.Types.Vertical){
            value = height / screenViews.rows
        }
        else {
            value = width / screenViews.columns
        }
        
        if(value < minButtonSize){
            value = minButtonSize
        }
        
        return value
    }
    
    SystemPanel {
        id: systemPanel
        
    }
    

    WW.DesktopEventWatcher {
        id: desktopEventWatcher
        status: blabla.text
        onStatusChanged: {
            console.log("lelel");
        }
    }


    Layout.preferredWidth: (iconSize  * screenViews.columns)
    Layout.preferredHeight: (iconSize  * screenViews.rows)
    
    // PlasmaCore.DataSource {
    //     id: hpSource
    //     engine: "hotplug"
    //     connectedSources: sources
    //     interval: 1

    //     onSourceAdded: {
    //         // disconnectSource(source);
    //         // connectSource(source);
    //         // sdSource.connectedSources = sources
    //         console.log("Addsource", source);
    //     }
    //     onSourceRemoved: {
    //         console.log("source", source);
    //         // disconnectSource(source);
    //     }
    //     onDataChanged: {
    //         console.log("changed", sources);
    //     }

    // }

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation 


    ColumnLayout {
        id: columnPage
        ScreenGridView {
            id: screenViews
        }
        RowLayout {
            spacing:( iconSize  * screenViews.columns ) / (screenViews.items.length - 1)
            Row {
                Layout.alignment: Qt.AlignLeft
                // anchors.margin: 4
                PlasmaComponents3.Button {
                    icon.name: "view-refresh-symbolic"
                    // tooltip: i18n("Refresh")
                    onClicked: {
                        systemPanel.refresh()
                    }
                }

                PlasmaComponents3.Button {
                    icon.name: "document-revert-symbolic"
                    // tooltip: i18n("Refresh")
                }

                PlasmaComponents3.Button {
                    icon.name: "document-save-symbolic"
                    onClicked: {
                        var conf = systemPanel.readData();
                        systemPanel.writeData(conf)
                        
                    }
                }
            }

            TextInput {
                // Layout.alignment: Qt.AlignRight
                text: screenViews.vmPlaceHolder
                color: "white"
            }
                TextInput {
        id: blabla
        text: root.str
    }
            // Rectangle {
            //     color: "red"
            //     Layout.preferredWidth: 40
            //     Layout.preferredHeight: 40
            //     Layout.alignment: Qt.AlignCenter

            // }

        }
    }
}
