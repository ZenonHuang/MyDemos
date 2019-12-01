//
//  HZTrackerCenter.m
//  CollectionViewHook
//
//  Created by zz go on 2019/9/19.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//


#import "HZTrackerCenter.h"
#import "UICollectionView+Tracker.h"

@interface HZTrackerCenter ()
@property (nonatomic, strong) NSMutableDictionary *methodContainer;
@end

@implementation HZTrackerCenter

+ (instancetype)sharedInstance {
    static HZTrackerCenter * s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [HZTrackerCenter new];
    });
    return s_instance;
}

- (void)beginTracker
{
    [UICollectionView HZ_swizzle];
}
@end
