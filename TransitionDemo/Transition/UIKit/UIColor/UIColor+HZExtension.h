//
//  UIColor+Hex.h
//  Wowooh
//
//  Created by ouyang on 15/5/2.
//  Copyright (c) 2015年 Gotye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HZExtension)

+ (UIColor *)hz_colorFromHexString:(NSString *)hexString;
+ (UIColor *)hz_colorFromR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue a:(CGFloat)alph;
@end
