//
//  HZManager.m
//  DynamicDelegate
//
//  Created by ZenonHuang on 2019/1/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "HZManager.h"

@interface HZManager ()
@property (nonatomic,assign) NSInteger nowNum;
@end

@implementation HZManager

- (void)count
{
    self.nowNum += 2;
    
    if ([self.delegate respondsToSelector:@selector(HZManagerNowNum:)]) {
        [self.delegate HZManagerNowNum:self.nowNum];
    }
}
@end
