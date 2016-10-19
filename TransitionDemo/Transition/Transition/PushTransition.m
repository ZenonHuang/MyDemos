//
//  PushTransition.m
//  Transition
//
//  Created by 臧其龙 on 16/5/25.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "PushTransition.h"

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{_transitionContext = transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    toViewController.view.layer.transform = transform;
    toViewController.view.layer.anchorPoint = CGPointMake(1, 0.5);
    toViewController.view.layer.position = CGPointMake(CGRectGetMaxX(fromViewController.view.frame), CGRectGetMidY(toViewController.view.frame));
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.duration = [self transitionDuration:transitionContext];
    animation.fromValue = @(M_PI_2);
    animation.toValue = @(0);
    animation.delegate = self;
    [toViewController.view.layer addAnimation:animation forKey:@"rotateAnimation"];
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [_transitionContext finishInteractiveTransition];
        [_transitionContext completeTransition:YES];
    }
}

@end
