
//
//  HZTabModel.m
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import "HZTabModel.h"

@interface HZTabModel ()

@end

@implementation HZTabModel

- (CGFloat)textWidth:(UIFont *)textFont{
    UILabel *label = [[UILabel alloc] init];
    label.font = textFont;
    label.text = self.title;
    [label sizeToFit];
    
    return label.bounds.size.width;
}

@end

