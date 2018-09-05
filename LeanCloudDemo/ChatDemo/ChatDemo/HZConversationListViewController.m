//
//  Created by zzgo on 16/8/22.
// 	Contact by zzgoCC@gmail.com
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "HZConversationListViewController.h"

@interface HZConversationListViewController ()

@end

@implementation HZConversationListViewController

#pragma mark - Intial Methods

#pragma mark - Override/Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    firstViewController.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    self.tableView.tableHeaderView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, 0, 100);
        view.backgroundColor = [UIColor redColor];
        view;
    });
}
#pragma mark - Notification

#pragma mark - KVO

#pragma mark - target-action/IBActions

#pragma mark - delegate dataSource protocol

#pragma mark - public

#pragma mark - private

#pragma mark - getter / setter

@end
