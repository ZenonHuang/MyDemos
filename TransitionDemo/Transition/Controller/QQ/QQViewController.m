//
//  ViewController.m
//  QQMusicTransition
//
//  Created by zangqilong on 15/3/23.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import "QQViewController.h"
#import "QQSecondViewController.h"
#import "TransitionFromSecondToFirst.h"
#import "TransitionFromFirstToSecond.h"

static NSString * const kQQSecondViewController = @"kQQSecondViewController";

@interface QQViewController ()

@end

@implementation QQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[TransitionFromFirstToSecond alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[TransitionFromSecondToFirst alloc] init];
}

- (IBAction)presentSecond:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QQSecondViewController *sec = [story instantiateViewControllerWithIdentifier:kQQSecondViewController];
    sec.transitioningDelegate = self;
    [self presentViewController:sec animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
