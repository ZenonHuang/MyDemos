//
//  YGSampleView.h
//  YogaSample
//
//  Created by mewe on 2017/12/25.
//  Copyright © 2017年 zenonhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,  YGSampleType) {
    YGSampleTypeCenter,//居中
    YGSampleTypeNested,//嵌套
    YGSampleTypeSpaceBetween,//固定大小，等间距
    YGSampleTypeSpace,//等间距，自动设宽
    YGSampleTypeScrollView,
    YGSampleTypeCenterAnimation,//居中缩小动画
};

@interface YGSampleView : UIView
- (instancetype)initWithType:(YGSampleType)type;
@end
