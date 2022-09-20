
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
                Layout.alignment: Qt.AlignLeft
                Text {
                    text: "profiles"
                    color: "white"
                }
                Row {
                    id: profilesRow
                    spacing: 25
                    Column {
                        Rectangle {
                            id: rect
                            color: "white"
                            width: 100; height: 100
                            x: 20   
                            Item {
                                id: profileItem
                                ListModel {
                                    id: profilesModel
                                    Component.onCompleted : {
                                        var  profiles = systemPanel.readConfig();
                                        for (var i = 0; i < profiles.length; i++) {
                                            profilesModel.append(profiles[i])
                                        }
                                    }
                                }
                                
                                ListView {
                                    id: listView
                                    property int savedIndex : 0

                                    width: 100; height: 100
                                    model: profilesModel
                                    delegate: Text {
                                            text: name + ": " + id
                                            color: "black"
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: listView.currentIndex = index
                                            }
                                    }
                                    highlight: Rectangle {
                                        color: 'grey'
                                    }
                                    // onCurrentIndexChanged:{
                                    //     console.log("Current index changed")
                                    //     if(currentIndex !==0){
                                    //         savedIndex = currentIndex
                                    //     }
                                    // }
                                    onModelChanged: {
                                        if (currentIndex > savedIndex) {
                                            profilesModel.insert(savedIndex, profilesModel.get(currentIndex))                                
                                            profilesModel.remove(currentIndex + 1)
                                            
                                        }
                                        else if (currentIndex < savedIndex) {
                                            profilesModel.insert(currentIndex, profilesModel.get(savedIndex))
                                            profilesModel.remove(savedIndex + 1)
                                        }
                                        currentIndex = savedIndex;
                                    }
                                    focus: true
                                }
                            }

                        }
                    }
                    Column {
                        PlasmaComponents3.Button {
                            icon.name: "go-up-symbolic"
                            onClicked: {
                                if (listView.currentIndex > 0) {
                                    listView.savedIndex = listView.currentIndex - 1  
                                    listView.onModelChanged()
                                }
                            }
                        }
                        PlasmaComponents3.Button {
                            icon.name: "go-down-symbolic.svg"
                            onClicked: {
                                if (listView.currentIndex < profilesModel.count) {
                                    listView.savedIndex = listView.currentIndex + 1  
                                    listView.onModelChanged()
                                }
                            }
                        }
                    }
                }
            }
            
        }
        Column {
            PlasmaComponents3.Button {
                icon.name: "view-refresh-symbolic"
                onClicked: {
                    systemPanel.refresh()
                }
            }

            PlasmaComponents3.Button {
                icon.name: "edit-delete-symbolic"
                onClicked: {

                }
            }


            PlasmaComponents3.Button {
                icon.name: "edit-undo-symbolic"
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
        Column {
            TextInput {
                id: blabla
                text: root.str
            }
        }
        

       

    
    }

}
