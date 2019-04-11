//
//  HZAlignViewPlugin.h
//  HZAlignView
//
//  Created by ZenonHuang on 2019/4/11.
//  Copyright © 2019年 zenon. All rights reserved.
//

#import "UIView+YYAdd.h"
#import <UIKit/UIKit.h>

@interface HZAlignViewPlugin : NSObject
@property (nonatomic,weak)   UIView *targetView;


+ (HZAlignViewPlugin *)shareInstance;

- (void)showAlignLineFor:(UIView *)view;
- (void)changePostion;
- (void)hiddenAlignLine;
@end
