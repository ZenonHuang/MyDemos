//
//  HZCenterFanButton.h
//  FanButton
//
//  Created by ZenonHuang on 2019/11/18.
//  Copyright © 2019 zenon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZCenterFanButton;

@protocol HZCenterFanButtonDelegate <NSObject>

@optional
- (void)clickBtnWithIndex:(NSInteger)index;
@end

@interface HZCenterFanButton : UIControl
@property (nonatomic,strong) NSArray  *textList;
@property (nonatomic,copy)   NSString *title;

@property (nonatomic,weak) id<HZCenterFanButtonDelegate> delegate;
@end
