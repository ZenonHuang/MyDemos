//
//  HZSubFanButton.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "HZSubFanButton.h"

@interface HZSubFanButton ()

@end

@implementation HZSubFanButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGPoint originPoint = self.frame.origin;
    CGSize  buttonSize  = self.frame.size;
    //圆的起点是中心点右边的点
    //ArcCenter:圆心坐标
    //radius:半径
    //startAngle:弧度起始角度
    //endAngle:弧度结束M_PI==180度
    //clockwise:YES:顺时针NO:逆时针
    
    
    CGPoint cneterPoint = CGPointMake(buttonSize.width/2, buttonSize.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:cneterPoint//CGPointMake(100, 100)
                                                        radius:buttonSize.width/2
                                                    startAngle:0
                                                      endAngle:M_PI/2
                                                     clockwise:YES];
    CGPoint center = cneterPoint;;//CGPointMake(0, 0);//CGPointMake(100, 100);
    
    //添加一根线到圆心
    [path addLineToPoint:center];
    //关闭路径，是从终点到起点
    [path closePath];
    
    
    [path stroke];

    //使用填充，默认就会自动关闭路径，（终点到起点）这样就可以不写[path closePath];
    [path fill];
    
    
}
@end
