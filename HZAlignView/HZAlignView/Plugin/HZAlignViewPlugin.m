//
//  HZAlignViewPlugin.m
//  HZAlignView
//
//  Created by ZenonHuang on 2019/4/11.
//  Copyright © 2019年 zenon. All rights reserved.
//

#import "HZAlignViewPlugin.h"

#define HZScreenWidth [UIScreen mainScreen].bounds.size.width
#define HZScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HZAlignViewPlugin ()
@property (nonatomic,strong) UIView *alignView;

@property (nonatomic,strong) UIView *horizontalLine;//水平线
@property (nonatomic,strong) UIView *verticalLine;//垂直线
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *bottomLabel;
@end

@implementation HZAlignViewPlugin

+ (HZAlignViewPlugin *)shareInstance{
    static dispatch_once_t once;
    static HZAlignViewPlugin *instance;
    dispatch_once(&once, ^{
        instance = [[HZAlignViewPlugin alloc] init];
    });
    return instance;
}

#pragma mark - public

- (void)showAlignLineFor:(UIView *)view
{
    self.targetView = view;
    
//    self.alignView.hidden = YES;
    UIWindow *delegateWindow = [[UIApplication sharedApplication].delegate window];
    [delegateWindow addSubview:self.alignView];
    
    [self.alignView addSubview:self.horizontalLine];
    [self.alignView addSubview:self.verticalLine];
    
    [self.alignView addSubview:self.leftLabel];
    [self.alignView addSubview:self.rightLabel];
    [self.alignView addSubview:self.topLabel];
    [self.alignView addSubview:self.bottomLabel];
    [self layoutLabels];
}

- (void)changePostion
{
    [self resetPosition];
    [self layoutLabels];
}

- (void)hiddenAlignLine
{
    [self.alignView removeAllSubviews];
    [self.alignView removeFromSuperview];
    self.targetView = nil;
}

#pragma mrak - private

- (void)resetPosition
{
    self.horizontalLine.frame = CGRectMake(0, self.targetView.centerY-0.25, self.alignView.width, 0.5);
    self.verticalLine.frame = CGRectMake(self.targetView.centerX-0.25, 0, 0.5, self.alignView.height);
}

- (UILabel *)createLabel
{
    UILabel  *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    return label;
}

- (void)layoutLabels
{
    self.leftLabel.text = [self leftText];
    [self.leftLabel sizeToFit];
    self.leftLabel.frame = CGRectMake(self.targetView.centerX/2, self.targetView.centerY-self.leftLabel.height, self.leftLabel.width, self.leftLabel.height);
    
    self.topLabel.text = [NSString stringWithFormat:@"%.1f",self.targetView.centerY];
    [self.topLabel sizeToFit];
    self.topLabel.frame = CGRectMake(self.targetView.centerX-self.topLabel.width, self.targetView.centerY/2, self.topLabel.width, self.topLabel.height);
    
    self.rightLabel.text = [NSString stringWithFormat:@"%.1f",self.alignView.width-self.targetView.centerX];
    [self.rightLabel sizeToFit];
    self.rightLabel.frame = CGRectMake(self.targetView.centerX+(self.alignView.width-self.targetView.centerX)/2, self.targetView.centerY-self.rightLabel.height, self.rightLabel.width, self.rightLabel.height);
    
    self.bottomLabel.text = [NSString stringWithFormat:@"%.1f",self.alignView.height - self.targetView.centerY];
    [self.bottomLabel sizeToFit];
    self.bottomLabel.frame = CGRectMake(self.targetView.centerX-self.bottomLabel.width, self.targetView.centerY+(self.alignView.height - self.targetView.centerY)/2, self.bottomLabel.width, self.bottomLabel.height);
}

- (NSString *)leftText
{
    return [NSString stringWithFormat:@"%.1f",self.targetView.centerX];
}

- (NSString *)rightText
{
    return [NSString stringWithFormat:@"%.1f",self.targetView.centerX];
}

- (NSString *)topText
{
    return  [NSString stringWithFormat:@"%.1f",self.targetView.width-self.targetView.centerX];
}

- (NSString *)bottomText
{
    return  [NSString stringWithFormat:@"%.1f",self.targetView.height-self.targetView.centerY];
}

#pragma mark - getter
- (UIView *)alignView
{
    if (!_alignView) {
        _alignView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HZScreenWidth, HZScreenHeight)];
    }
    return _alignView;
}

- (UIView *)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.targetView.centerY-0.25, self.alignView.width, 0.5)];
        _horizontalLine.backgroundColor = [UIColor grayColor];
    }
    return _horizontalLine;
}

- (UIView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.targetView.centerX-0.25, 0, 0.5, self.alignView.height)];
        _verticalLine.backgroundColor = [UIColor grayColor];
    }
    return _verticalLine;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [self createLabel];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [self createLabel];
    }
    return _rightLabel;
}

- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [self createLabel];
    }
    return _topLabel;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [self createLabel];
    }
    return _bottomLabel;
}

@end
