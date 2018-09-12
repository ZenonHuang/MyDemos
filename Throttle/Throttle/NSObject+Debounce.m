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
static char HZDebounceSerialQueue;


@implementation NSObject (Debounce)

- (void)hz_performSelector:(SEL)aSelector withDebounce:(NSTimeInterval)inteval{
    
    NSMutableDictionary *operationSelectors = [objc_getAssociatedObject(self, &HZDebounceSelectorKey) mutableCopy];
    if (!operationSelectors ) {//操作字典不存在，则 set 一个
        operationSelectors = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &HZDebounceSelectorKey, operationSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    
    NSString *selectorName    = NSStringFromSelector(aSelector);
    if (![operationSelectors objectForKey:selectorName]) {//不存在 selector 的操作队列，为第一次进入

        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:aSelector
                                                                           object:nil];
        // 调用start方法执行操作op操作
        [op start];
        
        //操作字典设置 selectorName
        [operationSelectors setObject:op forKey:selectorName];
        //重置设置一次字典值
        objc_setAssociatedObject(self, &HZDebounceSelectorKey, operationSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
        

    }else{
        //取消之前的

        //重新开始任务，倒计时⌛️
        
    }
    
}

#pragma mark - getter
- (dispatch_queue_t)getSerialQueue
{
    dispatch_queue_t serialQueur = objc_getAssociatedObject(self, &HZDebounceSelectorKey);
    if (!serialQueur) {
        serialQueur = dispatch_queue_create("com.zenonhuang.throttle", NULL);
        objc_setAssociatedObject(self, &HZDebounceSerialQueue, serialQueur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return serialQueur;
}
@end
