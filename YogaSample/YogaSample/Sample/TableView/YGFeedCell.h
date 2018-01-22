//
// YGFeedView.h
//  YogaSample
//
//  Created by mewe on 2018/1/2.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGFeedEntity.h"

@interface YGFeedCell : UITableViewCell
- (void)configureData:(YGFeedEntity *)entity;
@end

@interface UITableView (TemplateCell)
- (CGFloat)heightForData:(YGFeedEntity *)entity cellIdentifier:(NSString *)identifier;
@end
