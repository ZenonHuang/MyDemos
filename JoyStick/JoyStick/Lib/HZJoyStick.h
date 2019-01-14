//
//  HZJoyStick.h
//  JoyStick
//
//  Created by ZenonHuang on 2019/1/14.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HZJoyStickDelegate <NSObject>

@optional
- (void)hz_joyStickDidMoveOffsetX:(CGFloat)x offsetY:(CGFloat)y;

@end

@interface HZJoyStick : UIView
@property (nonatomic,weak) id<HZJoyStickDelegate> moveDelegate;
@property (nonatomic,assign) BOOL inMove;
@end
