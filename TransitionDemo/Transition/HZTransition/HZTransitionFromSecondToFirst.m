//
//  TransitionFromSecondToFirst.m
//  CustomTransitionAnimation
//
//  Created by 臧其龙 on 15/2/21.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import "HZSecondViewController.h"
#import "HZTransitionFromSecondToFirst.h"
#import "HZTransitionViewController.h"

@implementation HZTransitionFromSecondToFirst

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UINavigationController *nav = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    HZTransitionViewController *toViewController = (HZTransitionViewController *)nav.topViewController;
    HZSecondViewController *fromViewController = (HZSecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    UIView *cellImageSnapshot = [fromViewController.secondImageview snapshotViewAfterScreenUpdates:YES];

    cellImageSnapshot.frame = [containerView convertRect:fromViewController.secondImageview.frame fromView:fromViewController.view];
    fromViewController.secondImageview.hidden = YES;
    //    fromViewController.secondImageview.image = self.transImage;

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;

    UIImageView *to_fisrtImageView = self.testImageView; //toViewController.fisrtImageView;
    to_fisrtImageView.hidden = YES;

    [containerView addSubview:nav.view];
    [containerView addSubview:cellImageSnapshot];

    [UIView animateWithDuration:duration animations:^{

      toViewController.view.alpha = 1.0;

      CGRect frame = [containerView convertRect:to_fisrtImageView.frame fromView:toViewController.view];

      cellImageSnapshot.frame = frame;
    }
        completion:^(BOOL finished) {

          to_fisrtImageView.hidden = NO;
          fromViewController.secondImageview.hidden = NO;
          [cellImageSnapshot removeFromSuperview];

          [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
}

@end
