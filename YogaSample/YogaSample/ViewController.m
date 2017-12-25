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

static NSString *const tableViewIdentifier = @"tableViewIdentifier";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,readwrite,strong) UITableView *tableView;
@property (nonatomic,readwrite,copy  ) NSArray     *layoutList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - private


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.layoutList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = self.layoutList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

- (NSArray *)layoutList{
    if (!_layoutList) {
        _layoutList = @[@"居中布局",@"嵌套布局",@"等间距布局",@"等间距自动设宽",@"ScrollView排布设contentSize"];
    }
    return _layoutList;
}

@end
