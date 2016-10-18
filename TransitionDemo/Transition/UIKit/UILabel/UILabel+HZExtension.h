//
//  UILabel+HZExtension.h
//  QLiveStream
//
//  Created by quseit02 on 16/4/28.
//  Copyright © 2016年 quseit. All rights reserved.
//

@interface UILabel (HZExtension)
+ (instancetype)hz_labelWithFontSize:(CGFloat)size textColorHexValue:(NSString *)value;
- (void)hz_addTarget:(id)target touchAction:(SEL)action;
@end
