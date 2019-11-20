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

    
    CGRect rect = CGRectMake(100, 200, 200, 200);
    
    HZCenterFanButton *centerButton = [[HZCenterFanButton alloc] init];
    centerButton.frame = rect;
    centerButton.userInteractionEnabled = YES;
    
    centerButton.textList = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    
    [self.view addSubview:centerButton];
    
    

    
}

- (void)clickBtnWithIndex:(NSInteger)index
{
    NSLog(@"%li",index);
}

@end
