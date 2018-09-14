//
//  Annular.swift
//  Neptune
//
//  Created by zz go on 2017/6/28.
//  Copyright © 2017年 sz. All rights reserved.
//


import UIKit

@IBDesignable
class Annular: UIView {
    
    /// 设置属性 初始化颜色
    @IBInspectable var annularColor: UIColor = UIColor(red: (238.0/255.0), green: (32.0/255), blue: (53.0/255.0), alpha: 1.0)
    @IBInspectable var capLength : CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - 指定画圆弧样式
    func addOval(lineWidth: CGFloat, 
                 path: CGPath, 
                 strokeStart: CGFloat, 
                 strokeEnd: CGFloat, 
                 strokeColor: UIColor, 
                 fillColor: UIColor, 
                 shadowRadius: CGFloat, 
                 shadowOpacity: Float, 
                 shadowOffset: CGSize) {
        
        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.cgColor
        arc.fillColor = fillColor.cgColor
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffset
        
        layer.addSublayer(arc)
    }
    
    // MARK: - 重写drawRect方法
    override func draw(_ rect: CGRect) {
        
        //半径
        let radius : CGFloat = self.width <= self.h ? self.width : self.h
        
        
        //画圆
        let color = annularColor
        color.set() // 设置线条颜色  
        
        // 根据传人的矩形画出内切圆／椭圆   
        let aPath = UIBezierPath.init(ovalIn: CGRect.init(x: (self.width-radius/2)/2, y: (self.h-radius/2)/2, w: radius/2, h: radius/2)) 
        
        aPath.lineWidth = 5.0 // 线条宽度  
        
        //aPath.stroke() // Draws line 根据坐标点连线，不填充  
        aPath.fill() // Draws line 根据坐标点连线，填充  
        
        
        // 添加圆弧     
        addCircle(arcRadius: radius, capRadius: capLength, color: annularColor)
    }
    
    // MARK: - 指定画圆弧路径
    func addCircle(arcRadius: CGFloat, capRadius: CGFloat, color: UIColor) {
        let x = bounds.midX
        let y = bounds.midY
        
        // 底部圆弧
        let pathBottom = UIBezierPath.init(ovalIn: CGRect.init(x: x - (arcRadius/2), y: y - (arcRadius/2), w: arcRadius, h:  arcRadius)).cgPath
        
        addOval(lineWidth: capRadius,
                path: pathBottom,
                strokeStart: 0, 
                strokeEnd: 1,
                strokeColor: color,
                fillColor: UIColor.clear,
                shadowRadius: 0, 
                shadowOpacity: 0, 
                shadowOffset: CGSize.zero)
        
    }
}
