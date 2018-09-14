//
//  GaugeBackgroundView.swift
//  HZGaugeView
//
//  Created by zz go on 2017/6/22.
//  Copyright © 2017年 ZenonHuang. All rights reserved.
//

import UIKit

open class  GaugeBackgroundView : UIView {

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        // 获取上下文 画布
        let context : CGContext = UIGraphicsGetCurrentContext()!
        let radius : CGFloat = self.width * 0.5
        let perimeter : CGFloat = (Double.pi * Double(radius)  * 2 / 3.0 * 2).toCGFloat
        let width : CGFloat = perimeter / 12.0 / 5.0;
        //设置线条的宽度
        context.setLineWidth(12)
        //设置线条的起始点样式
        context.setLineCap(CGLineCap.butt)
        //虚实切换 ，实线5虚线10
        let lengths:[CGFloat] = [1.5,width - 1.5] // 绘制 跳过 无限循环
        context.setLineDash(phase: 0, lengths: lengths)
        //设置颜色
         UIColor.init(white: 1, alpha: 0.5).set()
        //设置路径
        let centerPoint : CGPoint = CGPoint.init(x: self.width * 0.5, y: self.width * 0.5) 
        context.addArc(center: centerPoint ,
                       radius: self.width * 0.45, 
                       startAngle: GaugeBeginAngle.toCGFloat, 
                       endAngle:   GaugeEndAngle.toCGFloat, 
                       clockwise: false)
        
        context.strokePath()
        
    }


}
