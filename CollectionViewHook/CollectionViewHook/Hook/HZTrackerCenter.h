//
//  HZTrackerCenter.h
//  CollectionViewHook
//
//  Created by zz go on 2019/9/19.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZTrackerCenter : NSObject

+ (instancetype)sharedInstance;

- (void)beginTracker;

@end
