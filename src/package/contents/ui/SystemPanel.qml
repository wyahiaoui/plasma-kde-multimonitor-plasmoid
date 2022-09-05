
import QtQuick 2.2

Item {
    id: systemPanel

    property var systemPanelPlugin: null
    property bool systemPanelFailedToInitialize: false
    
    function getSystemPanelPlugin() {
        
        if (systemPanelPlugin !== null) {
            return systemPanelPlugin
        }
        
        if (!systemPanelFailedToInitialize) {
            console.log('Initializing systemPanel plugin...')
            try {
                systemPanelPlugin = Qt.createQmlObject('import org.kde.private.multimonitor 1.0 as WW; WW.SystemPanel {}', systemPanel, 'SystemPanel')
                console.log('SystemPanel plugin initialized successfully!')
            }catch (e) {
                console.exception('ERROR: SystemPanel plugin FAILED to initialize -->', e)
                systemPanelFailedToInitialize = true
            }
        }
        
        return systemPanelPlugin
    }
    
    function turnOffScreen() {
        
        var plugin = getSystemPanelPlugin()
        if (plugin) {
            var result = plugin.turnOffScreen()
            if(result !=0){
                console.error("plugin.turnOffScreen() returned error code=", result)
            }
            
        } else {
            console.exception('ERROR: Turning off screen - SystemPanel plugin not available')
        }
    }

    function screenInfo() {
        var plugin = getSystemPanelPlugin()
        plugin.homeDirectory()
        // console.log()
        return plugin.screenInfo()
    }
}
