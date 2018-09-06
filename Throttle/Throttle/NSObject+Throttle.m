

#import "NSObject+Throttle.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char HZThrottledSelectorKey;
static char HZThrottledSerialQueue;

@implementation NSObject (Throttle)

- (void)hz_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval
{
    dispatch_async([self getSerialQueue], ^{
        NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &HZThrottledSelectorKey) mutableCopy];
        
        if (!blockedSelectors) {
            blockedSelectors = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, &HZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        NSString *selectorName = NSStringFromSelector(aSelector);
        if (![blockedSelectors objectForKey:selectorName]) {//不存在对应 selector，才执行
            [blockedSelectors setObject:selectorName forKey:selectorName];
            objc_setAssociatedObject(self, &HZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Build Setting–> Apple LLVM x.x - Preprocessing –> Enable Strict Checking of objc_msgSend Calls 改为 NO
                objc_msgSend(self,aSelector);
                
                //一段时间后，再将对应 selector 从对应表里移除。
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(inteval * NSEC_PER_SEC)), [self getSerialQueue], ^{
                    [self unlockSelector:selectorName];
                });
            });
        }
    });
}

#pragma mark - 
- (void)unlockSelector:(NSString *)selectorName
{
    dispatch_async([self getSerialQueue], ^{
        NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &HZThrottledSelectorKey) mutableCopy];
        
        if ([blockedSelectors objectForKey:selectorName]) {
            [blockedSelectors removeObjectForKey:selectorName];
        }
        
        objc_setAssociatedObject(self, &HZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

- (dispatch_queue_t)getSerialQueue
{
    dispatch_queue_t serialQueur = objc_getAssociatedObject(self, &HZThrottledSerialQueue);
    if (!serialQueur) {
        serialQueur = dispatch_queue_create("com.zenonhuang.throttle", NULL);
        objc_setAssociatedObject(self, &HZThrottledSerialQueue, serialQueur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return serialQueur;
}

@end
