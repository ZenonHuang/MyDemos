//
//  ViewController.m
//  Transition
//
//  Created by 臧其龙 on 16/5/25.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "ViewController.h"
#import "PushTransition.h"
#import "PushTransitionTest.h"

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

@interface ViewController ()<UINavigationControllerDelegate>
{
    UIScreenEdgePanGestureRecognizer *pan;
    
    UIPercentDrivenInteractiveTransition *interaction;
    
    UIView *redView;
}
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    
    // 假如你得动画总时长是5秒钟，那么当你的手指从640 -》 0这个过程的时候
    // 每移动一个pixel的位置，你的动画就执行了5.0/640秒的时间
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationController.delegate = self;
    pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlEdgeScreenPanGesture:)];
    pan.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:pan];
    
    redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.anchorPoint = CGPointMake(1, 0.5);
    [self.view addSubview:redView];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/2000.0;
    redView.layer.transform = transform;
    
    
    
// Do any additional setup after loading the view, typically from a nib.
}

- (void)handlEdgeScreenPanGesture:(UIScreenEdgePanGestureRecognizer *)sender
{
    NSLog(@"x position is %f",[sender translationInView:self.view].x);
    CGFloat progress = (-1 * [sender translationInView:self.view].x)/CGRectGetWidth(self.view.frame);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            interaction = [[UIPercentDrivenInteractiveTransition alloc] init];
           // [self.navigationController pushViewController:@"xxx" animated:YES];
            [self performSegueWithIdentifier:@"kPushToSecond" sender:nil];
            break;
        case UIGestureRecognizerStateChanged:
            [interaction updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress >= 0.5) {
                [interaction finishInteractiveTransition];
            }else {
                [interaction cancelInteractiveTransition];
                //[self.navigationController popViewControllerAnimated:YES];
            }
            interaction = nil;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToSecond:(id)sender
{
    [self performSegueWithIdentifier:@"kPushToSecond" sender:nil];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//    animation.duration = 0.7;
//    animation.fromValue = @(DEGREES_TO_RADIANS(180));
//    animation.toValue = @(0);
//    [redView.layer addAnimation:animation forKey:@"rotateAnimation"];
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [[PushTransitionTest alloc] init];
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return interaction;
}

@end
