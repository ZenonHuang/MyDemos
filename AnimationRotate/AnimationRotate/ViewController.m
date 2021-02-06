//
//  ViewController.m
//  AnimationRotate
//
//  Created by zz go on 2020/9/18.
//  Copyright © 2020 ZenonHuang. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@property (nonatomic,strong) UIView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.animationView.frame = CGRectMake(-200, 80, 200, 40);
//    self.animationView.center = self.view.center;
    [self.view addSubview:self.animationView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self handleAnimation];
    });
}

- (void)handleAnimation
{
    CGRect rect=self.animationView.frame;
    rect.origin.x=0;
    [UIView animateWithDuration:1 animations:^{
        self.animationView.frame=rect;
    }];
    
    [self shakeToShow:self.animationView];
    [self shakeScale:self.animationView];
     
    [self animationOnShowGiftView:self.animationView];//展示动画
}

//展示礼物页面从左边到右边的动画
- (void) animationOnShowGiftView:(UIView *) giftShowView{   
    [UIView animateWithDuration:3 animations:^{
        CGRect rect=giftShowView.frame;
        rect.origin.x=60;
        giftShowView.layer.opacity=1;
    }];
}

//晃动
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 2;
    animation.removedOnCompletion=YES;
    
    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(5.0, 5.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];

    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//放大缩小
- (void) shakeScale:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 3;
    animation.removedOnCompletion=YES;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (UIView *)animationView
{
    if (!_animationView) {
        _animationView = [UIView new];
        _animationView.backgroundColor = [UIColor orangeColor];
    }
    return _animationView;
}

@end
