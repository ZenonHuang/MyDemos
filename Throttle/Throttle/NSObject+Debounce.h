//
//  NSObject+Debounce.h
//  Throttle
//
//  Created by mewe on 2018/9/12.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Debounce : NSObject
@property (nonatomic,copy  ) NSString *aSelector;
@property (nonatomic,assign) NSTimeInterval inteval;
@property (nonatomic,strong) NSInvocationOperation *lastOperation;
@end

@interface NSObject (Debounce)

- (void)hz_performWithDebounce:(Debounce *)debounceObj;

@end
