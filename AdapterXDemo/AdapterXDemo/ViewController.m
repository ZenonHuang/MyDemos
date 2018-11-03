//
//  ViewController.m
//  AdapterXDemo
//
//  Created by ZenonHuang on 2018/11/3.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import "ViewController.h"
#import "UIDevice+KWS.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //存在问题，iphone8Plus   @"iPhone10,2"/ @"iPhone10,5"
    //        iphoneX  @"iPhone10,3"/@"iPhone10,6"
    if([[UIDevice currentDevice] isIPhoneXOrHigher]){
       NSLog(@" X 以上  ");
    }else{
         NSLog(@" 8Plus 以下  ");
    }
    
    [self isSafeArea];
}

- (void)isSafeArea{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue>11.0) {
        if (self.view.safeAreaInsets.bottom > 0 ||
            self.view.safeAreaInsets.left   >0) {
            NSLog(@"刘海屏");
        }else{
            NSLog(@"不是刘海屏");
        }
        
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self isSafeArea];
}
@end
