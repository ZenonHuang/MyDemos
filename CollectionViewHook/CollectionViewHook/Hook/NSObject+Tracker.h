//
//  NSObject+Tracker.h
//  CollectionViewHook
//
//  Created by zz go on 2019/9/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tracker)



+ (BOOL)HZ_swizzleMethod:(SEL)originalSel newSel:(SEL)newSel;

+ (BOOL)HZ_methodHasSwizzed:(SEL)sel;
+ (void)HZ_setMethodHasSwizzed:(SEL)sel;
+ (SEL)HZ_newSelFormOriginalSel:(SEL)sel;


@end
