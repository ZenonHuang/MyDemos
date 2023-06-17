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
    
    
#warning todo 核心逻辑
//    [self preSwizzleForDelegate:delegate];//问题方案
    [self afterSwizzleForDelegate:delegate];//解决方案
    
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
            NSLog(@"orginClass %@ originMethod %p",NSStringFromClass(delegate.class),originIMP);
        
            IMP newIMP =  (IMP)HZ_collectionViewDidSelectRowAtIndexPath;
            NSLog(@"orginClass %@ newMethod %p",NSStringFromClass(delegate.class),newIMP);
      
      // -------- delegate对象没实现sel时  -------- begin -------- //
      // ---- 若delegate未实现该代理方法，那就给其动态添加一个默认实现 - 旧方法，然后就可以 使用swizzle魔法 以旧换新。
      if (![delegate respondsToSelector:sel]) {
        //BOOL addOK =
        class_addMethod([delegate class],
                        sel,
                        (IMP)twoParamsMethod,
                        method_getTypeEncoding(class_getInstanceMethod(delegate.class, newSel)));
        //NSLog(@" %@ ------- addOK:%@", delegate, @(addOK));
        
        originMethod = class_getInstanceMethod(delegate.class, sel);
      }
      // -------- delegate对象没实现sel时  -------- end -------- //
      // 好处：如上这样处理后，该工具可以放心提供给他人使用了，不用担心接入者写代码时 是否实现了'collectionView:didSelectItemAtIndexPath:'

            if (originMethod 
                && !(originIMP==newIMP)) {
            
                class_addMethod(delegate.class, newSel,newIMP, method_getTypeEncoding(originMethod));
                [delegate.class HZ_swizzleMethod:sel newSel:newSel];
            }
        }
}

void twoParamsMethod(id self, SEL _cmd, UICollectionView *collectionView, NSIndexPath *indexPath) {
  NSLog(@" ------- twoParamsMethod: %@, \nscrollView: %@\nindexPath: %@", self, collectionView, indexPath);
}

@end

