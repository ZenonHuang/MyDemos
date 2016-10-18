//
//  UIButton+zzButton.h
//  a8player
//
//  Created by quseit02 on 16/1/11.
//  Copyright © 2016年 quseit. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIButton (ZZButton)
- (void)hz_setColor:(UIColor *)color;
- (void)hz_setRedius:(int)i;
- (void)hz_setNormalTitle:(NSString *)titleText;
- (void)hz_addTarget:(id)target touchAction:(SEL)action;
- (void)hz_setNormalImage:(UIImage *)image;
- (void)hz_setHighlightedImage:(UIImage *)image;
- (void)hz_setNormalTitleColor:(UIColor *)color;
@end