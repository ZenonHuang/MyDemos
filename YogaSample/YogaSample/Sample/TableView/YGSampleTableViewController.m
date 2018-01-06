//
//  YGSampleTableViewController.m
//  YogaSample
//
//  Created by mewe on 2018/1/2.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import "YGSampleTableViewController.h"
#import "YGFeedCell.h"
#import "UIView+Yoga.h"

static NSString *kCellIdentifier = @"yg_kCellIdentifier";

@interface YGSampleTableViewController ()
@property (nonatomic,copy) NSArray *dataList;

@property (nonatomic,strong) NSMutableArray *feedViewList;
@property (nonatomic,strong) NSMutableArray *heightList;
@end

@implementation YGSampleTableViewController

#pragma mark - life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerClass:[YGFeedCell class]
           forCellReuseIdentifier:kCellIdentifier];
    
    [self preLoadFeedView];
      
    self.tableView.estimatedRowHeight = 0;

    [self.tableView reloadData];
}


#pragma mark - private
- (void)preLoadFeedView{
    // Data from `data.json`
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *feedDicts = rootDict[@"feed"];
    
    // Convert to `Entity`
    NSMutableArray *entities = @[].mutableCopy;
    [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [entities addObject:[[YGFeedEntity alloc] initWithDictionary:obj]];
    }];
    self.dataList = entities;
    
    //提前设置 feedView，计算高度
    for (YGFeedEntity *obj in  self.dataList) {
        YGFeedView *feedView = [[YGFeedView alloc] initWithData:obj];
        [self.feedViewList addObject:feedView];
    }
    
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath{
    YGFeedView *feedView = self.feedViewList [indexPath.row];
    return feedView.yoga.intrinsicSize.height;
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath{
    YGFeedCell *cell =[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                           forIndexPath:indexPath];
    YGFeedView *feedView = self.feedViewList [indexPath.row];
    [cell configureFeedView:feedView];
   
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataList count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self heightForIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    return [self cellForIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter
- (NSArray *)dataList{
    if (!_dataList) {
        _dataList =[NSArray new];
    }
    return _dataList;
}

- (NSMutableArray *)feedViewList{
    if (!_feedViewList) {
        _feedViewList =[[NSMutableArray alloc] init];
    }
    return _feedViewList;
}

- (NSMutableArray *)heightList{
    if (!_heightList) {
        _heightList = [[NSMutableArray alloc] init];
    }
    return _heightList;
}

@end

