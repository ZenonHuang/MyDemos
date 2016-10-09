//
//  ViewController.m
//  MobSMSDemo
//
//  Created by zzgo on 16/10/9.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import "ViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (nonatomic, readwrite, strong) NSString *phoneNumber;
@property (nonatomic, readwrite, strong) NSString *areaCode;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.phoneNumber = @"18673556610";
    self.areaCode = @"86";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchCodeBtn:(id)sender
{

    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.phoneNumber
                                   zone:self.areaCode
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                   if (!error) {
                                       NSLog(@"获取验证码成功");
                                   }
                                   else {
                                       NSLog(@"错误信息：%@", error);
                                   }
                                 }];
}
- (IBAction)validCodeBtn:(id)sender
{
    [SMSSDK commitVerificationCode:self.verifyCodeField.text
                       phoneNumber:self.phoneNumber
                              zone:self.areaCode
                            result:^(NSError *error) {

                              if (!error) {

                                  NSLog(@"验证成功");
                              }
                              else {
                                  NSLog(@"错误信息：%@", error);
                              }
                            }];
}

@end
