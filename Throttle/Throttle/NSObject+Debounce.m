//
//  NSObject+Debounce.m
//  Throttle
//
//  Created by mewe on 2018/9/12.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "NSObject+Debounce.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char HZDebounceSelectorKey;

@implementation Debounce


@end

@implementation NSObject (Debounce)

- (void)hz_performWithDebounce:(Debounce *)debounceObj{
    
    if (!debounceObj) {
        return;
    }
    
    NSMutableDictionary *operationSelectors = [objc_getAssociatedObject(self, &HZDebounceSelectorKey) mutableCopy];
    if (!operationSelectors ) {//操作字典不存在，则 set 一个
        operationSelectors = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &HZDebounceSelectorKey, operationSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }

    NSInvocationOperation *op = debounceObj.lastOperation;
    
    NSString *selectorName    = debounceObj.aSelector;
    if (![operationSelectors objectForKey:selectorName]) {//不存在 selector 的操作队列，为第一次进入
        // 调用start方法执行操作op操作
        [op start];
        
        //操作字典设置 selectorName
        [operationSelectors setObject:selectorName forKey:selectorName];
        //重置设置一次字典值
        objc_setAssociatedObject(self, &HZDebounceSelectorKey, operationSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }else{
       
        //重新开始任务倒计时⌛️
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(debounceObj.inteval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (debounceObj.lastOperation==op) {//判断是否为最后一次任务
                NSLog(@"Debouce 执行");
                [op start];
                
                //执行后，重置
                debounceObj.lastOperation=nil;
                if ([operationSelectors objectForKey:selectorName]) {
                    [operationSelectors removeObjectForKey:selectorName];
                    objc_setAssociatedObject(self, &HZDebounceSelectorKey, operationSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
                }
                
            }else{
                NSLog(@"丢弃的执行");
            }
        });
        
    }
    
}

@end
