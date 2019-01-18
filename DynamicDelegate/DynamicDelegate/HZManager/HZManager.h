//
//  HZManager.h
//  DynamicDelegate
//
//  Created by ZenonHuang on 2019/1/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HZManagerDelegate <NSObject>

- (void)HZManagerNowNum:(NSInteger)num;

@end

@interface HZManager : NSObject
@property (nonatomic,weak) id<HZManagerDelegate> delegate;

- (void)count;
@end
