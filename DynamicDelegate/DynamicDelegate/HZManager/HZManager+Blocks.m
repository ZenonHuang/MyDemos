//
//  HZManager+Blocks.m
//  DynamicDelegate
//
//  Created by ZenonHuang on 2019/1/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "HZManager+Blocks.h"
#import "A2DynamicDelegate.h"

#pragma mark Delegate

@interface A2DynamicHZManagerDelegate : A2DynamicDelegate <HZManagerDelegate>

@end

@implementation A2DynamicHZManagerDelegate
- (void)HZManagerNowNum:(NSInteger)num
{
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(HZManagerNowNum:)])
        [realDelegate HZManagerNowNum:num];
    
    //实现 block 转发代理
    void (^orig)(NSInteger) = [self blockImplementationForMethod:_cmd];
    if (orig){
        orig(num);
        orig = nil;
    }
}

@end

#pragma mark - Category

@implementation HZManager (Blocks)

@dynamic bk_countBlock;

+ (void)load
{
    @autoreleasepool {
        //NOTE: bk_registerDynamicDelegate -- 只适用于属性名为 'delegate' 的代理
        [self bk_registerDynamicDelegate];
        
        [self bk_linkDelegateMethods:@{@"bk_countBlock": @"HZManagerNowNum:"}];
    }
}

@end
