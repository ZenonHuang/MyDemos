//
//  HZPluginManager.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/5/21.
//

import Foundation

@objc protocol Plugin : NSObjectProtocol {

//    var identifier = ""
    func addDispatcher(_ dispatcher: Any)
    func registerEvent(_ event:String,object:AnyObject,selector: Selector)
    func unSubscribeEventObject(_ object:AnyObject) 
    func dispatchEvent(_ event:String, userInfo: [String : Any]? )
    
    //可选实现
    @objc optional func pluginWillInstall()
    
    @objc optional func pluginDidInstall()
    
    @objc optional func pluginWillUnInstall()
    
    @objc optional func pluginDidUnInstall()
}


class HZPluginManager {
    var plugins = [Plugin]()
    var eventDispatcher = HZEventDispatcher()
    
    func addPlugin(_ plugin: Plugin){
        if plugins.contains(where: { $0 === plugin }) {
            return
        } 
        
        plugin.addDispatcher(eventDispatcher)

        if plugin.responds(to: #selector(Plugin.pluginWillInstall)) {
            print("\(plugin) pluginWillMount")
            plugin.pluginWillInstall?()
        }
        
        plugins.append(plugin)
        
     
        if plugin.responds(to: #selector(Plugin.pluginDidInstall)) {
            print("\(plugin) pluginDidInstall")
            plugin.pluginDidInstall?()
        }
    }
    
    
    func removePlugin(_ plugin: Plugin){
        
        if plugin.responds(to: #selector(Plugin.pluginWillUnInstall)) {//将要卸载
            print("\(plugin) pluginWillUnInstall")
            plugin.pluginWillUnInstall?()
        }
        
        if let index = plugins.firstIndex(where: { $0 === plugin }) {
            plugins.remove(at: index)
        }
        
        if plugin.responds(to: #selector(Plugin.pluginDidUnInstall)) {//已经卸载
            print("\(plugin) pluginDidUnInstall")
            plugin.pluginDidUnInstall?()
        }
    }
    
    func uninstallAllPlugins(){
        for plugin in plugins {
            removePlugin(plugin)
        }
    }
    
    deinit {
        uninstallAllPlugins()
    }
}
