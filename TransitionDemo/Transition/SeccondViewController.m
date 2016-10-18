//
//  SeccondViewController.m
//  Transition
//
//  Created by 臧其龙 on 16/5/25.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "SeccondViewController.h"
#import "PopTransiton.h"

@interface SeccondViewController ()<UINavigationControllerDelegate>
{
    UIScreenEdgePanGestureRecognizer *pan;
    
    UIPercentDrivenInteractiveTransition *interaction;
}

@end

@implementation SeccondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlEdgeScreenPanGesture:)];
    pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return [[PopTransiton alloc] init];
    }
    return nil;
}


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return interaction;
}

- (void)handlEdgeScreenPanGesture:(UIScreenEdgePanGestureRecognizer *)sender
{
    NSLog(@"x position is %f",[sender translationInView:self.view].x);
    CGFloat progress = ([sender translationInView:self.view].x)/CGRectGetWidth(self.view.frame);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            interaction = [[UIPercentDrivenInteractiveTransition alloc] init];
            // [self.navigationController pushViewController:@"xxx" animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
