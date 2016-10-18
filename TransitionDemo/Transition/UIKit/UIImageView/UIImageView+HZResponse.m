//
//  UIImageView+HZResponse.m
//  QLiveStream
//
//  Created by quseit02 on 16/4/28.
//  Copyright © 2016年 quseit. All rights reserved.
//
#import "UIImageView+HZResponse.h"
@implementation UIImageView (HZResponse)

- (void)hz_addTarget:(id)target touchAction:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *g =
        [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:g];
}
@end