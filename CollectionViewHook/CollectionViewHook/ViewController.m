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
    
    /** 可能的组合顺序
     123  132
     231  213
     312  321
     **/
    
    
    [self.view addSubview:self.categoryView];//1
    [self.view addSubview:self.categorySubView]; //2
    [self.view addSubview:self.categorySubOneView];//3
  

  
    //加载后，打印类中存在的方法
    [self logClass:[self.categoryView class]];
    [self logClass:[self.categorySubView class]];
    [self logClass:[self.categorySubOneView class]];
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
        
        CGRect frame =  CGRectMake(0, 88, 300, 200);
        _categoryView = [[HZCategoryView alloc] initWithFrame:frame];
        _categoryView.backgroundColor = [UIColor redColor];
         [_categoryView setupCollectionView];
        
        UILabel *titleLabel  =[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-20, 400, 20)] ;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"CategoryView 点击灰块触发事件";
        [self.view addSubview:titleLabel];
    }
    return _categoryView;
}

- (HZCategorySubView *)categorySubView
{
    if (!_categorySubView) {
        CGRect frame =  CGRectMake(0,288+40, 300, 200);
        _categorySubView = [[HZCategorySubView alloc] initWithFrame:frame];
        _categorySubView.backgroundColor = [UIColor greenColor];
        [_categorySubView setupCollectionView];
        
        UILabel *titleLabel  =[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-20, 200, 20)] ;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"CategoryView 子类";
        [self.view addSubview:titleLabel];
    }
    return _categorySubView;
}

- (HZCategorySubOneView *)categorySubOneView
{
    if (!_categorySubOneView) {
         CGRect frame =  CGRectMake(0,488+80, 300, 200);
        _categorySubOneView = [[HZCategorySubOneView alloc] initWithFrame:frame];
        _categorySubOneView.backgroundColor = [UIColor blueColor];
        [_categorySubOneView setupCollectionView];
        
        UILabel *titleLabel  =[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-20, 200, 20)] ;
         titleLabel.textColor = [UIColor blackColor];
         titleLabel.text = @"CategoryView 孙子类";
         [self.view addSubview:titleLabel];
    }
    
    return _categorySubOneView;
}
@end
