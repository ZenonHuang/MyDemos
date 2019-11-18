//
//  HZSubFanButton.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "HZSubFanButton.h"

@interface HZSubFanButton ()
@property(nonatomic, assign) CGPathRef path;//用于判断点击是否在画出来图形中


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

+ (instancetype)buttonWithAngle:(CGFloat)startAngle
                       endAngle:(CGFloat)endAngle
{
    HZSubFanButton *button = [[HZSubFanButton alloc] init];
    button.startAngle = startAngle;
    button.endAngle   = endAngle;
    return button;
}
                      
#pragma mark - override
- (void)drawRect:(CGRect)rect
{
    CGPoint originPoint = self.frame.origin;
    CGSize  buttonSize  = self.frame.size;
    //圆的起点是中心点右边的点
    //ArcCenter:圆心坐标
    //radius:半径
    //startAngle:弧度起始角度
    //endAngle:弧度结束  M_PI==180度
    //clockwise:YES:顺时针NO:逆时针
    
    
    CGPoint cneterPoint = CGPointMake(buttonSize.width/2, buttonSize.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:cneterPoint//CGPointMake(100, 100)
                                                        radius:buttonSize.width/2
                                                    startAngle:self.startAngle
                                                      endAngle:self.endAngle
                                                     clockwise:YES];
    CGPoint center = cneterPoint;;//CGPointMake(0, 0);//CGPointMake(100, 100);
    
    // 设置描边宽度
    [path setLineWidth:1.0];
    
    //添加线到圆心
    [path addLineToPoint:center];
    //关闭路径，是从终点到起点
    [path closePath];
    
    
    //设置颜色（颜色设置也可以放在最上面，只要在绘制前都可以）
    [[UIColor orangeColor] setStroke];
//    [color196FFA setFill];
    
    //描边
    [path stroke];
    //使用填充，默认就会自动关闭路径，（终点到起点）这样就可以不写[path closePath];
    [path fill];
    
    
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    layer.path = path.CGPath;
//    layer.strokeColor = [UIColor orangeColor].CGColor;
////    layer.fillColor = color196FFA.CGColor;
//    layer.backgroundColor = [UIColor purpleColor].CGColor;
//    [self.layer addSublayer:layer];
    
//    self.path = [path CGPath];
    self.bezierPath = path;
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.bezierPath) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    if (CGPathContainsPoint(self.bezierPath.CGPath, NULL, [touch locationInView:self], true)) {
        
        NSLog(@"tap button %@",self);
        
        if ([self.delegate respondsToSelector:@selector(clickBtn:)]) {
            [self.delegate clickBtn:self];
        }
    }
    
}


//- (void)dealloc
//{
//    CGPathRelease(_path);
//}
@end
