//
//  HZSubFanButton.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "HZSubFanButton.h"

@interface HZSubFanButton ()
@property (nonatomic, assign) CGPathRef path;//用于判断点击是否在画出来图形中
@property (nonatomic, strong) UILabel *textLabel;

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
//    CGPoint originPoint = self.frame.origin;
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
    
    //描边
    [path stroke];
    //使用填充，默认就会自动关闭路径，（终点到起点）这样就可以不写[path closePath];
    [path fill];
    
    
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    layer.path = path.CGPath;
//    layer.strokeColor = [UIColor orangeColor].CGColor;
////    layer.fillColor = .CGColor;
//    layer.backgroundColor = [UIColor purpleColor].CGColor;
//    [self.layer addSublayer:layer];
    
//    self.path = [path CGPath];
    
    self.bezierPath = path;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
//    if (highlighted) {
//        self.backgroundColor = [UIColor orangeColor];
//    }else{
//        self.backgroundColor = [UIColor blackColor];
//    }
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

- (void)layoutSubviews
{
    if (!self.textLabel) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.textLabel.font = [UIFont systemFontOfSize:11];
        self.textLabel.textColor = [UIColor orangeColor];
        self.textLabel.numberOfLines = 0;
        [self addSubview:self.textLabel];
        [self layoutTextLabel];
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

@end
