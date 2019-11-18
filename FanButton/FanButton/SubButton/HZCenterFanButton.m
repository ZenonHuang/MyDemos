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
@end

@implementation HZCenterFanButton


#pragma mark - hit
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    if (!self.centerButton.userInteractionEnabled) {
//        return self;
//    }
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

