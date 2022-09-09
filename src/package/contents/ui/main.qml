
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
        property int vmPlaceHolder: WidgetHandler.mostApplets(items.dataConfig, items.model.length)
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
                    property int widgetCount: widgetCount = WidgetHandler.countsApplets(items.dataConfig, modelData.id)
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: true
                    fillMode: Image.PreserveAspectFit
                    source: "../../../image/computer-screen-svgrepo-com.svg"
                    width: modelData.width / 30
                    height: modelData.height / 30
                    y: Math.floor(modelData.y)
                    Label {
                        text: modelData.width + "x" + modelData.height 
                        // x: 10
                        font.pointSize: 6
                        x: 10
                        y: -15

                    }
                    Label {
                        text: modelData.id
                        x: -4
                        font.pointSize: 10
                    }
                    
                    Label {
                        text: screenImg.widgetCount
                        x: -4
                        y: 10
                        font.pointSize: 10
                    }   
 
                    Component.onCompleted: {
                            items.dataConfig = systemPanel.readData()
                            screenImg.widgetCount = WidgetHandler.ParseCountsApplets(items.dataConfig, modelData.id)
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
                            if ((0 + itemGrid.vmPlaceHolder) != modelData.id) {
                                console.log("ldldl", (itemGrid.vmPlaceHolder), modelData.id, itemGrid.vmPlaceHolder + 0 != modelData.id)
                                items.dataConfig = systemPanel.readData()
                                var data = WidgetHandler.moveWidgets(items.model, items.dataConfig, itemGrid.vmPlaceHolder + 0, modelData.id);
                                systemPanelPlugin.write_file(data)
                            }
                        }
                    }
                }

            // }
        }
        TextInput {
            id: most
            text: itemGrid.vmPlaceHolder
            color: "white"
        }

        // ComboBox {
        //     editable: true
        //     model: ListModel {
        //         id: cbItems
        //         ListElement { text: "Banana"; color: "Yellow" }
        //         ListElement { text: "Apple"; color: "Green" }
        //         ListElement { text: "Coconut"; color: "Brown" }
        //     }
        //     currentIndex:  itemGrid.vmPlaceHolder
        //     Component.onCompleted: {
        //         __style.textColor = "black"
        //     }
        //     onAccepted: {
        //         if (find(editText) === -1)
        //             model.append({text: editText})
        //     }
        // }
        // }
    }
    
}
