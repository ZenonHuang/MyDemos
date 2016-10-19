//
//  TransitionFromSecondToFirst.m
//  CustomTransitionAnimation
//
//  Created by 臧其龙 on 15/2/21.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import "TransitionFromSecondToFirst.h"
#import "QQViewController.h"
#import "QQSecondViewController.h"

@implementation TransitionFromSecondToFirst

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UINavigationController *nav = (UINavigationController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    QQViewController *toViewController = (QQViewController *)nav.topViewController;
    QQSecondViewController *fromViewController = (QQSecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    UIView *cellImageSnapshot = [fromViewController.secondImageview snapshotViewAfterScreenUpdates:YES];
    
    cellImageSnapshot.frame = [containerView convertRect:fromViewController.secondImageview.frame fromView:fromViewController.view];
    fromViewController.secondImageview.hidden = YES;
    
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.imageView.hidden = YES;
    
    [containerView addSubview:nav.view];
    [containerView addSubview:cellImageSnapshot];
    
  
    
    [UIView animateWithDuration:duration animations:^{
        
        toViewController.view.alpha = 1.0;
        
        
        CGRect frame = [containerView convertRect:toViewController.imageView.frame fromView:toViewController.containerView];
        
        cellImageSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        
        toViewController.imageView.hidden = NO;
        fromViewController.secondImageview.hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}


@end
