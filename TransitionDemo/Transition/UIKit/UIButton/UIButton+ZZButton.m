//
//  UIButton+ZZButton.m
//  a8player
//
//  Created by quseit02 on 16/1/11.
//  Copyright © 2016年 quseit. All rights reserved.
//

#import "UIButton+ZZButton.h"
#import <Foundation/Foundation.h>

@implementation UIButton (ZZButton)

- (void)hz_setColor:(UIColor *)color
{
    [self setBackgroundColor:color];
}
- (void)hz_setRedius:(int)i
{
    self.layer.cornerRadius = i;
}
- (void)hz_setNormalTitle:(NSString *)titleText
{
    [self setTitle:titleText forState:UIControlStateNormal];
}
- (void)hz_setNormalImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}
- (void)hz_setHighlightedImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateHighlighted];
}
- (void)hz_setNormalTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}
/**
 *  给按钮增加一个事件为UIControlEventTouchUpInside的响应方法
 *
 *  @param target 接受者
 *  @param action 响应方法
 */
- (void)hz_addTarget:(id)target touchAction:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end