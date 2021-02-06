//
//  ViewController.m
//  WaterMarkForLSB
//
//  Created by zz go on 2020/11/20.
//

#import "WMMainViewController.h"

#define kCellIdentifier @"kWMMainViewCell"

@interface WMListCellModel : NSObject
@property (nonatomic,copy)  NSString *title;
@property (nonatomic,copy)  NSString *controllerName;
@end
@implementation WMListCellModel
+ (WMListCellModel *)createModelWiht:(NSString *)title
                       contrllerName:(NSString *)controllerName
{
    WMListCellModel *model = [WMListCellModel new];
    model.title = title;
    model.controllerName = controllerName;
    return model;
}

@end


@interface WMMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *listView;
@property (nonatomic,copy)  NSArray *dataList;
@end

@implementation WMMainViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WMListCellModel *screenshotModel = [WMListCellModel createModelWiht:@"Screenshot" 
                                                   contrllerName:@"WMScreenshotViewController"];
    
    WMListCellModel *grayModel = [WMListCellModel createModelWiht:@"GrayImage" 
                                                   contrllerName:@"WMGrayImageViewController"];
    
    WMListCellModel *binaryzationModel = [WMListCellModel createModelWiht:@"Binaryzation" 
                                                            contrllerName:@"WMBinaryzationViewController"];
    
    self.dataList = @[screenshotModel,grayModel,binaryzationModel];
    
    [self.view addSubview:self.listView];
}

#pragma mark - delegate/datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                           forIndexPath:indexPath];
    WMListCellModel *model = [self.dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMListCellModel *model = [self.dataList objectAtIndex:indexPath.row];
    id controller  = [NSClassFromString(model.controllerName) new];
    if ([controller isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)controller;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter

- (UITableView *)listView
{
    if (!_listView) {
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height); 
        _listView = [[UITableView alloc] initWithFrame:rect];
        _listView.dataSource = self;
        _listView.delegate   = self;
        [_listView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _listView;
}

@end
