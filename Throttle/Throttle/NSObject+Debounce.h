//
//  NSObject+Debounce.h
//  Throttle
//
//  Created by mewe on 2018/9/12.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Debounce)

- (void)hz_performSelector:(SEL)aSelector withDebounce:(NSTimeInterval)inteval;

@end
