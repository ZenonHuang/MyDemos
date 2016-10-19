//
//  HZTransitionViewController.h
//  Transition
//
//  Created by zzgo on 16/5/26.
//  Copyright © 2016年 臧其龙. All rights reserved.
//
//#import "QQViewController.h"
#import <UIKit/UIKit.h>
@interface HZTransitionViewController : UIViewController <UIViewControllerTransitioningDelegate>
@property (nonatomic, readwrite, strong) UIImageView *fisrtImageView;
@property (nonatomic, readwrite, strong) UIImageView *secondImageView;
@end
