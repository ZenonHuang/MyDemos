//
//  NSObject+Tracker.m
//  CollectionViewHook
//
//  Created by zz go on 2019/9/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "NSObject+Tracker.h"

#import <objc/runtime.h>

@implementation NSObject (Tracker)

+ (BOOL)HZ_swizzleMethod:(SEL)originalSel newSel:(SEL)newSel {
    Method originMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    
    if (originMethod && newMethod) {
        if (class_addMethod(self, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            
            IMP orginIMP = method_getImplementation(originMethod);
            class_replaceMethod(self, newSel, orginIMP, method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, newMethod);
        }
        return YES;
    }
    return NO;
}

+ (BOOL)HZ_methodHasSwizzed:(SEL)sel {
    NSNumber *num = objc_getAssociatedObject(self, NSSelectorFromString([self HZ_stringFromSelector:sel]));
    return [num boolValue];
}

+ (void)HZ_setMethodHasSwizzed:(SEL)sel {
    objc_setAssociatedObject(self, NSSelectorFromString([self HZ_stringFromSelector:sel]), @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (SEL)HZ_newSelFormOriginalSel:(SEL)sel {
    return NSSelectorFromString([self HZ_stringFromSelector:sel]);
}

+ (NSString*)HZ_stringFromSelector:(SEL)sel {
    return [NSString stringWithFormat:@"HZ_%@",NSStringFromSelector(sel)];
}


@end

