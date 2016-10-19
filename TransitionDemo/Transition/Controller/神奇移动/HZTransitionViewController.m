//
//  HZTransitionViewController.m
//  Transition
//
//  Created by zzgo on 16/5/26.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "HZSecondViewController.h"
#import "HZTransitionFromFirstToSecond.h"
#import "HZTransitionFromSecondToFirst.h"
#import "HZTransitionViewController.h"
#import "HZUIKit.h"
#import <Foundation/Foundation.h>
static NSString *const kQQSecondViewController = @"kQQSecondViewController";

@interface HZTransitionViewController ()
//@property (nonatomic, readwrite, strong) UIImageView *fisrtImageView;
@property (nonatomic, readwrite, strong) UIImage *transImage;
@property (nonatomic, readwrite, strong) UIImageView *transImageView;
@end

@implementation HZTransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.fisrtImageView];
    [self.view addSubview:self.secondImageView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.fisrtImageView.frame = CGRectMake(100, 100, 60, 60);
    self.secondImageView.frame = CGRectMake(100, 200, 60, 60);
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    HZTransitionFromFirstToSecond *toSec = [[HZTransitionFromFirstToSecond alloc] init];
    toSec.transImage = self.transImage;
    toSec.testImageView = self.transImageView;
    return toSec;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    HZTransitionFromSecondToFirst *toFirst = [[HZTransitionFromSecondToFirst alloc] init];
    toFirst.testImageView = self.transImageView;
    return toFirst;
}

- (void)touchFirstImageView
{
    NSLog(@"touch");
    // UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.transImage = self.fisrtImageView.image;
    self.transImageView = self.fisrtImageView;
    HZSecondViewController *sec = [HZSecondViewController new];
    sec.transitioningDelegate = self;
    [self presentViewController:sec animated:YES completion:nil];
}
- (void)touchSeconImageView:(UIImageView *)imageView
{
    NSLog(@"touch");
    // UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.transImage = self.secondImageView.image;
    self.transImageView = self.secondImageView;
    HZSecondViewController *sec = [HZSecondViewController new];
    sec.transitioningDelegate = self;
    [self presentViewController:sec animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImageView *)fisrtImageView
{
    if (!_fisrtImageView) {
        _fisrtImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mojiezuo.jpg"]];
        [_fisrtImageView hz_addTarget:self touchAction:@selector(touchFirstImageView)];
        _fisrtImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _fisrtImageView;
}
- (UIImageView *)secondImageView
{
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wuyanzu.jpg"]];
        _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_secondImageView hz_addTarget:self touchAction:@selector(touchSeconImageView:)];
    }
    return _secondImageView;
}
@end
