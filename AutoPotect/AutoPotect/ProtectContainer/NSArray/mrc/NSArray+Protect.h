//
//  NSArray+Protect.h
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType>  (Protect)

- (ObjectType)safeObjectAtIndex:(NSUInteger)index;

- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;

@end
