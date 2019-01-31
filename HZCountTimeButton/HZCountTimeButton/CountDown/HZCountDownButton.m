//
//  HZCountDownButton.m
//  HZCountTimeButton
//
//  Created by ZenonHuang on 2019/1/30.
//  Copyright © 2019年 zenon. All rights reserved.
//

#import "HZCountDownButton.h"

@interface HZCountDownButton ()
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,strong) NSDate        *destinaDate;
@property (nonatomic,assign) NSInteger     currentTime;
@end

@implementation HZCountDownButton

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setUp];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    [self addTarget:self
             action:@selector(tapButton)
   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action
- (void)tapButton
{
#warning todo your network service callback
    BOOL result = YES;
    if (!result) {
        NSLog( @"发送失败");
        return;
    }
    
    
    self.enabled = NO;
    [self beganCount];
    NSLog(@"发送成功");
    
}

- (void)beganCount
{
    [self displayLink];
    if (self.countSeconds==0) {
        self.countSeconds = 60;
    }
    self.destinaDate = [NSDate dateWithTimeIntervalSinceNow:self.countSeconds];
    
}

- (void)pasuseCount
{
    [self.displayLink setPaused:YES];
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.destinaDate = nil;
    
    self.enabled = YES;
    [self updateWaiteTitle:self.waitTitle];
}

- (void)updateValue:(NSTimer *)timer {
    NSTimeInterval  interval = [self.destinaDate timeIntervalSinceNow];
    if (interval<self.countSeconds) {
        NSLog(@" 距离目标秒数: %@ ",@(interval));
        
        NSInteger seconds = (NSInteger)interval;
        [self updateWaiteTitle:[NSString stringWithFormat:@"%@(%@)",self.waitTitle,@(seconds)]];
        
        if (interval<=0) {
            [self pasuseCount];
        }
    }
}

- (void)updateWaiteTitle:(NSString *)text
{
    [self setTitle:text forState:UIControlStateDisabled];
}

#pragma mark - setter
- (void)setNormalTitle:(NSString *)normalTitle
{
    _normalTitle = normalTitle;
    [self setTitle:normalTitle forState:UIControlStateNormal];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    _normalTitleColor = normalTitleColor;
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setWaitTitle:(NSString *)waitTitle
{
    _waitTitle = waitTitle;
    [self updateWaiteTitle:waitTitle];
}

- (void)setWaitTitleColor:(UIColor *)waitTitleColor
{
    _waitTitleColor = waitTitleColor;
    [self setTitleColor:waitTitleColor forState:UIControlStateDisabled];
}

#pragma mark - getter
- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink =   [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
        if (@available(iOS 10.0, *)){
            _displayLink.preferredFramesPerSecond = 30; //控制刷新频率，每秒调用次数 = 60/frameInterval
        }else{
             _displayLink.frameInterval = 30; //控制刷新频率，每秒调用次数 = 60/frameInterval
        }
       
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    }
    return _displayLink;
}
@end
