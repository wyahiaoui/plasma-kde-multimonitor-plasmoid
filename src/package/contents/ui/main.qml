
import QtQuick 2.1
import QtQuick.Layouts 1.11
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents3

import org.kde.private.multimonitor 1.0 as WW;

import "../code/widgetHandler.js" as WidgetHandler
Item {
    id: root
    // property var desktopWatcherPlugin: WW.DesktopEventWatcher {}
    property var str: "freeeee"
    readonly property int minButtonSize: units.iconSizes.small
    readonly property int medButtonSize: units.iconSizes.medium
    readonly property int maxButtonSize: units.iconSizes.large
    // Layout.minimumWidth: minButtonSize * screenViews.columns
    Layout.minimumHeight: minButtonSize * (screenViews.rows)

    // Layout.maximumWidth: maxButtonSize * screenViews.columns
    // Layout.maximumHeight: maxButtonSize * (screenViews.rows + 10)
    
    readonly property int iconSize: {
        var value = 0
        if(plasmoid.formFactor != PlasmaCore.Types.Vertical){
            value = height / (screenViews.rows ) + 1
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
        status: ""
        onConfigChanged: {
            console.log("lelel");
            screenViews.model = systemPanel.screenInfo()
            screenViews.updatePlasmoids(0)
        }
    }

 
    Layout.preferredWidth: (iconSize  * screenViews.columns)
    Layout.preferredHeight: iconSize  * (screenViews.rows + 1)
    

    Plasmoid.compactRepresentation: Image {source: "../images/computer-screen-svgrepo-com.svg"}
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation 


    Grid {
        id: columnPage
        Column {
            Layout.alignment: Qt.AlignRight
            ScreenGridView {
                id: screenViews
            }
            ColumnLayout {
                id: layout_column
                // Column {
                Layout.alignment: Qt.AlignLeft
                Text {
                    text: "profiles"
                    color: "white"
                }
                // }
                // y: 50
                Row {
                    spacing: 25
                    Column {

                        Rectangle {
                            id: rect
                            color: "white"
                            width: 100; height: 100
                            x: 20   
                            Item {
                                id: contactDelegate
                                ListView {
                                    id: listView
                                    width: 100; height: 100
                                    // y: 30
                                    model:systemPanel.screenInfo()
                                    delegate: 
                                    // Row {
                                        Text {
                                            text: modelData.name + ": " + modelData.id
                                            color: "black"
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: listView.currentIndex = index
                                            }
                                    }
                                    highlight: Rectangle {
                                        color: 'grey'
                                        Text {
                                            anchors.centerIn: parent
                                            text: 'Hello ' + model.get(list.currentIndex).name
                                            color: 'white'
                                        }
                                    }
                                    focus: true
                                    // }

                                }
                            }

                        }
                    }
                    Column {
                        PlasmaComponents3.Button {
                            icon.name: "go-up-symbolic"
                            // tooltip: i18n("Refresh")
                            onClicked: {
    
                            }
                        }
                        PlasmaComponents3.Button {
                            icon.name: "go-up-symbolic.svg"
                            // tooltip: i18n("Refresh")
                            onClicked: {
    
                            }
                        }
                    }
                }
            }
            
        }
        Column {
            ColumnLayout {
                // spacing:( iconSize  * screenViews.columns ) / (screenViews.items.length - 1)
                Column {
                    // y: 80
                    // Layout.alignment: Qt.AlignLeft
                    // anchors.margin: 4
                    PlasmaComponents3.Button {
                        icon.name: "view-refresh-symbolic"
                        // tooltip: i18n("Refresh")
                        onClicked: {
                            systemPanel.refresh()
                        }
                    }

                    PlasmaComponents3.Button {
                        icon.name: "edit-delete-symbolic"
                        // tooltip: i18n("Refresh")
                        onClicked: {
  
                        }
                    }


                    PlasmaComponents3.Button {
                        icon.name: "edit-undo-symbolic"
                        // tooltip: i18n("Refresh")
                        onClicked: {
                            // console.log("YALALALLewlj", plasmoid.configuration.ignoredPlasmoid)
                            const conf = WidgetHandler.removeApplets(systemPanel.readData())
                            systemPanel.writeData(conf)
                        }
                    }

                    PlasmaComponents3.Button {
                        icon.name: "document-save-symbolic"
                        onClicked: {
                            var conf = systemPanel.readData();
                            systemPanel.writeData(conf)
                            
                        }
                    }
                }



                // Rectangle {
                //     color: "red"
                //     Layout.preferredWidth: 40
                //     Layout.preferredHeight: 40
                //     Layout.alignment: Qt.AlignCenter

                // }

            }
        }
        Column {
            TextInput {
                id: blabla
                text: root.str
            }
        }
        

       

    
    }

}
