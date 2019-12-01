//
//  UICollectionView+Tracker.m
//  CollectionViewHook
//
//  Created by zz go on 2019/9/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "UICollectionView+Tracker.h"
#import "HZTrackerCenter.h"

#import <objc/runtime.h>

#import "NSObject+Tracker.h"

void HZ_collectionViewDidSelectRowAtIndexPath(id self, SEL _cmd, UICollectionView *collectionView, NSIndexPath *indexPath) {
    
   //Do tracker something
    NSLog(@"日志: tracker _cmd %@",NSStringFromSelector(_cmd));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    SEL sel = [NSObject HZ_newSelFormOriginalSel:@selector(collectionView:didSelectItemAtIndexPath:)];
    [self performSelector:sel
               withObject:collectionView 
               withObject:indexPath];
#pragma clang diagnostic pop
}

@implementation UICollectionView (Tracker)

+ (void)HZ_swizzle {
    [UICollectionView HZ_swizzleMethod:@selector(setDelegate:)
                                newSel:@selector(HZ_setDelegate:)];
}


- (void)HZ_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    [self preSwizzleForDelegate:delegate];
//    [self afterSwizzleForDelegate:delegate];
    
    [self HZ_setDelegate:delegate];
}


// 问题方案
- (void)preSwizzleForDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([delegate isKindOfClass:[NSObject class]]) {
        SEL sel = @selector(collectionView:didSelectItemAtIndexPath:);
        
        //newSel = HZ_collectionView:didSelectItemAtIndexPath:
        SEL newSel = [NSObject HZ_newSelFormOriginalSel:sel ];
        
        Method originMethod = class_getInstanceMethod(delegate.class, sel);
        
        if (originMethod && ![delegate.class HZ_methodHasSwizzed:sel]) {   
            IMP newIMP =  (IMP)HZ_collectionViewDidSelectRowAtIndexPath;
            class_addMethod(delegate.class, newSel,newIMP, method_getTypeEncoding(originMethod));
            
            [delegate.class HZ_swizzleMethod:sel newSel:newSel];
            
            [delegate.class HZ_setMethodHasSwizzed:sel];
        }
    }
}

//解决方案
- (void)afterSwizzleForDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([delegate isKindOfClass:[NSObject class]]) {
            SEL sel = @selector(collectionView:didSelectItemAtIndexPath:);
            
            //newSel = HZ_collectionView:didSelectItemAtIndexPath:
            SEL newSel = [NSObject HZ_newSelFormOriginalSel:sel ];
            
            Method originMethod = class_getInstanceMethod(delegate.class, sel);
            
            IMP originIMP = method_getImplementation(originMethod);
            NSString *originIMPAddress = [NSString stringWithFormat:@"%p",originIMP];
            
            NSLog(@"orginClass %@ originMethod %@",NSStringFromClass(delegate.class),originIMPAddress);
        
            IMP newIMP =  (IMP)HZ_collectionViewDidSelectRowAtIndexPath;

            if (originMethod 
                && !(originIMP==newIMP)) {
            
                class_addMethod(delegate.class, newSel,newIMP, method_getTypeEncoding(originMethod));
                [delegate.class HZ_swizzleMethod:sel newSel:newSel];
            }
        }
}


@end

