//
//  ViewController.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "ViewController.h"
#import "SubButton/HZCenterFanButton.h"

@interface ViewController ()<HZCenterFanButtonDelegate>
@property (nonatomic,strong) HZCenterFanButton *centerButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = [self rectForCenterButton];
    
    HZCenterFanButton *centerButton = [[HZCenterFanButton alloc] init];
    centerButton.frame = rect;
    centerButton.userInteractionEnabled = YES;
    centerButton.delegate = self;
    centerButton.textList = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    centerButton.title = @"yy";
    
    [self.view addSubview:centerButton];
    
    self.centerButton= centerButton;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.centerButton.frame = [self rectForCenterButton];
}

- (CGRect)rectForCenterButton
{
    CGFloat length = 200;
    CGSize  screenSize = [UIScreen mainScreen].bounds.size;
    return  CGRectMake( (screenSize.width-length)/2,(screenSize.height-length)/2, length, length );
}

#pragma mark - delegate

- (void)clickBtnWithIndex:(NSInteger)index
{
    NSLog(@"%li",index);
}

@end
