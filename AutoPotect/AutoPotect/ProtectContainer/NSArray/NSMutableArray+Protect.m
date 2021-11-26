//
//  NSMutableArray+Protect.m
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Protect.h"
#import <objc/runtime.h>
#import "NSObject+Protect.h"
#import "ProtectMacro.h"


#ifdef DEBUG
    #define HZ_ArrayAssert(IDX, COUNT)                                                                          \
    {                                                                                                           \
        NSAssert(NO,                                                                                            \
                @"自动防护提示 NSMutableArray assert => index out of range %s:%d index {%lu} beyond bounds [0...%lu]",       \
                __PRETTY_FUNCTION__,                                                                            \
                __LINE__,                                                                                       \
                (unsigned long)(IDX),                                                                           \
                MAX((unsigned long)(COUNT) - 1, 0));                                                            \
    }
#else
    #define HZ_ArrayAssert(IDX, COUNT)                                                                          \
    {                                                                                                           \
        NSLog(@"自动防护 NSMutableArray error => index out of range %s:%d index {%lu} beyond bounds [0...%lu]",     \
                __PRETTY_FUNCTION__,                                                                            \
                __LINE__,                                                                                       \
                (unsigned long)(IDX),                                                                           \
                MAX((unsigned long)(COUNT) - 1, 0));                                                            \
    }
#endif

#ifdef DEBUG
    #define HZ_invalidSafeArrayWithObj(OBJ)                                                             \
    (                                                                                                   \
        (!(OBJ)) ?                                                                                      \
        ({                                                                                              \
            NSAssert(NO,                                                                                \
                @"自动防护提示 NSMutableArray assert => invalid obj %s:%d name:%@ class:%@ val:%@",                  \
                __PRETTY_FUNCTION__,                                                                    \
                __LINE__,                                                                               \
                @""#OBJ,                                                                                \
                NSStringFromClass([(OBJ) class]),                                                       \
                (OBJ));                                                                                 \
                YES;                                                                                    \
        })                                                                                              \
        :                                                                                               \
        NO                                                                                              \
    )
#else
    #define HZ_invalidSafeArrayWithObj(OBJ)                                                             \
    (                                                                                                   \
        (!(OBJ)) ?                                                                                      \
        ({                                                                                              \
                NSLog(@"自动防护 NSMutableArray error => invalid obj %s:%d name:%@ class:%@ val:%@\n %@",       \
                __PRETTY_FUNCTION__,                                                                    \
                __LINE__,                                                                               \
                @""#OBJ,                                                                                \
                NSStringFromClass([(OBJ) class]),                                                       \
                (OBJ),                                                                                  \
                [NSThread callStackSymbols]);                                                           \
                YES;                                                                                    \
        })                                                                                              \
        :                                                                                               \
        NO                                                                                              \
    )
#endif

#ifdef DEBUG
    #define CheckIsIndexOutOfRange(IDX)                                                                         \
    (                                                                                                           \
        (self.count <= (IDX)) ?                                                                                 \
        ({                                                                                                      \
            HZ_ArrayAssert((IDX), (self.count));                                                                \
            YES;                                                                                                \
        })                                                                                                      \
        :                                                                                                       \
        NO                                                                                                      \
    )
#else
    #define CheckIsIndexOutOfRange(IDX)                                                                         \
    (                                                                                                           \
        (self.count <= (IDX)) ?                                                                                 \
        ({                                                                                                      \
            HZ_ArrayAssert((IDX), (self.count));                                                                \
            YES;                                                                                                \
        })                                                                                                      \
        :                                                                                                       \
        NO                                                                                                      \
    )
#endif

#ifdef DEBUG
    #define HZ_CountDiffAssert(SET_COUNT, ARRAY_COUNT)                                                              \
    (                                                                                                               \
        ((SET_COUNT) != (ARRAY_COUNT)) ?                                                                            \
        ({                                                                                                          \
            NSAssert(NO,                                                                                            \
                @"自动防护提示 NSMutableArray assert => %s:%d count of array {%lu} differs from count of index set {%lu}",       \
                __PRETTY_FUNCTION__,                                                                                \
                __LINE__,                                                                                           \
                (unsigned long)(SET_COUNT),                                                                         \
                (unsigned long)(ARRAY_COUNT));                                                                      \
            YES;                                                                                                    \
        })                                                                                                          \
        :                                                                                                           \
        NO                                                                                                          \
    )
