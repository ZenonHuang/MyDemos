//
//  NSObject+Protect.h
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//

#import <Foundation/Foundation.h>

@interface NSObject (Protect)

+ (BOOL)hz_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

+ (BOOL)hz_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

@end
