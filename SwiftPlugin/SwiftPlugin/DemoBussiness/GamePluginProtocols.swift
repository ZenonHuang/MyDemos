//
//  GamePluginProtocols.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/6/9.
//

import UIKit

@objc protocol IHZGameController: NSObjectProtocol {
    @objc func containerView() -> UIView
}

@objc protocol IHZGameBasePlugin : Plugin {
    @objc weak var tmplController: IHZGameController? { get set }
   
}

//MARK: Event
struct HZGamePluginConstants {
    static let ToolBarUpdateChat = "ToolBarUpdateChatEnable"
}

