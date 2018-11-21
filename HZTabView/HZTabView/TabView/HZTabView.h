//
//  HZTabView.h
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZTabModel.h"

typedef NS_ENUM(NSInteger, HZTabViewLineStyle) {
    HZTabViewLineStyleDefault = 0,
    HZTabViewLineStyleBackground
};

typedef NS_ENUM(NSInteger, HZTabViewWidthStyle) {
    HZTabViewWidthStyleDefault = 0,//根据屏宽等分 单个w = sWidth/num
    HZTabViewWidthStyleAdapter//自适应，不限宽度
};

@class HZTabView;

@protocol HZTabViewDelegate <NSObject>

- (void)hz_tabView:(HZTabView *)tabView didSelected:(NSInteger)index;

@end

@interface HZTabView : UIView
@property (nonatomic,weak)  id<HZTabViewDelegate> delegate;
@property (nonatomic,copy)   NSArray<HZTabModel *> *titleList;
@property (nonatomic,strong) UIColor  *selectedTextColor;
@property (nonatomic,strong) UIColor  *normalTextColor;
@property (nonatomic,strong) UIFont   *titleFont;
@property (nonatomic,strong) UIFont   *titleSelectedFont;

@property (nonatomic,assign) HZTabViewWidthStyle widthStyle;
@property (nonatomic,assign) CGFloat  cellWidthIncrement;    //cell宽度补偿。默认：0
@property (nonatomic,assign) CGFloat  cellSpacing;    //cell之间的间距，默认0

@property (nonatomic,assign) NSInteger currentSelectedIndex;

@property (nonatomic,assign) HZTabViewLineStyle lineStyle;
@property (nonatomic,strong) UIColor  *lineColor;
@property (nonatomic,assign) CGFloat  lineHeight;



- (void)reloadData;
@end

