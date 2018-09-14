//
//  ViewController.swift
//  HZGaugeView
//
//  Created by zz go on 2017/6/22.
//  Copyright © 2017年 ZenonHuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var gaugeView : GaugeView = {
        let rect = CGRect.init(x: 0, y: 40, w: self.view.width, h: 325)
        let gaugeView = GaugeView.init(frame: rect)
        return gaugeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.init(r: 53, g: 53, b: 53)
          
        self.view.addSubview(gaugeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // FIXME: 进度线渐变颜色设置
    private func addGradientLayer(){
        

    
    }
    
}

