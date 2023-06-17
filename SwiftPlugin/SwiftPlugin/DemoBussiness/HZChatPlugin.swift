//
//  HZChatPlugin.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/6/9.
//

import Foundation
import UIKit

class HZChatPlugin: HZBasePlugin,IHZGameBasePlugin {
    weak var tmplController: IHZGameController?
    
    var textLabel = UILabel()
    
    override func pluginWillInstall() {
        let textLabel = UILabel()
        textLabel.backgroundColor = .red
        textLabel.frame = CGRect(x: 0, y: 80, width: 200, height: 40)
        textLabel.text = "message message"
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 15)
        self.textLabel = textLabel
        
        guard let containerView = self.tmplController?.containerView() else { return }
        containerView.addSubview(textLabel)
        
        print("HZChatPlugin pluginDidMount")
        
        self.registerEvent(HZGamePluginConstants.ToolBarUpdateChat, object: self, selector: #selector(chatEnable(_:)))
        self.registerEvent(HZGamePluginConstants.ToolBarUpdateChat, object: self, selector: #selector(chatEnableB))
    }
    
    @objc func chatEnableB() {
        print("chatEnable ")
    }
    
    @objc func chatEnable(_ dict: [AnyHashable: Any]?) {
        print("chatEnable dict \(dict ?? [:])")
        guard let dict = dict,
              let num = dict["selected"] as? String else { return }
        
        let isSelected = (num == "1")
        self.textLabel.text = isSelected ? "" : "message"
        self.textLabel.backgroundColor = isSelected ? .gray : .red
    }
}
