//
//  PushTransition.h
//  Transition
//
//  Created by 臧其龙 on 16/5/25.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PushTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) id transitionContext;

@end
