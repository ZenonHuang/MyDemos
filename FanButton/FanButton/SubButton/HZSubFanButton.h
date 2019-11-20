//
//  HZSubFanButton.h
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZSubFanButton;

@protocol HZSubFanButtonDelegate <NSObject>

@optional
- (void)clickBtn:(HZSubFanButton *)btn;

@end

@interface HZSubFanButton : UIButton

@property (nonatomic,weak) id<HZSubFanButtonDelegate> delegate;

@property (nonatomic,assign) CGFloat startAngle;
@property (nonatomic,assign) CGFloat endAngle;

@property (nonatomic,strong) UIBezierPath *bezierPath;//用于判断点击是否在画出来图形中
@property (nonatomic,assign) BOOL    textNeedTransform;
@property (nonatomic,copy)   NSString *text;
@property (nonatomic,assign) NSInteger index;
 
+ (instancetype)buttonWithAngle:(CGFloat)startAngle
                       endAngle:(CGFloat)endAngle;
@end
