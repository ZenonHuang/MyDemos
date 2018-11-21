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
    self.tabView.frame = CGRectMake(0, 80, size.width, 35);
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
        _tabView.widthStyle = HZTabViewWidthStyleAdapter;
        _tabView.lineStyle = HZTabViewLineStyleBackground;
        _tabView.lineColor = [UIColor orangeColor];
        
        HZTabModel *model1 = [[HZTabModel alloc] init];
        model1.title = @"你11好";
    
        HZTabModel *model2 = [[HZTabModel alloc] init];
        model2.title = @"我好11";
        HZTabModel *model3 = [[HZTabModel alloc] init];
        model3.title = @"大家11好";
        
        HZTabModel *model4 = [[HZTabModel alloc] init];
        model4.title = @"大家11好";
        
        HZTabModel *model5 = [[HZTabModel alloc] init];
        model5.title = @"341113";
        
        HZTabModel *model6 = [[HZTabModel alloc] init];
        model6.title = @"尼11莫";
        
        HZTabModel *model7 = [[HZTabModel alloc] init];
        model7.title = @"哈哈11";
        
        HZTabModel *model8 = [[HZTabModel alloc] init];
        model8.title = @"哦11豁";
        
        HZTabModel *model9= [[HZTabModel alloc] init];
        model9.title = @"哦11豁";
        
        HZTabModel *model10 = [[HZTabModel alloc] init];
        model10.title = @"哦11豁";
        
        HZTabModel *model11 = [[HZTabModel alloc] init];
        model11.title = @"哦11豁";
        
        HZTabModel *model12 = [[HZTabModel alloc] init];
        model12.title = @"哦11豁";
        
        _tabView.titleList = @[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,model12];
    }
    return _tabView;
}
@end
