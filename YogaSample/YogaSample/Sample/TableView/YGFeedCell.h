//
// YGFeedView.h
//  YogaSample
//
//  Created by mewe on 2018/1/2.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGFeedEntity.h"


@interface YGFeedView : UIView
- (instancetype)initWithData:(YGFeedEntity *)entity;
@end

@interface YGFeedCell : UITableViewCell
- (void)configureData:(YGFeedEntity *)entity;
@end
