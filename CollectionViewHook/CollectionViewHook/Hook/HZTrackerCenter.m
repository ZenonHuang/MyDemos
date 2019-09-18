//
//  HZTrackerCenter.m
//  CollectionViewHook
//
//  Created by zz go on 2019/9/19.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//


#import "HZTrackerCenter.h"

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

- (instancetype)init {
    if (self = [super init]) {
     
    }
    return self;
}

- (BOOL)HZ_swizzleHasSetMethodFor:(NSString *)key
{
    NSString *value = [self.methodContainer valueForKey:key];
    if (!value) {
        return NO;
    }
    
    if (value.length>0) {
        return YES;
    }
    return NO;
}


- (void)HZ_swizzleSetMethod:(NSString *)key forClss:(NSString *)value
{
    NSAssert(key, @"key nil");
    NSAssert(value, @"value nil");
    
    [self.methodContainer setValue:value forKey:key];
}

- (NSMutableDictionary *)methodContainer
{
    if (!_methodContainer) {
        _methodContainer = [[NSMutableDictionary alloc] init];
    }
    return _methodContainer;
}
@end
