//
//  GameViewController.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/6/9.
//

import UIKit

class HZGameViewController: UIViewController, IHZGameController {
    
    var pluginManager: HZGamePluginManager?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPluginsUI()
    }
    
    func setupPluginsUI() {
        pluginManager = HZGamePluginManager(controller: self)
        pluginManager?.setupPlugins()
    }
    
    func containerView() -> UIView {
        return view
    }
    
    func backHome() {
        
    }
    
    func dismissView() {
        
    }
    
}
