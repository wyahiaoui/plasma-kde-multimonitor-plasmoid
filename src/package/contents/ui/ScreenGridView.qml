
import QtQuick 2.1
import QtQuick.Layouts 1.11
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.private.multimonitor 1.0 as WW;
import "../code/widgetHandler.js" as WidgetHandler

Grid {
    id: screenViews
    property var systemPanelPlugin: WW.SystemPanel {}
    property int vmPlaceHolder: WidgetHandler.mostApplets(items.dataConfig, items.model.length)
    readonly property int numVisibleButtons: (visibleChildren.length - 1)
    property var model:  systemPanel.screenInfo()
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
    // Column{    Text {
    //     text: "parasms" + systemPanelPlugin.workingDirectory()
    //     color: "blue"
    // }
    // }
    spacing: 0
    // width: parent.width
    // height: parent.height
    Repeater {
        property int itemWidth: Math.floor(parent.width/parent.columns)
        property int itemHeight: Math.floor(parent.height/parent.rows)
        property int iconSize: Math.min(itemWidth, itemHeight)
        property string dataConfig: ""
        id: items
        model: screenViews.model
        delegate: 
            Image {
                id: screenImg
                property int widgetCount: widgetCount = WidgetHandler.countsApplets(items.dataConfig, modelData.id)
                Layout.fillHeight: true
                Layout.fillWidth: true
                visible: true
                fillMode: Image.PreserveAspectFit
                source: "../images/computer-screen-svgrepo-com.svg"
                // source: "contents/images/computer-screen-svgrepo-com.svg"
                width: modelData.width / 30
                height: modelData.height / 30
                y: Math.floor(modelData.y)
                Label {
                    text: modelData.width + "x" + modelData.height 
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
                        if ((0 + screenViews.vmPlaceHolder) != modelData.id) {
                            console.log("ldldl", (screenViews.vmPlaceHolder), modelData.id, screenViews.vmPlaceHolder + 0 != modelData.id)
                            items.dataConfig = systemPanel.readData()
                            items.dataConfig = WidgetHandler.moveWidgets(items.model, items.dataConfig, screenViews.vmPlaceHolder + 0, modelData.id);
    
                            systemPanelPlugin.write_fileRefresh(items.dataConfig)
                            screenViews.model = systemPanel.screenInfo()
                        }
                    }
                }
            }
    }

    function updatePlasmoids(dst) {
        // items.dataConfig = systemPanel.readData()
        // items.dataConfig = WidgetHandler.moveWidgets(items.model, items.dataConfig, screenViews.vmPlaceHolder + 0, dst);

        // systemPanelPlugin.write_fileRefresh(items.dataConfig)
        screenViews.model = systemPanel.screenInfo()
    }
}   