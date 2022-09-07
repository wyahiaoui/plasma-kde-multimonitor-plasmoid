
import QtQuick 2.1
import QtQuick.Layouts 1.11
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0

import "../code/widgetHandler.js" as WidgetHandler
Item {
    id: root

    readonly property int minButtonSize: units.iconSizes.small
    readonly property int medButtonSize: units.iconSizes.medium
    readonly property int maxButtonSize: units.iconSizes.large

    // Layout.minimumWidth: minButtonSize * itemGrid.columns
    // Layout.minimumHeight: minButtonSize * itemGrid.rows

    // Layout.maximumWidth: maxButtonSize * itemGrid.columns
    // Layout.maximumHeight: maxButtonSize * itemGrid.rows
    
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
    
    // property SystemPanel inter: SystemPanel
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

        // Label {
            // for (const screen in systemPanel.screenInfo()) 
            Repeater {
                property int itemWidth: Math.floor(parent.width/parent.columns)
                property int itemHeight: Math.floor(parent.height/parent.rows)
                property int iconSize: Math.min(itemWidth, itemHeight)
                id: items
                model: systemPanel.screenInfo()
                delegate: 
                // Column {
                // Grid {
                    // x: Math.floor(modelData.x/250)
                    // y: Math.floor(modelData.y)
                    Image {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        visible: true
                        fillMode: Image.PreserveAspectFit
                        source: "../../../image/computer-screen-svgrepo-com.svg"
                        width: modelData.width / 30
                        height: modelData.height / 30
                        // x: 150 * index
                        y: Math.floor(modelData.y)
                        Label {
                            text: modelData.id
                            // x: modelData.x/100
                            // y: 10
                        }
                        // Label {
                        //     text: modelData.width + "x" + modelData.height 
                        //     // x: 10
                        //     // y: 25
                        // }
                        Component.onCompleted: {
                            // mapToGlob
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // do what you want here
                                var data = systemPanel.readData()
                                // console.log("Rdata", data)
                                data = WidgetHandler.remove_applets(data);
                                // console.log("removed", data)
                                systemPanel.writeData(data)
                            }
                        }
                    }

                // }
            }
        // }
    }
    
}
