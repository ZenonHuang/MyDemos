//
//  HZCenterFanButton.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/18.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "HZCenterFanButton.h"
#import "HZSubFanButton.h"

@interface HZCenterFanButton ()<HZSubFanButtonDelegate>
@property (nonatomic,strong) UIButton *centerButton;
@property (nonatomic,assign) BOOL  hasInsert;

@property (nonatomic,strong) HZSubFanButton *currentButton;
@end

@implementation HZCenterFanButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self addSubview:self.centerButton];
    [self.centerButton addTarget:self
                          action:@selector(tapCenterButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.centerButton.frame  = CGRectMake(0, 0, self.frame.size.width/4, self.frame.size.width/4);
    self.centerButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    
    if (self.textList.count>0) {
        if (!self.hasInsert) {
            self.hasInsert = YES;
            [self addSubButtons];
        }
    }
    
}

- (void)addSubButtons
{
    for (int i=0; i<self.textList.count; i++) {
        NSString *text = self.textList[i];
        
        CGFloat averageAngle = 2*M_PI / self.textList.count;
        CGFloat startAngle = i*averageAngle+M_PI/2;
        CGFloat endAngle   = (i+1)*averageAngle+M_PI/2;
        HZSubFanButton *subButton = [HZSubFanButton buttonWithAngle:startAngle
                                                           endAngle:endAngle ];
        subButton.text = text;
        //                [subButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        subButton.index = i;
        CGFloat width = self.frame.size.width;
        subButton.frame = CGRectMake(0, 0, width, width);
        //        subButton.tag = 100;
        //                [self addSubview:subButton];
        [self insertSubview:subButton belowSubview:self.centerButton];
        
        subButton.delegate = self;
    }
          
}

- (void)removeSubButtons
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[HZSubFanButton class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)tapCenterButton:(UIButton *)sender
{
    if (sender.isSelected) {
        [self addSubButtons];
    }else{
        [self removeSubButtons];
    }
    
    sender.selected = (!sender.isSelected);
}

#pragma mark - delegate
- (void)clickBtn:(HZSubFanButton *)btn
{
//    NSLog(@"btn tap %@",@(btn.index));
}

- (void)changeBtn:(HZSubFanButton *)btn touch:(UITouch *)touch
{
    HZSubFanButton *button = [self touchInSubbutton:touch];
    if (button) {
        [self.currentButton unSelected];
        
        [button beSelected];
        self.currentButton = button;
        
        return;
    }
    
}

- (void)endBtn:(HZSubFanButton *)btn touch:(UITouch *)touch
{
    HZSubFanButton *button = [self touchInSubbutton:touch];
    if (button) {
        [self.currentButton unSelected];
        
        if ([self.delegate respondsToSelector:@selector(clickBtnWithIndex:)]) {
            [self.delegate clickBtnWithIndex:self.currentButton.index];
        }
        
        return;
    }
    
    //按钮外松开
    if (self.currentButton) {
        [self.currentButton unSelected];
        
        if ([self.delegate respondsToSelector:@selector(clickBtnWithIndex:)]) {
            [self.delegate clickBtnWithIndex:self.currentButton.index];
        }
    }
  
}

- (HZSubFanButton *)currentSelectedButton
{
    return self.currentButton;
}
#pragma mark - setter
- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.centerButton setTitle:_title forState:UIControlStateNormal];
}

#pragma mark - getter
- (UIButton *)centerButton
{
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] init];
        _centerButton.backgroundColor = [UIColor purpleColor];
    }
    return _centerButton;
}

- (HZSubFanButton *)subButtonForPoint:(CGPoint)point
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[HZSubFanButton class]]) {
            
            HZSubFanButton *subButton = (HZSubFanButton *)view;
            if (CGPathContainsPoint(subButton.bezierPath.CGPath, nil, point, nil)) {
                
                return subButton;
            }
        }
    }
    
    return nil;
}


- (HZSubFanButton *)touchInSubbutton:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    //落点在圆内
    HZSubFanButton *button = [self subButtonForPoint:point];
    if (button) {
        return button;
    }
    //落点在圆外
    CGFloat centrex = self.frame.size.width/2;          //圆心X
    CGFloat centrey = self.frame.size.height/2;         //圆心Y
    CGFloat radius = self.frame.size.width/2;//半径
    CGFloat x;              //坐标系X
    CGFloat y;              //坐标系Y

    x = point.x - centrex;
    y = centrey - point.y;
    
    float current_radius =  sqrtf(x*x + y*y);           //计算改点到圆心的距离
    if(current_radius > radius)
    {
        float circlex = fabs(x) / current_radius * radius;
        float circley = fabs(y) / current_radius * radius;
        if(x < 0 && y > 0)
        {
            x = centrex - circlex;
            y = centrey - circley;
        }
        else if(x > 0 && y > 0)
        {
            x = centrex + circlex;
            y = centrey - circley;
        }
        else if(x < 0 && y < 0)
        {
            x = centrex - circlex;
            y = centrey + circley;
        }
        else if (x > 0 && y < 0)
        {
            x = centrex + circlex;
            y = centrey + circley;
        }
        
        CGPoint newPoint = CGPointMake(x, y);
        return  [self subButtonForPoint:newPoint];
    }
    return nil;
}

#pragma mark - hit
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.centerButton.userInteractionEnabled) {
        return self;
    }
    
    NSLog(@"center fan hitTest:  %@",event);
    
    NSEnumerator *enumertor =[self.subviews reverseObjectEnumerator];
    UIView *view;
    while (view = [enumertor nextObject]) {
        CGPoint hitpoint = [self convertPoint:point toView:self.centerButton];
        if (view == self.centerButton && self.centerButton.userInteractionEnabled && [self.centerButton pointInside:hitpoint withEvent:event]) {
            return self.centerButton;
        }
        if ([view isKindOfClass:[HZSubFanButton class]]) {
            HZSubFanButton *btn = (HZSubFanButton *)view;
            if (CGPathContainsPoint(btn.bezierPath.CGPath, nil, point, nil)) {
                self.currentButton = btn;
                return btn;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    NSLog(@"center fan touchMove UIEvent %@",event);
    
}
@end

