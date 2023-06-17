//
//  GamePluginManager.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/6/9.
//

import Foundation
import UIKit


struct GamePluginManagerConstants {
    static let PluginImplKey = "plugin"
    static let EntryProtocolKey = "protocol"
    static let EntryMockImplKey = "mockImpl"
}

class HZGamePluginManager: HZPluginManager {
    
    private weak var controller: IHZGameController?
    
    private var hasSetupped = false
    
    init(controller: IHZGameController) {
        self.controller = controller
    }
        
    func setupPlugins() {
        guard !hasSetupped else {
            return
        }
        guard let filePath = Bundle.main.path(forResource: "GamePlugins", ofType: "plist") else {
            return
        }
        resgisterPlugin(for: filePath)
        hasSetupped = true
    }
        
    func resgisterPlugin(for filePath: String) {
        guard let pluginList = NSArray(contentsOfFile: filePath) as? [[String: String]] else {
            return
        }
        
        for dict in pluginList {
            if let clsStr = dict[GamePluginManagerConstants.PluginImplKey], let protocolStr = dict[GamePluginManagerConstants.EntryProtocolKey] {
                
                let moduleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
                guard let cls =  NSClassFromString(moduleName + "." + clsStr), let protocolObj = NSProtocolFromString(moduleName + "." + protocolStr), cls.conforms(to: protocolObj) else {
                    print("插件注册失败 clss:\(clsStr)  protocol:\(protocolStr)  ")
                    continue
                }
                
                let pluginSEL = #selector(HZBasePlugin.pluginWithProtocol(_:))
                if cls.responds(to: pluginSEL), let plugin = cls.pluginWithProtocol(protocolObj) {
                    if let plugin = plugin as? any IHZGameBasePlugin {
                        plugin.tmplController = controller
                        addPlugin(plugin)
                    }
                    
                }
            }
        }
        
    }
        


    
}


