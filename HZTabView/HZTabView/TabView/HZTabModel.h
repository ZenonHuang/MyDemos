//
//  HZTabModel.h
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZTabModel : NSObject
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,assign) BOOL   selected;

- (CGFloat)textWidth:(UIFont *)textFont;
@end
