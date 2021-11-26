//
//  HZTestObject.m
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//


#import "HZTestObject.h"

@implementation HZTestObject

+ (void)testArrayCase
{
    NSArray *list = @[@"1",@"2"];
    id obj = [list objectAtIndex:2];
//    NSMutableArray *list = [NSMutableArray array];
//    NSMutableArray *otherList = [NSMutableArray arrayWithArray:@[@"otherA", @"otherB", @"otherC"]];
//    [list addObject:nil];
//    //[list removeObjectAtIndex:2];
//    [list insertObject:@"a" atIndex:0];
//    [list insertObject:@"b" atIndex:1];
//    //    [list insertObject:@"c" atIndex:3];
//    //    [list replaceObjectAtIndex:2 withObject:@"b"];
//    //[list replaceObjectAtIndex:1 withObject:nil];
//    //[list addObjectsFromArray:nil];
//    //[list exchangeObjectAtIndex:3 withObjectAtIndex:0];
//    //[list removeObject:@"b" inRange:NSMakeRange(1, 2)];
//    //[list removeObject:nil];
//    //[list removeObjectIdenticalTo:nil inRange:NSMakeRange(1, 2)];
//    //[list removeObjectIdenticalTo:nil];
//    //[list removeObjectsInArray:nil];
//    //[list removeObjectsInRange:NSMakeRange(1, 2)];
//    //[list replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:nil range:NSMakeRange(0, 0)];
//    //[list replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:otherList range:NSMakeRange(1, 3)];
//    //[list replaceObjectsInRange:(NSRange){0, 0} withObjectsFromArray:nil range:(NSRange){0, 1}];//bad
//    //[list replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:nil];
//    //[list setArray:nil];
//    //[list insertObjects:@[@"c", @"d", @"e"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){1, 3}]];
//    //[list insertObjects:@[@"c", @"d", @"e"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){2, 4}]];
//    //[list removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){2, 1}]];
//    //[list removeObjectsAtIndexes:nil];
//    //firstIndex == NSNotFound && lastIndex == NSNotFound
//    //[list removeObjectsAtIndexes:[NSIndexSet indexSet]];
//    //[list removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){2, 1}]];
//    //[list replaceObjectsAtIndexes:nil withObjects:nil];
//    //[list replaceObjectsAtIndexes:[NSIndexSet indexSet] withObjects:nil];
//    //[list replaceObjectsAtIndexes:[NSIndexSet indexSet] withObjects:@[]];
//    //[list replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){1, 1}] withObjects:@[@"abc", @"cde"]];
//    //list[1] = nil;
//    //list[2] = @"c";
//    //list[3] = @"c";
}

+ (void)testDictCase
{
    NSString *emptyKey = nil;
    NSString *emptyObj = nil;
    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", emptyObj, emptyKey, @"2", @"3", @"3", nil];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"3", nil];
    
    //NSLog(@"dict:%@", dict);
    //NSDictionary *dict = [NSDictionary dictionaryWithObject:emptyObj forKey:emptyKey];
//    NSDictionary *dict = @{@"key" : emptyObj, emptyKey : @"val", @"3" : @"3"};
    //NSDictionary *dict = [NSDictionary dictionaryWithObject:@"val" forKey:nil];
    //NSDictionary *dict = [NSDictionary dictionaryWithDictionary:nil];
    //NSDictionary *dict = [NSDictionary dictionaryWithObjects:nil forKeys:nil];
    //[dict setObject:nil forKey:nil];
    
    //NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    //[mutableDict removeObjectForKey:nil];
    //[mutableDict removeObjectsForKeys:nil];
    //[mutableDict setDictionary:nil];
    
    //    - (instancetype)initWithDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;
    //    - (instancetype)initWithDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary copyItems:(BOOL)flag;
    //    - (instancetype)initWithObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType <NSCopying>> *)keys;
    
    //dict[emptyKey] = nil;
    
    //    Class class = NSClassFromString(@"NSObject");
    //    SEL sel = @selector(modelWithType:tag:title:);
    //    NSMethodSignature *sig = [class methodSignatureForSelector:sel];
    //    if (!sig) { [class doesNotRecognizeSelector:sel]; return nil; }
    //    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    //    if (!inv) { [class doesNotRecognizeSelector:sel]; return nil; }
    //    [inv setTarget:self];
    //    [inv setSelector:sel];
    
    //    + (instancetype)modelWithType:(modetype)type
    //tag:(NSUInteger)tag
    //title:(NSString *)title;
    
    //[inv setArgument:&firstObject atIndex:2];
}


@end
