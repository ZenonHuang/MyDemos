//
//  ViewController.m
//  CollectionViewHook
//
//  Created by zz go on 2019/9/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "ViewController.h"
#import "CollectionView/HZCategoryView.h"

#import <objc/runtime.h>


@interface ViewController ()
@property (nonatomic,strong) HZCategoryView *categoryView;
@property (nonatomic,strong) HZCategorySubView *categorySubView;
@property (nonatomic,strong) HZCategorySubOneView *categorySubOneView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.categorySubOneView];
    [self.view addSubview:self.categorySubView];
    [self.view addSubview:self.categoryView];
    
    
    [self logClass:[self.categoryView class]];
    [self logClass:[self.categorySubView class]];

}

- (void)logClass:(Class)clss
{
    
    unsigned int count;

    //获取方法列表
    Method *methodList = class_copyMethodList(clss, &count);
    for (unsigned int i=0; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"%@ method----="">%@",NSStringFromClass(clss) ,NSStringFromSelector(method_getName(method)));
    } 
}

- (HZCategoryView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[HZCategoryView alloc] initWithFrame:CGRectMake(0, 88, 300, 200)];
        _categoryView.backgroundColor = [UIColor redColor];
         [_categoryView setupCollectionView];
    }
    return _categoryView;
}

- (HZCategorySubView *)categorySubView
{
    if (!_categorySubView) {
        _categorySubView = [[HZCategorySubView alloc] initWithFrame:CGRectMake(0,288+20, 300, 200)];
        _categorySubView.backgroundColor = [UIColor greenColor];
        [_categorySubView setupCollectionView];
    }
    return _categorySubView;
}

- (HZCategorySubOneView *)categorySubOneView
{
    if (!_categorySubOneView) {
        _categorySubOneView = [[HZCategorySubOneView alloc] initWithFrame:CGRectMake(0,488+20, 300, 200)];
        _categorySubOneView.backgroundColor = [UIColor blueColor];
        [_categorySubOneView setupCollectionView];
    }
    
    return _categorySubOneView;
}
@end
