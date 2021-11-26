//
//  NSArray+Protect.m
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//

#import "NSArray+Protect.h"
#import <objc/runtime.h>
#import "NSObject+Protect.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

#ifdef DEBUG
    #define CheckIsIndexOutOfRange(IDX)                                                                 \
    (                                                                                                   \
        (self.count <= (IDX)) ?                                                                         \
        ({                                                                                              \
            NSAssert(NO,                                                                                \
                    @"自动防护提示 NSArray assert => index out of range %s:%d index {%lu} beyond bounds [0...%lu]",  \
                    __PRETTY_FUNCTION__,                                                                \
                    __LINE__,                                                                           \
                    (unsigned long)(IDX),                                                               \
                    MAX((unsigned long)self.count - 1, 0));                                             \
            YES;                                                                                        \
        })                                                                                              \
        :                                                                                               \
        NO                                                                                              \
        )
#else
    #define CheckIsIndexOutOfRange(IDX)                                                                 \
    (                                                                                                   \
        (self.count <= (IDX)) ?                                                                         \
        ({                                                                                              \
            NSLog(NO,                                                                                \
            @"自动防护 NSArray assert => index out of range %s:%d index {%lu} beyond bounds [0...%lu]",  \
            __PRETTY_FUNCTION__,                                                                \
            __LINE__,                                                                           \
            (unsigned long)(IDX),                                                               \
            MAX((unsigned long)self.count - 1, 0));                                             \
            YES;                                                                                        \
        })                                                                                              \
        :                                                                                               \
        NO                                                                                              \
    ) 
#endif

@implementation NSArray (Protect)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArray0") hz_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(emptyArray_objectAtIndex:)];
        [objc_getClass("__NSArrayI") hz_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(arrayI_objectAtIndex:)];
        [objc_getClass("__NSArrayM") hz_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(arrayM_objectAtIndex:)];
        [objc_getClass("__NSSingleObjectArrayI") hz_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(singleObjectArrayI_objectAtIndex:)];
        
        [objc_getClass("__NSArray0") hz_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(emptyArray_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayI") hz_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(arrayI_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") hz_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(arrayM_objectAtIndexedSubscript:)];
        [objc_getClass("__NSSingleObjectArrayI") hz_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(singleObjectArrayI_objectAtIndexedSubscript:)];
    });
}

#pragma mark - objectAtIndex
- (id)emptyArray_objectAtIndex:(NSUInteger)index
{
    return nil;
}

- (id)arrayI_objectAtIndex:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index))
    {
        return nil;
    }
    return [self arrayI_objectAtIndex:index];
}

- (id)arrayM_objectAtIndex:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index))
    {
        return nil;
    }
    return [self arrayM_objectAtIndex:index];
}

- (id)singleObjectArrayI_objectAtIndex:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index))
    {
        return nil;
    }
    return [self singleObjectArrayI_objectAtIndex:index];
}

#pragma mark - objectAtIndexedSubscript
- (id)emptyArray_objectAtIndexedSubscript:(NSUInteger)index
{
    return nil;
}

- (id)arrayI_objectAtIndexedSubscript:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index))
    {
        return nil;
    }
    return [self arrayI_objectAtIndexedSubscript:index];
}

- (id)arrayM_objectAtIndexedSubscript:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index))
    {
        return nil;
    }
    return [self arrayM_objectAtIndexedSubscript:index];
}

- (id)singleObjectArrayI_objectAtIndexedSubscript:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index))
    {
        return nil;
    }
    return [self singleObjectArrayI_objectAtIndexedSubscript:index];
}

#pragma mark - safeObjectAtIndex
- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index))
    {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

/**
 字面量
 */
- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self safeObjectAtIndex:idx];
}

@end

