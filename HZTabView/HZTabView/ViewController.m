//
//  ViewController.m
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import "ViewController.h"
#import "HZTabView.h"

@interface ViewController ()<HZTabViewDelegate>
@property (nonatomic,strong) HZTabView *tabView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    [self.view addSubview:self.tabView];
    self.tabView.frame = CGRectMake(0, 80, size.width/2, 50);
    [self.tabView reloadData];
}

- (void)hz_tabView:(HZTabView *)tabView didSelected:(NSInteger)index{
    NSLog(@"didSelected %d",index);
}

#pragma mark - getter
- (HZTabView *)tabView{
    if (!_tabView) {
        _tabView = [[HZTabView alloc] init];
        _tabView.delegate = self;
        _tabView.lineStyle = HZTabViewLineStyleBackground;
        _tabView.lineColor = [UIColor orangeColor];
        
        HZTabModel *model1 = [[HZTabModel alloc] init];
        model1.title = @"你好";
    
        HZTabModel *model2 = [[HZTabModel alloc] init];
        model2.title = @"我好";
        HZTabModel *model3 = [[HZTabModel alloc] init];
        model3.title = @"大家好";
        
        _tabView.titleList = @[model1,model2,model3];
    }
    return _tabView;
}
@end
