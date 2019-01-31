//
//  HZCountDownButton.h
//  HZCountTimeButton
//
//  Created by ZenonHuang on 2019/1/30.
//  Copyright © 2019年 zenon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZCountDownButton : UIButton
///平常状态的按钮文字
@property (nonatomic,strong) NSString *normalTitle;
@property (nonatomic,strong) UIColor *normalTitleColor;
///等待倒计时状态的按钮文字
@property (nonatomic,strong) NSString *waitTitle;
@property (nonatomic,strong) UIColor *waitTitleColor;

@property (nonatomic,assign) NSInteger countSeconds;

///不用时记得停止计时，否则定时器会一直持有
- (void)pasuseCount;
@end
