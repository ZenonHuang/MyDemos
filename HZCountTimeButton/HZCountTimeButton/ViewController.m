//
//  ViewController.m
//  HZCountTimeButton
//
//  Created by ZenonHuang on 2019/1/30.
//  Copyright © 2019年 zenon. All rights reserved.
//

#import "ViewController.h"
#import "HZCountDownButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HZCountDownButton *countDownButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.countDownButton.normalTitle = @"获取验证码";
    self.countDownButton.normalTitleColor = [UIColor blackColor];
    self.countDownButton.waitTitle = @"发送成功";
    self.countDownButton.waitTitleColor = [UIColor grayColor];
}


@end
