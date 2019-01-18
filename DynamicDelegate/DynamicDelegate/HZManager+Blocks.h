//
//  HZManager+Blocks.h
//  DynamicDelegate
//
//  Created by ZenonHuang on 2019/1/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "HZManager.h"

@interface HZManager (Blocks)

@property (nonatomic, copy, setter = bk_setCountBlock:, nullable) void (^bk_countBlock)(NSInteger num);

@end

