//
//  HZTabView.h
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZTabModel.h"

@class HZTabView;

@protocol HZTabViewDelegate <NSObject>

- (void)hz_tabView:(HZTabView *)tabView didSelected:(NSInteger)index;

@end

@interface HZTabView : UIView
@property (nonatomic,weak)  id<HZTabViewDelegate> delegate;
@property (nonatomic,copy)   NSArray<HZTabModel *> *titleList;
@property (nonatomic,strong) UIColor  *selectedTextColor;
@property (nonatomic,strong) UIColor  *normalTextColor;

@property (nonatomic,strong) UIColor  *lineColor;
@property (nonatomic,assign) CGFloat  lineHeight;

@property (nonatomic,assign) NSInteger currentSelectedIndex;

- (void)reloadData;
@end

