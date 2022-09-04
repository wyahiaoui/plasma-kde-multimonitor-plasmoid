
import QtQuick 2.1
import QtQuick.Layouts 1.11
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0


Item {
    id: root

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
    
    // property SystemPanel inter: SystemPanel
    Layout.preferredWidth: (iconSize * itemGrid.columns)
    Layout.preferredHeight: (iconSize * itemGrid.rows)

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    
    PlasmaCore.DataSource {
        id: dataEngine
        engine: "powermanagement"
        connectedSources: ["Sleep States","PowerDevil"]
    }
    
    Grid {
        id: itemGrid
        Label {
            text: systemPanel.screenInfo()
        }
    }
    
}
