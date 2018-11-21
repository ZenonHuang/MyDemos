//
//  HZTabCollectionView.m
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/21.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import "HZTabCollectionView.h"

@interface HZTabCollectionView ()

@end

@implementation HZTabCollectionView

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.lineView) {
        [self sendSubviewToBack:self.lineView];
    }

}

@end
