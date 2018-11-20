//
//  HZTabCollectionCell.h
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZTabModel.h"

@class HZTabCollectionCell;

@protocol HZTabCollectionCellDataSource <NSObject>

- (UIColor *)hz_tabCellNormalTextColor;

- (UIColor *)hz_tabCellSelectedTextColor;

@end

@interface HZTabCollectionCell : UICollectionViewCell
@property (nonatomic,weak)  id<HZTabCollectionCellDataSource> dataSource;
@property (nonatomic,strong) HZTabModel *model;
@end
