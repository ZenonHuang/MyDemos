//
//  ViewController.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "ViewController.h"
#import "SubButton/HZSubFanButton.h"
#import "SubButton/HZCenterFanButton.h"

@interface ViewController ()
@property (nonatomic,strong) HZSubFanButton *subButton;
@property (nonatomic,strong) HZSubFanButton *twoButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    CGRect rect = CGRectMake(200, 200, 100, 100);
    
    HZCenterFanButton *centerButton = [[HZCenterFanButton alloc] init];
    centerButton.frame = rect;
    centerButton.userInteractionEnabled = YES;
    [self.view addSubview:centerButton];
    
    
    self.subButton = [HZSubFanButton buttonWithAngle:M_PI*1.2
                                            endAngle:M_PI*1.8 ];
//    self.subButton.backgroundColor = [UIColor redColor];
    self.subButton.frame = CGRectMake(0, 0, 100, 100);
    self.subButton.tag = 100;
    [centerButton addSubview:self.subButton];
    
    
    HZSubFanButton *button = [HZSubFanButton buttonWithAngle:M_PI*1.8 endAngle:M_PI*2.4];
//    button.backgroundColor = [UIColor blueColor];
    button.frame =CGRectMake(0, 0, 100, 100);
    [centerButton addSubview:button];
    button.tag = 200;
    self.twoButton = button;
 
}

- (void)clickBtnWithIndex:(NSInteger)index
{
    NSLog(@"%li",index);
}


@end
