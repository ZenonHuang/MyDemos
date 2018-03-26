//
//  ViewController.m
//  YogaSample
//
//  Created by zz go on 2017/12/24.
//  Copyright © 2017年 zenonhuang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Yoga.h"
#import "YGSampleView.h"
#import "YGSampleTableViewController.h"

typedef NS_ENUM(NSInteger,  YGSampleSectionType) {
    YGSampleSectionTypeNormal,//普通视图
    YGSampleSectionTypeList,//列表视图
};

static NSString *const tableViewIdentifier = @"tableViewIdentifier";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,readwrite,strong) UITableView *tableView;
@property (nonatomic,readwrite,copy  ) NSArray     *layoutSectionList;
@property (nonatomic,readwrite,copy  ) NSArray     *layoutNormalList;
@property (nonatomic,readwrite,copy  ) NSArray     *layoutTableList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - private


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.layoutSectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.layoutSectionList[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier
                                                            forIndexPath:indexPath];
    NSArray *list = self.layoutSectionList[indexPath.section];
    cell.textLabel.text = list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==  YGSampleSectionTypeList) {
        YGSampleTableViewController *tableVC = [[YGSampleTableViewController alloc] init];
        [self.navigationController pushViewController:tableVC animated:YES];
        return;
    }
    
    
    YGSampleView *sampleView = [[YGSampleView alloc] initWithType:indexPath.row];
    UIViewController *vc = [UIViewController new];
    [vc.view addSubview:sampleView];
    [self.navigationController pushViewController:vc animated:YES];


}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView= [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:tableViewIdentifier];
    
        _tableView.showsVerticalScrollIndicator =NO;
        
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)layoutSectionList{
    if (!_layoutSectionList) {
        _layoutSectionList = @[self.layoutNormalList,self.layoutTableList];
    }
    return _layoutSectionList;
}

- (NSArray *)layoutNormalList{
    if (!_layoutNormalList) {
        _layoutNormalList = @[@"居中布局",@"嵌套布局",@"等间距布局",@"等间距自动设宽",@"ScrollView排布设contentSize",@"缩放动画"];
    }
    return _layoutNormalList;
}

- (NSArray *)layoutTableList{
    if (!_layoutTableList) {
        _layoutTableList = @[@"微博列表"];
    }
    return _layoutTableList;
}

@end
