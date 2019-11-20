//
//  HZCenterFanButton.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/18.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "HZCenterFanButton.h"
#import "HZSubFanButton.h"

@interface HZCenterFanButton ()
@property (nonatomic,strong) UIButton *centerButton;
@property (nonatomic,assign) BOOL  hasInsert;
@end

@implementation HZCenterFanButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    

    [self addSubview:self.centerButton];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.centerButton.frame = CGRectMake(0, 0, self.frame.size.width/4, self.frame.size.width/4);
    self.centerButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    
    if (self.textList.count>0) {
        if (!self.hasInsert) {
            
            self.hasInsert = YES;
            
            for (int i=0; i<self.textList.count; i++) {
                NSString *text = self.textList[i];
                
                CGFloat averageAngle = 2*M_PI / self.textList.count;
                CGFloat startAngle = i*averageAngle+M_PI/2;
                CGFloat endAngle   = (i+1)*averageAngle+M_PI/2;
                HZSubFanButton *subButton = [HZSubFanButton buttonWithAngle:startAngle
                                                                   endAngle:endAngle ];
                subButton.text = text;
//                [subButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
                CGFloat width = self.frame.size.width;
                subButton.frame = CGRectMake(0, 0, width, width);
                //        subButton.tag = 100;
//                [self addSubview:subButton];
                 [self insertSubview:subButton belowSubview:self.centerButton];
            }
        }

        
    }
    
    
}

- (UIButton *)centerButton
{
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] init];
        _centerButton.backgroundColor = [UIColor purpleColor];
    }
    return _centerButton;
}

#pragma mark - hit
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.centerButton.userInteractionEnabled) {
        return self;
    }
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
                return btn;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

@end

