//
//  UILabel+HZExtension.m
//  QLiveStream
//
//  Created by quseit02 on 16/4/28.
//  Copyright © 2016年 quseit. All rights reserved.
//

#import "UIColor+HZExtension.h"
#import "UILabel+HZExtension.h"
@implementation UILabel (HZExtension)

+ (instancetype)hz_labelWithFontSize:(CGFloat)size textColorHexValue:(NSString *)value
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor hz_colorFromHexString:value];
    return label;
}
- (void)hz_addTarget:(id)target touchAction:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *g =
        [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:g];
}
@end