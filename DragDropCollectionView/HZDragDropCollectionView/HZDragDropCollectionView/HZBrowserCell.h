//
//  HZBrowserCell.h
//  gosparkchat
//
//  Created by zz go on 2017/1/21.
//  Copyright © 2017年 gospark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HZBrowserHandler) (NSString *desc);

@interface HZBrowserCell : UICollectionViewCell
@property (nonatomic,readonly,copy) HZBrowserHandler cellHandler;

- (void)setCellHandler:(HZBrowserHandler)cellHandler;
- (void)setupImageUrl:(NSString *)urlString;
- (void)showDelete:(BOOL)isShow;
@end