#else
    #define HZ_CountDiffAssert(SET_COUNT, ARRAY_COUNT)                                                              \
    (                                                                                                               \
        ((SET_COUNT) != (ARRAY_COUNT)) ?                                                                            \
        ({                                                                                                          \
            NSLog(@"自动防护 NSMutableArray error => %s:%d count of array {%lu} differs from count of index set {%lu}", \
                __PRETTY_FUNCTION__,                                                                                \
                __LINE__,                                                                                           \
                (unsigned long)(SET_COUNT),                                                                         \
                (unsigned long)(ARRAY_COUNT));                                                                      \
            YES;                                                                                                    \
        })                                                                                                          \
        :                                                                                                           \
        NO                                                                                                          \
    )
#endif

@implementation NSMutableArray (Protect)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSArrayM");
        [class hz_swizzleInstanceMethod:@selector(addObject:) with:@selector(safe_addObject:)];
        [class hz_swizzleInstanceMethod:@selector(insertObject:atIndex:) with:@selector(safe_insertObject:atIndex:)];
        [class hz_swizzleInstanceMethod:@selector(removeObjectAtIndex:) with:@selector(safe_removeObjectAtIndex:)];
        [class hz_swizzleInstanceMethod:@selector(replaceObjectAtIndex:withObject:) with:@selector(safe_replaceObjectAtIndex:withObject:)];
        [class hz_swizzleInstanceMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) with:@selector(safe_exchangeObjectAtIndex:withObjectAtIndex:)];
        [class hz_swizzleInstanceMethod:@selector(removeObject:inRange:) with:@selector(safe_removeObject:inRange:)];
        [class hz_swizzleInstanceMethod:@selector(removeObjectIdenticalTo:inRange:) with:@selector(safe_removeObjectIdenticalTo:inRange:)];
        [class hz_swizzleInstanceMethod:@selector(removeObjectsInRange:) with:@selector(safe_removeObjectsInRange:)];
        [class hz_swizzleInstanceMethod:@selector(replaceObjectsInRange:withObjectsFromArray:range:) with:@selector(safe_replaceObjectsInRange:withObjectsFromArray:range:)];
        [class hz_swizzleInstanceMethod:@selector(replaceObjectsInRange:withObjectsFromArray:) with:@selector(safe_replaceObjectsInRange:withObjectsFromArray:)];
        [class hz_swizzleInstanceMethod:@selector(setArray:) with:@selector(safe_setArray:)];
        [class hz_swizzleInstanceMethod:@selector(insertObjects:atIndexes:) with:@selector(safe_insertObjects:atIndexes:)];
        [class hz_swizzleInstanceMethod:@selector(removeObjectsAtIndexes:) with:@selector(safe_removeObjectsAtIndexes:)];
        [class hz_swizzleInstanceMethod:@selector(replaceObjectsAtIndexes:withObjects:) with:@selector(safe_replaceObjectsAtIndexes:withObjects:)];
        [class hz_swizzleInstanceMethod:@selector(setObject:atIndexedSubscript:) with:@selector(safe_setObject:atIndexedSubscript:)];
        
        //otherArray nullable
        //- (void)addObjectsFromArray:(NSArray<ObjectType> *)otherArray;
        //anObject nullable
        //- (void)removeObject:(ObjectType)anObject;
        //anObject nullable
        //- (void)removeObjectIdenticalTo:(ObjectType)anObject;
        //otherArray nullable
        //- (void)removeObjectsInArray:(NSArray<ObjectType> *)otherArray;
    });
}

//底层最终会调用insertObject:atIndex:
//这里只是为了能看callStack
- (void)safe_addObject:(id)obj
{
    return [self safe_addObject:obj];
}

