//
//  HZBasePlugin.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/6/9.
//
//

import Foundation
//import HZEventDispatcher

class HZBasePlugin : NSObject,Plugin {
    
    var eventDispatcher:HZEventDispatcher?

    
    ///根据协议创建插件，如果协议与类不对应则返回 nil
    @objc class func pluginWithProtocol(_ protocol:Protocol) -> AnyObject? {
        
        let plugin = self.init()
        
        if !plugin.conforms(to: `protocol`) {
            print("不是对应协议对象")
            return nil
        }
        
        return plugin
    }
    
    override required init() {
        super.init()
    }
    
    
    
    
    func addDispatcher(_ obj:Any) {
        if (obj as AnyObject).isKind(of: HZEventDispatcher.self) {
            self.eventDispatcher = obj as? HZEventDispatcher
        }else{
            print("错误的派发器类型")
        }
    }
    
    func registerEvent(_ event:String,object:AnyObject,selector: Selector) {
        self.eventDispatcher?.registerEvent(event, object: object, selector: selector)
    }
    
    func unSubscribeEventObject(_ object:AnyObject) {
        self.eventDispatcher?.cancelRegisterEventForObject(object)
    }
    
    func dispatchEvent(_ event:String, userInfo: [String : Any]? ) {
        self.eventDispatcher?.dispatchEvent(event, info: userInfo)
    }
    
    //可选实现
    func pluginWillInstall() {
        print("basePlugin -- pluginDidInstall")
    }
    
    func pluginDidInstall() {
        
    }
    
    func pluginWillUnInstall() {
        
    }
    
    func pluginDidUnInstall() {
        
    }

    

}
