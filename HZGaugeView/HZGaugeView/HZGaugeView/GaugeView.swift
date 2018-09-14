//
//  HZGaugeView.swift
//  HZGaugeView
//
//  Created by zz go on 2017/6/22.
//  Copyright © 2017年 ZenonHuang. All rights reserved.
//

import UIKit

open class GaugeView : UIView {
    
    lazy var numberLabel : UILabel = {
        let numberLabel = UILabel.init(frame: CGRect.zero)
        numberLabel.font = UIFont.systemFont(ofSize: 60)
        numberLabel.textAlignment = NSTextAlignment.center
        numberLabel.textColor = UIColor.init(r: 255, g: 211, b: 33) 
        self.addSubview(numberLabel)
        
        return numberLabel
    }()
    
    lazy var bgView: GaugeBackgroundView = {
        
        let length : CGFloat = 300 
        let rect = CGRect.init(x: self.width * 0.5 - length * 0.5, y: 20, w: length, h: length) 
        let bgView = GaugeBackgroundView.init(frame: rect)
        bgView.backgroundColor = UIColor.clear
        return bgView
    }()
    
    
    lazy var progressView : GaugeProgressView = {
        let rect = CGRect.init(x:0, y:0, w:self.bgView.width, h:self.bgView.h)
        let progressView = GaugeProgressView.init(frame: rect)
        progressView.backgroundColor = UIColor.clear
        progressView.progressValue = 100
        
        return progressView
    }()
  
    
     // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        
        
        self.addSubview(bgView)
        self.bgView.addSubview(progressView)
        
        self.addSubview(numberLabel)
    }
    
    /**
     Returns an object initialized from data in a given unarchiver.
     self, initialized using the data in decoder.
     
     - parameter decoder: an unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    open func show(){
    
    }
    
    open func showAnimation() {
        
    }
    
    open func reset(){
    
    }
    

}
