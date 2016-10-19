//
//  HZSecondViewController.m
//  Transition
//
//  Created by zzgo on 16/5/26.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "HZSecondViewController.h"
#import "HZUIKit.h"
@interface HZSecondViewController ()

@end

@implementation HZSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.secondImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mojiezuo.jpg"]];
    self.secondImageview.frame = CGRectMake(0, 0, 200, 200);
    self.secondImageview.center = self.view.center;
    self.secondImageview.layer.masksToBounds = YES;
    self.secondImageview.layer.cornerRadius = 100;
    self.secondImageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.secondImageview hz_addTarget:self touchAction:@selector(dismissFirst)];
    [self.view addSubview:_secondImageview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissFirst
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
