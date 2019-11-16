//
//  ViewController.m
//  FanButton
//
//  Created by ZenonHuang on 2019/11/16.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "ViewController.h"
#import "SubButton/HZSubFanButton.h"

@interface ViewController ()
@property (nonatomic,strong) HZSubFanButton *subButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.subButton = [[HZSubFanButton alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    self.subButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.subButton];
}


@end
