//
//  HZEventDispatcher.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/5/21.
//

import Foundation

class HZEventDispatcher: NSObject {
    ///  key 为 plugin
    ///  value 为一个字典：eventNmae : [SEL/SEL..] 
    private lazy var eventsSelDicts : NSMapTable = NSMapTable<AnyObject, AnyObject>.init(keyOptions: .weakMemory, valueOptions: .strongMemory)
    
    
    
    @objc public func registerEvent(_ event:String,object: AnyObject,selector: Selector){
        
        if (event.isEmpty) {
            return;
        }
        
        let canResponds = object.responds(to: selector)
        assert(canResponds, "对象无法响应 selector ");
        
        if (!canResponds) {
            return;
        }
        
        DispatchQueue.main.async {
            var eventNameDict = self.eventsSelDicts.object(forKey: object)
            if (eventNameDict == nil) {
                eventNameDict = NSMutableDictionary()
                self.eventsSelDicts.setObject(eventNameDict , forKey:object )
            }
           
            var selList = eventNameDict?.object(forKey: event) as? NSMutableArray
            if (selList == nil) {
                selList = NSMutableArray()
                eventNameDict?.set(selList, forKey: event)
            }
           
     
            
            let selString = NSStringFromSelector(selector)
            if !selString.isEmpty {
                if let addSelList = selList {
                    addSelList.add(selString)
                }
            }
        }
    } 
    
    
    @objc public func dispatchEvent(_ event:String ,info:  [String : Any]?){
       
        if event.isEmpty {
            return;
        }
        
        DispatchQueue.main.async {
            let keyEnumerator = self.eventsSelDicts.keyEnumerator()
            while let objKey = keyEnumerator.nextObject() as AnyObject? {

//                if objKey is HZBasePlugin {
//                    continue
//                }
                
                
                guard let eventDicts = self.eventsSelDicts.object(forKey: objKey) else {
                    return 
                }
                
                print("Key: \(objKey), Value: \(eventDicts)")
                
                let events = eventDicts.object(forKey: event) as? NSArray
                guard let eventList = events else {
                    return 
                }
                
                for selString in eventList {
                    
                    if selString is NSString {
                        let selector = NSSelectorFromString(selString as! String) 
                        if objKey.responds(to: selector) {
                            
                            _ = objKey.perform(selector, with: info)
                            
                        }
                    }
                }
                
            }
        }
    }
    
    @objc public func cancelRegisterEventForObject(_ object: AnyObject?){
        guard let plugin = object else { 
            return  
        }
        
        self.eventsSelDicts.removeObject(forKey: plugin)
    }
    
    
    
}

