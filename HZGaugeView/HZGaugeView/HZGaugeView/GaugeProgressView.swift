//
//  GaugeProgressView.swift
//  HZGaugeView
//
//  Created by zz go on 2017/6/23.
//  Copyright © 2017年 ZenonHuang. All rights reserved.
//

import UIKit

open class GaugeProgressView : UIView{
   open var progressValue : CGFloat{
        
        didSet{
            self.setNeedsDisplay()
        }
    
    }  
    override public init(frame: CGRect) {
     
        progressValue = 0.0
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        //获取上下文
        let context = UIGraphicsGetCurrentContext()!
        
        let radius = self.width * 0.5
        let perimeter = (Double.pi).toCGFloat * radius * 2 / 3.0 * 2 
        
        
        let width = perimeter / 12.0 / 5.0;
        //设置线条的宽度

        context.setLineWidth(12)
        //设置线条的起始点样式

        context.setLineCap(CGLineCap.butt)
        //虚实切换 ，实线5虚线10

        let lengths : [CGFloat] = [1.5, width - 1.5]
        

            context.setLineDash(phase: 0, lengths: lengths)
        //设置颜色
        UIColor.white.set()
        
        let end : CGFloat = GaugeBeginAngle.toCGFloat + (GaugeRotateAngle.toCGFloat * (progressValue) / GaugeFullScore.toCGFloat);
        
        
        //设置路径
        if (progressValue > 0) {
            let centerPoint : CGPoint = CGPoint.init(x: self.width * 0.5, y: self.width * 0.5)
            context.addArc(center: centerPoint ,
                           radius: self.width * 0.45, 
                           startAngle: GaugeBeginAngle.toCGFloat, 
                           endAngle:   end, 
                           clockwise: false)
            //绘制
            context.strokePath()
        }

    }

}
