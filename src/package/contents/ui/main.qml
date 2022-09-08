
import QtQuick 2.1
import QtQuick.Layouts 1.11
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.private.multimonitor 1.0 as WW;

import "../code/widgetHandler.js" as WidgetHandler
Item {
    id: root
    property var systemPanelPlugin: WW.SystemPanel {}
    readonly property int minButtonSize: units.iconSizes.small
    readonly property int medButtonSize: units.iconSizes.medium
    readonly property int maxButtonSize: units.iconSizes.large

    Layout.minimumWidth: minButtonSize * itemGrid.columns
    Layout.minimumHeight: minButtonSize * itemGrid.rows

    Layout.maximumWidth: maxButtonSize * itemGrid.columns
    Layout.maximumHeight: maxButtonSize * itemGrid.rows
    
    readonly property int iconSize: {
        var value = 0
        if(plasmoid.formFactor != PlasmaCore.Types.Vertical){
            value = height / itemGrid.rows
        }
        else {
            value = width / itemGrid.columns
        }
        
        if(value < minButtonSize){
            value = minButtonSize
        }
        
        return value
    }
    
    SystemPanel {
        id: systemPanel
        
    }
    
    Layout.preferredWidth: (iconSize  * itemGrid.columns)
    Layout.preferredHeight: (iconSize  * itemGrid.rows)

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    
    PlasmaCore.DataSource {
        id: dataEngine
        engine: "powermanagement"
        connectedSources: ["Sleep States","PowerDevil"]
    }
    
    Grid {
        id: itemGrid
        property string vmPlaceHolder: WidgetHandler.countsApplets(items.dataConfig)
        readonly property int numVisibleButtons: (visibleChildren.length - 1)
        
        rows: {
            var value = plasmoid.configuration.rows
            if(plasmoid.configuration.inlineBestFit){
                if(plasmoid.formFactor != PlasmaCore.Types.Vertical){
                    value = 1;
                }
                else {
                    value = numVisibleButtons
                }
            }
            
            return value
        }
        columns: {
            var value = plasmoid.configuration.columns
            if(plasmoid.configuration.inlineBestFit){
                if(plasmoid.formFactor === PlasmaCore.Types.Vertical){
                    value = 1;
                }
                else {
                    value = numVisibleButtons
                }
            }
            
            return value
        }
        spacing: 0
        width: parent.width
        height: parent.height
        Repeater {
            property int itemWidth: Math.floor(parent.width/parent.columns)
            property int itemHeight: Math.floor(parent.height/parent.rows)
            property int iconSize: Math.min(itemWidth, itemHeight)
            property string dataConfig: ""
            id: items
            model: systemPanel.screenInfo()
            delegate: 
                Image {
                    id: screenImg
                    property int widgetCount: 0
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: true
                    fillMode: Image.PreserveAspectFit
                    source: "../../../image/computer-screen-svgrepo-com.svg"
                    width: modelData.width / 30
                    height: modelData.height / 30
                    y: Math.floor(modelData.y)
                    Label {
                        text: modelData.id
                    }
                    
                    Label {
                        text: screenImg.widgetCount
                        y: 10
                    }   
                    // Label {
                    //     text: modelData.width + "x" + modelData.height 
                    //     // x: 10
                    //     // y: 25
                    // }
                    Component.onCompleted: {
                            items.dataConfig = systemPanel.readData()
                            screenImg.widgetCount = WidgetHandler.countsApplets(items.dataConfig, modelData.id)
                    }
                    
                    // Timer {
                    //     running: true
                    //     repeat: true
                    //     interval: 60  // Update every 60 seconds maybe?
                    //     onTriggered: {
                    //         items.dataConfig = systemPanel.readData()
                    //         screenImg.widgetCount = WidgetHandler.countsApplets(items.dataConfig, modelData.id)
                    //     }
                    // }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // do what you want here

                            console.log("Rdata", data)
                            // WidgetHandler.removeApplets(items.dataConfig);
                            // console.log("removed", data)
                            items.dataConfig = systemPanel.readData()
                            var data = WidgetHandler.moveWidgets(items.dataConfig, 0, 2);
                            // systemPanel.writeData(data)
                            systemPanelPlugin.write_file(data)
                        }
                    }
                }

            // }
        }
        TextInput {
            text: itemGrid.vmPlaceHolder
            color: "white"
        }

        // }
    }
    
}
