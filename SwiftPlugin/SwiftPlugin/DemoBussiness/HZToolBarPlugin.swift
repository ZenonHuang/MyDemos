//
//  HZToolBarPlugin.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/6/9.
//

import Foundation
import UIKit


class HZToolBarPlugin: HZBasePlugin,IHZGameBasePlugin {
    weak var tmplController: IHZGameController?

    var chatButton: UIButton?
    
    override func pluginWillInstall(){
        print("HZToolBarPlugin pluginWillMount")
        
        guard let containerView = self.tmplController?.containerView() else { return }
        
        if self.chatButton == nil {
            self.chatButton = UIButton()
            self.chatButton?.backgroundColor = .orange
            self.chatButton?.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
            self.chatButton?.center = containerView.center
            self.chatButton?.setTitle("禁聊", for: .normal)
            self.chatButton?.setTitle("可聊", for: .selected)
            self.chatButton?.addTarget(self, action: #selector(tapChatButton(_:)), for: .touchUpInside)
        }
        
        containerView.addSubview(self.chatButton!)
    }
    
    override func pluginDidInstall() {
        print("HZToolBarPlugin pluginDidInstall")
    }
    
    override func pluginWillUnInstall() {
        print("HZToolBarPlugin pluginWillUnInstall")
    }
    
    override func pluginDidUnInstall() {
        print("HZToolBarPlugin pluginDidUnInstall")
    }
  
    @objc func tapChatButton(_ sender: UIButton) {
        if sender.isKind(of: UIButton.self) == false {
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        let info = ["selected": sender.isSelected ? "1" :"0"]
        self.dispatchEvent(HZGamePluginConstants.ToolBarUpdateChat, userInfo:info)
    }
    
}