- (void)safe_insertObject:(id)obj atIndex:(NSUInteger)index
{
    if (HZ_invalidSafeArrayWithObj(obj)) {
        return;
    }
    //count 等于 index 的情况并不会闪退
    if (!(self.count == index) &&
        CheckIsIndexOutOfRange(index)) {
        return;
    }
    return [self safe_insertObject:obj atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index
{
    if (CheckIsIndexOutOfRange(index)) {
        return;
    }
    return [self safe_removeObjectAtIndex:index];
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)obj
{
    if (CheckIsIndexOutOfRange(index) ||
        HZ_invalidSafeArrayWithObj(obj)) {
        return;
    }
    return [self safe_replaceObjectAtIndex:index withObject:obj];
}

- (void)safe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    if (CheckIsIndexOutOfRange(idx1) ||
        CheckIsIndexOutOfRange(idx2)) {
        return;
    }
    return [self safe_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)safe_removeObject:(id)obj inRange:(NSRange)range
{
    //obj is nullable
    if (!obj) return;
    NSUInteger index = range.location + range.length;
    if (!(self.count == index) &&
        CheckIsIndexOutOfRange(index)) {
        return;
    }
    return [self safe_removeObject:obj inRange:range];
}

- (void)safe_removeObjectIdenticalTo:(id)obj inRange:(NSRange)range
{
    //obj is nullable
    if (!obj) return;
    NSUInteger index = range.location + range.length;
    if (!(self.count == index) &&
        CheckIsIndexOutOfRange(index)) {
        return;
    }
    return [self safe_removeObjectIdenticalTo:obj inRange:range];
}

- (void)safe_removeObjectsInRange:(NSRange)range
{
    NSUInteger index = range.location + range.length;
    if (!(self.count == index) &&
        CheckIsIndexOutOfRange(index)) {
        return;
    }
    return [self safe_removeObjectsInRange:range];
}

- (void)safe_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray range:(NSRange)otherRange
{
    //otherArray is nullable
    NSUInteger index = range.location + range.length;
    NSUInteger otherIndex = otherRange.location + otherRange.length;
    if ((!(self.count == index) && CheckIsIndexOutOfRange(index)) ||
        (!(otherArray.count == otherIndex) && otherIndex >= otherArray.count)) {
        HZ_ArrayAssert(otherIndex, otherArray.count);
        return;
    }
    return [self safe_replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)safe_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray
{
    //otherArray is nullable
    NSUInteger index = range.location + range.length;
    if (!(self.count == index) && CheckIsIndexOutOfRange(index)) {
        return;
    }
    return [self safe_replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)safe_setArray:(NSArray<id> *)otherArray
{
    //otherArray is nullable
    if (!otherArray) return;
    if (HZCheckInvalidAndKindOfClass(otherArray, NSArray)) return;
    return [self safe_setArray:otherArray];
}

- (void)safe_insertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes
{
    //objects nullable but range of indexes cannot larger than objects.count
    //indexes cannot be nil
    if (HZCheckInvalidAndKindOfClass(indexes, NSIndexSet)) return;
    NSUInteger firstIndex = indexes.firstIndex;
    NSUInteger lastIndex = indexes.lastIndex;
    if (NSNotFound == firstIndex ||
        NSNotFound == lastIndex ||
        (objects.count + self.count < lastIndex)) { //insertObjects 时 objects.count + self.count == lastIndex 并不会导致闪退
        HZ_ArrayAssert(lastIndex, objects.count + self.count);
        return;
    }
    
    return [self safe_insertObjects:objects atIndexes:indexes];
}

- (void)safe_removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    //indexes cannot be nil
    if (HZCheckInvalidAndKindOfClass(indexes, NSIndexSet)) return;
    if (![self isValidIndexSet:indexes]) {
        return;
    }
    return [self safe_removeObjectsAtIndexes:indexes];
}

- (void)safe_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<id> *)objects
{
    //indexes cannot be nil
    if (HZCheckInvalidAndKindOfClass(indexes, NSIndexSet)) return;
    //objects is nullable
    if (!objects) return;
    if (HZCheckInvalidAndKindOfClass(objects, NSArray)) return;
    
    //count of array could not differ from count of index set
    if (HZ_CountDiffAssert(indexes.count, objects.count)) return;
    
    [self safe_replaceObjectsAtIndexes:indexes withObjects:objects];
}


- (void)safe_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    if (HZ_invalidSafeArrayWithObj(obj)) return;
    if (!(self.count == idx) && CheckIsIndexOutOfRange(idx)) {
        return;
    }
    return [self safe_setObject:obj atIndexedSubscript:idx];
}

#pragma mark - others
- (BOOL)isValidIndexSet:(NSIndexSet *)indexes
{
    if (HZCheckInvalidAndKindOfClass(indexes, NSIndexSet)) return NO;
    NSUInteger firstIndex = indexes.firstIndex;
    NSUInteger lastIndex = indexes.lastIndex;
    //[NSIndexSet indexSet] => NSNotFound == firstIndex && NSNotFound == lastIndex
    //In this case, app could not crash
    if (NSNotFound == firstIndex && NSNotFound == lastIndex) return YES;
    if (CheckIsIndexOutOfRange(lastIndex)) return NO;
    return YES;
}



@end
