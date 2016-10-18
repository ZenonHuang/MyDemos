//
//  SecondViewController.m
//  QQMusicTransition
//
//  Created by zangqilong on 15/3/23.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import "QQSecondViewController.h"

@interface QQSecondViewController ()

@end

@implementation QQSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.secondImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mojiezuo.jpg"]];
    self.secondImageview.frame = CGRectMake(0, 0, 200, 200);
    self.secondImageview.center = self.view.center;
    self.secondImageview.layer.masksToBounds = YES;
    self.secondImageview.layer.cornerRadius = 100;
    self.secondImageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_secondImageview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissFirst:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
