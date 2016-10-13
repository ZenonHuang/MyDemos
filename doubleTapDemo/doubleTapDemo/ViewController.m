//
//  ViewController.m
//  doubleTapDemo
//
//  Created by zz go on 2016/10/14.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong ,nonatomic) UITabBarItem *lastSeletedItem;
@property (assign,nonatomic) NSInteger tapCount;

@property (assign,nonatomic) UInt64 lastTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tabBar.delegate=self;
    self.tapCount=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.tapCount++;

    //判断双击
    if (self.lastSeletedItem==item&&self.tapCount%2==0) {
        //根据时间，判断双击间隔
        if (self.currentTime-self.lastTime<=500) {
            NSLog(@"tap");
        }
        //一次双击后，重新计数
        self.tapCount=0;
    }
   
    self.lastSeletedItem=item;
    self.lastTime=self.currentTime;
}

#pragma mark - setter/getter
-(UInt64)currentTime{
   //毫秒为单位的时间戳
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return recordTime;
}


@end
