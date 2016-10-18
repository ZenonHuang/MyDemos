//
//  ViewController.h
//  QQMusicTransition
//
//  Created by zangqilong on 15/3/23.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQViewController : UIViewController<UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

