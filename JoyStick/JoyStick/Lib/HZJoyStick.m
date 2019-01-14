//
//  HZJoyStick.m
//  JoyStick
//
//  Created by ZenonHuang on 2019/1/14.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "HZJoyStick.h"

@interface HZJoyStick ()
@property (nonatomic, strong) UIImageView *stickBgView;
@property (nonatomic, strong) UIImageView *stickView;
@property (nonatomic, strong) CADisplayLink *displaylinkTimer;
@end

@implementation HZJoyStick

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initView:frame];
    }
    return self;
}

- (void)initView:(CGRect)frame
{
    self.stickBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:self.stickBgView];
    [self.stickBgView.layer setMasksToBounds:YES];
    [self.stickBgView.layer setCornerRadius:frame.size.width/2];
    
    self.stickView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/4, frame.size.height/4, frame.size.width/2, frame.size.height/2)];
    [self addSubview:self.stickView];
    
//    self.stickView.image = [UIImage imageNamed];
    self.stickView.backgroundColor = [UIColor grayColor];
    self.stickBgView.backgroundColor = [UIColor orangeColor];
    
}

#pragma mark - CADisplayLink

- (void)setupDisplayLink
{
    if (!self.displaylinkTimer) {
        self.displaylinkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        
        [self.displaylinkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

-(void)handleDisplayLink:(CADisplayLink *)displaylinkTimer
{
    if (!self.inMove) {
        
        return;
    }
    if (@available(iOS 10.0, *)) {
        NSLog(@"%s-----%ld",__func__,displaylinkTimer.preferredFramesPerSecond);
    }

    CGPoint centerPoint = self.stickView.center ;
    
    if ([self.moveDelegate respondsToSelector:@selector(hz_joyStickDidMoveOffsetX:offsetY:)]) {
        [self.moveDelegate hz_joyStickDidMoveOffsetX:centerPoint.x offsetY:centerPoint.y];
    }
}

- (void)removeDisplayLink
{
    //销毁定时器
    [self.displaylinkTimer invalidate];
    self.displaylinkTimer = nil;
}

#pragma mark - private
- (void)callinelength:(CGPoint)point
{
    CGFloat centrex = self.frame.size.width/2;          //圆心X
    CGFloat centrey = self.frame.size.height/2;         //圆心Y
    CGFloat radius = self.frame.size.width/2;           //半径
    CGFloat x;              //坐标系X
    CGFloat y;              //坐标系Y
    
    x = point.x - centrex;
    y = centrey - point.y;
    //NSLog(@"x = %f   y = %f",x, y);
    
    float current_radius =  sqrtf(x*x + y*y);           //计算改点到圆心的距离
    if(current_radius > radius)
    {
        //NSLog(@"不在圆内");
        float circlex = fabs(x) / current_radius * radius;
        float circley = fabs(y) / current_radius * radius;
        if(x < 0 && y > 0)
        {
            x = centrex - circlex;
            y = centrey - circley;
        }
        else if(x > 0 && y > 0)
        {
            x = centrex + circlex;
            y = centrey - circley;
        }
        else if(x < 0 && y < 0)
        {
            x = centrex - circlex;
            y = centrey + circley;
        }
        else if (x > 0 && y < 0)
        {
            x = centrex + circlex;
            y = centrey + circley;
        }
        self.stickView.center = CGPointMake(x, y);
    }
    else
    {
        //NSLog(@"在圆内");
        self.stickView.center = CGPointMake(point.x, point.y);
        
    }
    

    if (!self.inMove) {
        self.inMove = YES;
        [self setupDisplayLink];
    }
    
//cadisplaylink 已经调用代理    if ([self.moveDelegate respondsToSelector:@selector(hz_joyStickDidMoveOffsetX:offsetY:)]) {
//        [self.moveDelegate hz_joyStickDidMoveOffsetX:x offsetY:y];
//    }
}

#pragma mark - override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint pointBegan = [touch locationInView:self];
    [self callinelength:pointBegan];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint pointBegan = [touch locationInView:self];
    [self callinelength:pointBegan];
}

//结束复位
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.stickView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.inMove = NO;
    [self removeDisplayLink];
}

@end
