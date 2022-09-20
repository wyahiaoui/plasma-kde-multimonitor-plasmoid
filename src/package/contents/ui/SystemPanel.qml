
import QtQuick 2.2
import org.kde.private.multimonitor 1.0 as WW;

Item {
    id: systemPanel

    property var systemPanelPlugin: WW.SystemPanel {}
    property bool systemPanelFailedToInitialize: false
    
    function getSystemPanelPlugin() {
        
        // if (systemPanelPlugin !== null) {
        //     return systemPanelPlugin
        // }
        
        // if (!systemPanelFailedToInitialize) {
        //     console.log('Initializing systemPanel plugin...')
        //     try {
        //         systemPanelPlugin = Qt.createQmlObject('import org.kde.private.multimonitor 1.0 as WW; WW.SystemPanel {}', systemPanel, 'SystemPanel')
        //         console.log('SystemPanel plugin initialized successfully!')
        //     }catch (e) {
        //         console.exception('ERROR: SystemPanel plugin FAILED to initialize -->', e)
        //         systemPanelFailedToInitialize = true
        //     }
        // }
        
        return systemPanelPlugin
    }
    
    // function turnOffScreen() {
        
    //     var plugin = getSystemPanelPlugin()
    //     if (plugin) {
    //         var result = plugin.turnOffScreen()
    //         if(result !=0){
    //             console.error("plugin.turnOffScreen() returned error code=", result)
    //         }
            
    //     } else {
    //         console.exception('ERROR: Turning off screen - SystemPanel plugin not available')
    //     }
    // }

    function refresh() {
        getSystemPanelPlugin().refresh()
    }

    function home() {
        var plugin = getSystemPanelPlugin()
        return plugin.homeDirectory()
    }

    function readData() {
        var data = systemPanelPlugin.read_file("")
        // systemPanelPlugin.write_file(data)
        return data
    }

    function writeData(data) {
        var plugin = getSystemPanelPlugin()
        systemPanelPlugin.write_fileRefresh(data)
    }

    function writeDataConfig(data, path="../assets/templates/applet_bak") {
        var plugin = getSystemPanelPlugin()
        systemPanelPlugin.write_fileDst(data, path)
    }
    
    function screenInfo() : list<ScreenParams> {
        var plugin = getSystemPanelPlugin()
        // plugin.homeDirectory()
        // console.log()
        return plugin.screenInfo()
    }

    function readConfig() {
        var plugin = getSystemPanelPlugin()
        // has to be custonized may be 
        console.log("this", plugin.read_file("../src/package/contents/config/default.json"))
        return JSON.parse(plugin.read_file("../src/package/contents/config/default.json"));
    }
}
