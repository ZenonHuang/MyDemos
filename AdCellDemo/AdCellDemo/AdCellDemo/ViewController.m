//
//  ViewController.m
//  AdCellDemo
//
//  Created by zz go on 2016/12/28.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import "ViewController.h"
#import "HZAdAOP.h"

static NSString *const cellID=@"tableViewCellID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,readwrite,strong) UITableView *tableView;
@property (nonatomic,readwrite,strong) HZAdAOP     *aopDemo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    //begin 插入代码
    self.aopDemo = [HZAdAOP new];
    self.aopDemo.aopUtils = self.tableView.aop_utils;
    //end
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID
                                                          forIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}
#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] 
           forCellReuseIdentifier:cellID];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
@end
