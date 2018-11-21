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
  
}

- (void)addTabViewToVC{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
   
    self.tabView.frame = CGRectMake(0, 80, size.width, 35);
    
     [vc.view addSubview:self.tabView];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tabView reloadData];
}

- (IBAction)tapLineButton:(id)sender {
    self.tabView = nil;
    
    self.tabView.widthStyle = HZTabViewWidthStyleDefault;
    self.tabView.lineStyle = HZTabViewLineStyleDefault;
    
    HZTabModel *model1 = [[HZTabModel alloc] init];
    model1.title = @"你11好";
    
    HZTabModel *model2 = [[HZTabModel alloc] init];
    model2.title = @"我好11";
    HZTabModel *model3 = [[HZTabModel alloc] init];
    model3.title = @"大家11好";
    self.tabView.titleList = @[model1,model2,model3];
    
     [self addTabViewToVC];
}

- (IBAction)tapBackButton:(id)sender {
    self.tabView = nil;
    
    
    self.tabView.widthStyle = HZTabViewWidthStyleAdapter;
    self.tabView.lineStyle = HZTabViewLineStyleBackground;
    self.tabView.titleList = [self moreList];
    [self addTabViewToVC];
}

- (IBAction)tapScaleButton:(id)sender {
    self.tabView = nil;
    
    self.tabView.widthStyle = HZTabViewWidthStyleAdapter;
    self.tabView.lineStyle = HZTabViewLineStyleNone;
    self.tabView.titleSelectedFont = [UIFont boldSystemFontOfSize:15];
     self.tabView.titleList = [self moreList];
    [self addTabViewToVC];
}

#pragma mark - delegate

- (void)hz_tabView:(HZTabView *)tabView didSelected:(NSInteger)index{
    NSLog(@"didSelected %d",index);
}

#pragma mark - getter
- (HZTabView *)tabView{
    if (!_tabView) {
        _tabView = [[HZTabView alloc] init];
        _tabView.delegate = self;
     
        _tabView.lineColor = [UIColor orangeColor];
        
    
        
    }
    return _tabView;
}

- (NSArray *)moreList{
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
    
    return @[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,model12];
}
@end
