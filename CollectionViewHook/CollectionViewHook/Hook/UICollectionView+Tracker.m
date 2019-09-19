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
    NSLog(@"_cmd %@",NSStringFromSelector(_cmd));
    //调到这里肯定实现了HZ_tableView:didSelectRowAtIndexPath:，去除warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    SEL sel = [NSObject HZ_newSelFormOriginalSel:@selector(collectionView:didSelectItemAtIndexPath:)];
    [self performSelector:sel
               withObject:collectionView 
               withObject:indexPath];
#pragma clang diagnostic pop
}

@implementation UICollectionView (Tracker)

- (void)HZ_setDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([delegate isKindOfClass:[NSObject class]]) {
        SEL sel = @selector(collectionView:didSelectItemAtIndexPath:);
        
        //newSel = HZ_collectionView:didSelectItemAtIndexPath:
        SEL newSel = [NSObject HZ_newSelFormOriginalSel:sel ];
        
        Method originMethod = class_getInstanceMethod(delegate.class, sel);
        
        NSString *originMethodAddress = [NSString stringWithFormat:@"%p",originMethod];
        NSLog(@"originMethod %@",originMethodAddress);
        
        if (originMethod && ![delegate.class HZ_methodHasSwizzed:sel]) {
//    解决方案    if (originMethod && ![[HZTrackerCenter sharedInstance] HZ_swizzleHasSetMethodFor:originMethodAddress]) {
            
            IMP newIMP =  (IMP)HZ_collectionViewDidSelectRowAtIndexPath;
            class_addMethod(delegate.class, newSel,newIMP, method_getTypeEncoding(originMethod));
            [delegate.class HZ_swizzleMethod:sel newSel:newSel];
            
            [delegate.class HZ_setMethodHasSwizzed:sel];
            [[HZTrackerCenter sharedInstance] HZ_swizzleSetMethod:originMethodAddress forClss:NSStringFromClass(delegate.class) ];
        }
    }
    [self HZ_setDelegate:delegate];
}

+ (void)HZ_swizzle {
    [UICollectionView HZ_swizzleMethod:@selector(setDelegate:)
                                newSel:@selector(HZ_setDelegate:)];
}

@end

