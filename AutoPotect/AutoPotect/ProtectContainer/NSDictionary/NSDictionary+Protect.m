//
//  NSDictionary+Protect.m
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//

#import "NSDictionary+Protect.h"
#import "NSObject+Protect.h"
#import "ProtectMacro.h"
#import <objc/objc.h>
#import <objc/runtime.h>

#ifdef DEBUG
#define HZ_invalidSafeDictionaryWithKey(KEY)                                                        \
(                                                                                                   \
    (!(KEY)) ?                                                                                      \
    ({                                                                                              \
        NSAssert(NO,                                                                                \
            @"安全防护提示 NSDictionary assert => invalid obj %s:%d name:%@ class:%@ val:%@",                    \
            __PRETTY_FUNCTION__,                                                                    \
            __LINE__,                                                                               \
            @""#KEY,                                                                                \
            NSStringFromClass([(KEY) class]),                                                       \
            (KEY));                                                                                 \
            YES;                                                                                    \
    })                                                                                              \
    :                                                                                               \
    NO                                                                                              \
)
#else
#define HZ_invalidSafeDictionaryWithKey(KEY)                                                        \
(                                                                                                   \
    (!(KEY)) ?                                                                                      \
    ({                                                                                              \
        NSLog(@"安全防护 NSDictionary error => invalid obj %s:%d name:%@ class:%@ val:%@\n %@",         \
            __PRETTY_FUNCTION__,                                                                    \
            __LINE__,                                                                               \
            @""#KEY,                                                                                \
            NSStringFromClass([(KEY) class]),                                                       \
            (KEY),                                                                                  \
            [NSThread callStackSymbols]);                                                           \
            YES;                                                                                    \
    })                                                                                              \
    :                                                                                               \
    NO                                                                                              \
)
#endif


@implementation NSDictionary (Protect)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hz_swizzleInstanceMethod:@selector(initWithObjects:forKeys:count:) 
                               with:@selector(safe_initWithObjects:forKeys:count:)];
        
        [self hz_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) 
                            with:@selector(safe_dictionaryWithObjects:forKeys:count:)];

        
        [self hz_swizzleClassMethod:@selector(dictionaryWithObject:forKey:)
                            with:@selector(safe_dictionaryWithObject:forKey:)];
        
        [self hz_swizzleClassMethod:@selector(dictionaryWithDictionary:) 
                            with:@selector(safe_dictionaryWithDictionary:)];
        //objects & keys can be nil
        //[self hz_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:) 
        //with:@selector(safe_dictionaryWithObjects:forKeys:)];
        
//        [self hz_swizzleClassMethod:@selector(dictionaryWithObjectsAndKeys:)
//                            with:@selector(safe_dictionaryWithObjectsAndKeys:)];
        
    });
}

- (BOOL)hasKey:(NSString *)key
{
    if (HZ_invalidSafeDictionaryWithKey(key)) return NO;
    id val = [self objectForKey:key];
    return val?YES:NO;
}

- (instancetype)safe_initWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger count = [self.class objects:objects keys:keys count:cnt safeObjects:safeObjects safeKeys:safeKeys];
    return [self safe_initWithObjects:safeObjects forKeys:safeKeys count:count];
}

+ (instancetype)safe_dictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger count = [self objects:objects keys:keys count:cnt safeObjects:safeObjects safeKeys:safeKeys];
    return [self safe_dictionaryWithObjects:safeObjects forKeys:safeKeys count:count];
}

+ (NSUInteger)objects:(const id [])objects keys:(const id <NSCopying> [])keys count:(NSUInteger)cnt safeObjects:(__strong id *)safeObjects safeKeys:(__strong id *)safeKeys
{
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt && j < cnt; ++i) {
        id key = keys[i];
        id obj = objects[i];
        if (HZ_invalidSafeDictionaryWithKey(key) ||
            HZ_invalidSafeDictionaryWithKey(obj)) {
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        ++j;
    }
    return j;
}

