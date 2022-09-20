
import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.private.multimonitor 1.0 as WW;

import "../code/widgetHandler.js" as WidgetHandler

Item {
    property var systemPanelPlugin: WW.SystemPanel {}

    ButtonGroup {
           id: childGroup
           exclusive: false
           checkState: mainCheckBox.checkState
    }
    
    CheckBox {
        id: mainCheckBox
        checked: true
        text: "All"
        indicator.width: 15
        indicator.height: 15
        checkState: childGroup.checkState
    }

    ListView {
        property var appletsList: WidgetHandler.GetApplets(systemPanelPlugin.read_file(""), systemPanelPlugin.screenInfo().length) 
        id: multiSelectCheckList
        model:  appletsList
        height: parent.height
        width: parent.width
        anchors {
            top: mainCheckBox.bottom
            margins: 10
        }

        Component.onCompleted: {

            console.log("madha", WidgetHandler.GetApplets(systemPanelPlugin.read_file(""), systemPanelPlugin.screenInfo().length))
        }
        delegate: Row {
            Label {
                text: modelData[0]
            } 
            CheckBox {
                id: modelCheckBoxes
                checked: true
                text: modelData[1]
                indicator.width: 15
                indicator.height: 15
                ButtonGroup.group: childGroup
                onClicked: {
                    if (!checked) {
                        console.log("to ignore", plasmoid.configuration.ignoredPlasmoid, typeof(plasmoid.configuration.ignoredPlasmoid ), modelData[1]);
                        if (plasmoid.configuration.ignoredPlasmoid == "")
                            plasmoid.configuration.ignoredPlasmoid = modelData[0] + "-" + modelData[1]
                        else 
                            plasmoid.configuration.ignoredPlasmoid += ", " + modelData[0] + "-" + modelData[1] 
                        console.log(plasmoid.configuration.ignoredPlasmoid)
                    }
                    else {
                        var splitted = plasmoid.configuration.ignoredPlasmoid.split(",")
                        splitted.splice(splitted.indexOf(modelData[0] + "-" + modelData[1]))
                        plasmoid.configuration.ignoredPlasmoid = splitted.join(", ")
                    }   
                        
                }
            }
        }
    }
}