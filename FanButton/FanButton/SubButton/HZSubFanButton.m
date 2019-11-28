//
//  HZSubFanButton.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "HZSubFanButton.h"

#define ssRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ssRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface HZSubFanButton ()
@property (nonatomic, assign) CGPathRef path;//用于判断点击是否在画出来图形中
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) BOOL isTouch;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
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

#pragma mark - public
- (void)beSelected
{
    self.isTouch = YES;
    [self setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(clickBtn:)]) {
        [self.delegate clickBtn:self];
    }
}

- (void)unSelected
{
    self.isTouch = NO;
    [self setNeedsDisplay];
}
#pragma mark - action

                      
#pragma mark - override
- (void)drawRect:(CGRect)rect
{
//    CGPoint originPoint = self.frame.origin;
    CGSize  buttonSize  = self.frame.size;
    CGPoint center = CGPointMake(buttonSize.width/2, buttonSize.height/2);

    // 设置描边宽度
    [self.bezierPath setLineWidth:1.0];
    //添加线到圆心
    [self.bezierPath addLineToPoint:center];
    //关闭路径，是从终点到起点
    [self.bezierPath closePath];
    
    
    [self.layer addSublayer:self.shapeLayer];
    
    if (self.isTouch) {
      
        
        self.gradientLayer.frame = self.frame;
        [self.gradientLayer setMask:self.shapeLayer];/** 截取path部分的渐变 */
        [self.layer addSublayer:self.gradientLayer];
        //        self.shapeLayer.fillColor =  [UIColor colorWithWhite:0 alpha:1].CGColor;//[UIColor orangeColor].CGColor;
        self.shapeLayer.strokeColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        
    }else{

        self.shapeLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
//        self.shapeLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        if (self.gradientLayer.superlayer) {
              [self.gradientLayer removeFromSuperlayer];
        }
    }
 

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.textLabel) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.textLabel.font = [UIFont systemFontOfSize:11];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.numberOfLines = 0;
        
        [self layoutTextLabel];
    }
    [self addSubview:self.textLabel];
    
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.bezierPath) {
        return;
    }
    
    if ([self.delegate currentSelectedButton]!=self) {

        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    if ([self touchInButton:touch]) {
        
        NSLog(@"tap button %@",self);
        
        [self beSelected];
    }
    
}

- (BOOL)touchInButton:(UITouch *)touch
{
    if (!self.bezierPath) {
        return NO;
    }
    
    return  CGPathContainsPoint(self.bezierPath.CGPath, NULL, [touch locationInView:self], true);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!self.bezierPath) {
        return;
    }
    
    NSLog(@"SubButton touchMove %@",event);
    UITouch *touch = [touches anyObject];
    HZSubFanButton *curretButton =  [self.delegate currentSelectedButton];
    
    if (![self touchInButton:touch]) {
        [self.delegate changeBtn:curretButton  touch:touch];
    }else{
        if (curretButton!=self) {
            [self.delegate changeBtn:curretButton touch:touch];
        }
    }
    

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    
    HZSubFanButton *button = [self.delegate currentSelectedButton];
    
    [button unTouch];
    UITouch *touch = [touches anyObject];
    [self.delegate endBtn:button touch:touch];
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    HZSubFanButton *button = [self.delegate currentSelectedButton];
    
    [button unTouch];
    
    UITouch *touch = [touches anyObject];
   [self.delegate endBtn:button touch:touch];
}

- (void)unTouch
{
    if (!self.bezierPath) {
        return;
    }
    
    if (self.isTouch) {
        self.isTouch = NO;
        //    赋值结束之后要刷新UI，不然看不到扇形的变化
        [self setNeedsDisplay];
    }
}
#pragma mark - label

- (void)layoutTextLabel
{
    self.textLabel.text = self.text;
    self.textLabel.frame = [self.textLabel.text boundingRectWithSize:self.frame.size
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName : self.textLabel.font}
                                      context:nil];
    self.textLabel.center = [self textLabelPoint];
    
    if (self.textNeedTransform) {
        CGFloat angleValue = (self.endAngle-self.startAngle) ;
        self.textLabel.transform = CGAffineTransformMakeRotation(self.startAngle + angleValue / 2  + M_PI / 2 + 2 * M_PI);
    }

}



- (CGPoint)textLabelPoint
{
    CGFloat angleValue = (self.endAngle-self.startAngle) ;
    CGFloat angle = [self positiveAngelWith:(self.startAngle + angleValue/ 2)];
    
    CGFloat radius = self.frame.size.width/2;
    CGFloat offsetX = cos(angle) * .7 * radius;
    CGFloat offsetY = sin(angle) * .7 * radius;
    
    CGPoint circleCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGPoint point = CGPointMake(circleCenter.x + offsetX, circleCenter.y + offsetY);
    return point;
}

#pragma mark - other
//将坐标转换为0～2PI
- (CGFloat)positiveAngelWith:(CGFloat)angle
{
    CGFloat num = fabs(angle / M_PI);
    NSInteger count = num;
    count = count / 2;
    if (angle > 0) {
        angle = angle - 2 * M_PI * count;
    }else{
        angle = angle + (count + 1) * 2 * M_PI;
    }
    return angle;
}

#pragma mark - getter

- (UIBezierPath *)bezierPath
{
    if (!_bezierPath) {
        _bezierPath = ({
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
            
            path;
        });
    }
    return _bezierPath;
}

- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = ({
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.path =self.bezierPath.CGPath;
            layer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            layer;
        });
    }
    return _shapeLayer;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = ({
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = self.frame;
            gradientLayer.type = kCAGradientLayerRadial;// kCAGradientLayerAxial;
            gradientLayer.colors = @[(__bridge id)ssRGBHex(0xFFA054).CGColor,
                                     (__bridge id)ssRGBHex(0xFE7000).CGColor ];
            gradientLayer.startPoint = CGPointMake(0.5, 0.5);
            gradientLayer.endPoint = CGPointMake(1.0, 1.0);
            [gradientLayer setLocations:@[@0.3, @0.8, @1]];
            
            gradientLayer;
        });
    }
    return _gradientLayer;
}
@end