+ (instancetype)safe_dictionaryWithObject:(id)obj forKey:(id)key
{
    if (HZ_invalidSafeDictionaryWithKey(key) ||
        HZ_invalidSafeDictionaryWithKey(obj)) {
        return [self dictionary];
    }
    return [self safe_dictionaryWithObject:obj forKey:key];
}

/**
 NSString *emptyKey = nil;
 NSString *emptyObj = nil;
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", emptyObj, emptyKey, @"2", @"3", @"3", nil];
 */
+ (instancetype)safe_dictionaryWithObjectsAndKeys:(id)firstObject, ...
{
    if (!firstObject) {
        return [self dictionary];
    }

    SEL sel = @selector(safe_dictionaryWithObjectsAndKeys:);
    NSMethodSignature *sig = [self methodSignatureForSelector:sel];
    if (!sig) { [self doesNotRecognizeSelector:sel]; return nil; }
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    if (!inv) { [self doesNotRecognizeSelector:sel]; return nil; }
    [inv setTarget:self];
    [inv setSelector:sel];

    NSLog(@"%s %@", __func__, [NSThread callStackSymbols]);
    NSLog(@"self:%@ sig.numberOfArguments:%ld", self, sig.numberOfArguments);

    NSUInteger numberOfArguments = sig.numberOfArguments;
    if (numberOfArguments & 1) {
        numberOfArguments -= 1;
    }
    if (numberOfArguments > 2) {
        va_list args;
        va_start(args, firstObject);
        id param;
        id obj = firstObject;
        for (NSUInteger i = 2; (param = va_arg(args, id)); ++i) {
            //        [inv setArgument:&firstObject atIndex:2];
            //        [inv setArgument:&param atIndex:i];
            if (i & 1) {
                [inv setArgument:&obj atIndex:i - 1];   //obj
                [inv setArgument:&param atIndex:i];     //key
                obj = nil;
                continue;
            }
            obj = param;
        }
        va_end(args);
    }

    [inv invoke];

    if ([sig methodReturnLength] > 0) {
        NSDictionary *returnValue;
        [inv getReturnValue:&returnValue];
        return returnValue;
    }
    return nil;
}

+ (instancetype)safe_dictionaryWithDictionary:(NSDictionary<id, id> *)dict
{
    //dict is nullable
    if (!dict) {
        return [self dictionary];
    }
    if (HZCheckInvalidAndKindOfClass(dict, NSDictionary)) {
        return [self dictionary];
    }
    return [self safe_dictionaryWithDictionary:dict];
}

@end

@implementation NSMutableDictionary (Protect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSDictionaryM");
        [class hz_swizzleInstanceMethod:@selector(setObject:forKey:) with:@selector(safe_setObject:forKey:)];
        [class hz_swizzleInstanceMethod:@selector(setObject:forKeyedSubscript:) with:@selector(safe_setObject:forKeyedSubscript:)];
        [class hz_swizzleInstanceMethod:@selector(removeObjectForKey:) with:@selector(safe_removeObjectForKey:)];
        
    });
}

- (void)safe_setObject:(id)obj forKey:(id)key {
    if (HZ_invalidSafeDictionaryWithKey(obj) ||
        HZ_invalidSafeDictionaryWithKey(key)) {
        return;
    }
    [self safe_setObject:obj forKey:key];
}

- (void)safe_setObject:(id)obj forKeyedSubscript:(id)key {
    //obj can be nil.
    //for instance => abc[@"d"] = nil;
    if (HZ_invalidSafeDictionaryWithKey(key)) {
        return;
    }
    [self safe_setObject:obj forKeyedSubscript:key];
}

- (void)safe_removeObjectForKey:(id)key
{
    if (HZ_invalidSafeDictionaryWithKey(key)) {
        return;
    }
    [self safe_removeObjectForKey:key];
}

#pragma mark - others

@end

