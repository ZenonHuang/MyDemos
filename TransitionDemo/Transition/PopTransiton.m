//
//  PopTransiton.m
//  Transition
//
//  Created by 臧其龙 on 16/5/25.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "PopTransiton.h"

@implementation PopTransiton

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    _transitionContext = transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [fromViewController.view.layer removeAllAnimations];
    _fromViewcontroller = fromViewController;
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    fromViewController.view.layer.transform = transform;
    fromViewController.view.layer.anchorPoint = CGPointMake(1, 0.5);
    fromViewController.view.layer.position = CGPointMake(CGRectGetMaxX(toViewController.view.frame), CGRectGetMidY(toViewController.view.frame));
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.duration = [self transitionDuration:transitionContext];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI_2);
    animation.delegate = self;
    [fromViewController.view.layer addAnimation:animation forKey:@"rotateAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        
       // [_fromViewcontroller.view removeFromSuperview];
        [_transitionContext finishInteractiveTransition];
        [_transitionContext completeTransition:YES];
    }
}

@end
