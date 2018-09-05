//
//  Fizz.m
//  KVOTest
//
//  Created by mewe on 2018/3/23.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "Fizz.h"

@implementation Fizz

- (instancetype)init {
    if (self = [super init]) {
        _number = @0;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"Fizz dealloc");
}
@end
