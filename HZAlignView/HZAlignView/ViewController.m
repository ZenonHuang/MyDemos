//
//  ViewController.m
//  HZAlignView
//
//  Created by ZenonHuang on 2019/4/11.
//  Copyright © 2019年 zenon. All rights reserved.
//

#import "ViewController.h"
#import "HZAlignViewPlugin.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *alignView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.alignView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.alignView addGestureRecognizer:pan];
    
}

#pragma mark - action
- (void)pan:(UIPanGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{//开始拖动
            [[HZAlignViewPlugin shareInstance] showAlignLineFor:self.alignView];
            NSLog(@"开始拖动");
            break;
        }
        case UIGestureRecognizerStateChanged:{//拖动中
            //1、获得拖动位移
            CGPoint offsetPoint = [sender translationInView:sender.view];
            //2、清空拖动位移
            [sender setTranslation:CGPointZero inView:sender.view];
            //3、重新设置控件位置
            UIView *panView = sender.view;
            CGFloat newX = panView.centerX+offsetPoint.x;
            CGFloat newY = panView.centerY+offsetPoint.y;
            
            CGPoint centerPoint = CGPointMake(newX, newY);
            panView.center = centerPoint;
            
            
            [[HZAlignViewPlugin shareInstance] changePostion];
             NSLog(@"拖动中");
            break;
        }
        case UIGestureRecognizerStateEnded://拖动结束
        case UIGestureRecognizerStateCancelled:
        {
            [[HZAlignViewPlugin shareInstance] hiddenAlignLine];
             NSLog(@"拖动结束");
            break;
        }
        default:
            break;
    }
    
}

@end
