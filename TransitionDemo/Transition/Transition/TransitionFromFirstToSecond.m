//
//  TransitionFromFirstToSecond.m
//  CustomTransitionAnimation
//
//  Created by 臧其龙 on 15/2/21.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import "TransitionFromFirstToSecond.h"

#import "QQSecondViewController.h"
#import "QQViewController.h"

@implementation TransitionFromFirstToSecond

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UINavigationController *nav = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    QQViewController *fromViewController = (QQViewController *)nav.topViewController;
    QQSecondViewController *toViewController = (QQSecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    UIView *cellImageSnapshot = [fromViewController.imageView snapshotViewAfterScreenUpdates:YES];

    //    cellImageSnapshot.frame = fromViewController.imageView.frame;
    //    [containerView addSubview:cellImageSnapshot];

    cellImageSnapshot.frame = [containerView convertRect:fromViewController.imageView.frame fromView:fromViewController.containerView];
    fromViewController.imageView.hidden = YES;

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.secondImageview.hidden = YES;

    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];

    [UIView animateWithDuration:duration animations:^{

      toViewController.view.alpha = 1.0;

      CGRect frame = [containerView convertRect:toViewController.secondImageview.frame fromView:toViewController.view];
      NSLog(@"frame is %@", NSStringFromCGRect(toViewController.secondImageview.frame));
      cellImageSnapshot.frame = frame;
    }
        completion:^(BOOL finished) {

          toViewController.secondImageview.hidden = NO;
          fromViewController.imageView.hidden = NO;
          [cellImageSnapshot removeFromSuperview];

          [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
}
@end
