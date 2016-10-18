//
//  TransitionFromFirstToSecond.m
//  CustomTransitionAnimation
//
//  Created by 臧其龙 on 15/2/21.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import "HZTransitionFromFirstToSecond.h"

#import "HZSecondViewController.h"
#import "HZTransitionViewController.h"

@implementation HZTransitionFromFirstToSecond

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UINavigationController *nav = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HZTransitionViewController *fromViewController = (HZTransitionViewController *)nav.topViewController;
    HZSecondViewController *toViewController = (HZSecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    //hz
    UIImageView *from_fisrtImageView = self.testImageView; //fromViewController.fisrtImageView;

    UIView *cellImageSnapshot = [from_fisrtImageView snapshotViewAfterScreenUpdates:YES];

    //    cellImageSnapshot.frame = fromViewController.imageView.frame;
    //    [containerView addSubview:cellImageSnapshot];

    //使用convert，获得相对整个view的frame，避免嵌套View时frame不准的情况
    cellImageSnapshot.frame = [containerView convertRect:from_fisrtImageView.frame fromView:fromViewController.view];
    from_fisrtImageView.hidden = YES;

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.secondImageview.hidden = YES;
    toViewController.secondImageview.image = self.transImage;
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
          from_fisrtImageView.hidden = NO;
          [cellImageSnapshot removeFromSuperview];

          [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
}
@end
