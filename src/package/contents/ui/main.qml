/*
    Copyright (c) 2016 Carlos López Sánchez <musikolo{AT}hotmail[DOT]com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
