//
//  ViewController.m
//  YogaSample
//
//  Created by zz go on 2017/12/24.
//  Copyright © 2017年 zenonhuang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Yoga.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupSample2];
    
    return;
    {
        UIView *view = [self createView];
        [view configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled= YES;
            layout.flexDirection = YGFlexDirectionRow;
            //justify-content (适用于父类容器上)
            //设置或检索弹性盒子元素在主轴（横轴）方向上的对齐方式。
            //            layout.justifyContent = YGJustifySpaceBetween;
            //设置或检索弹性盒子元素在侧轴（纵轴）方向上的对齐方式。
            //            layout.alignItems   = YGAlignCenter;
            layout.width  = [UIScreen mainScreen].bounds.size.width;
            layout.height = [UIScreen mainScreen].bounds.size.height;
            
        }];
        [self.view addSubview:view];
        
        UIView *sub1 = [self createView];
        [sub1 configureLayoutWithBlock:^(YGLayout * layout) {
            layout.isEnabled= YES;
            
            layout.width =  100;
            layout.flexGrow = 1;
        
        }];
        [view addSubview:sub1];
        
        
        
        UIView *sub2 = [self createView];
        [sub2 configureLayoutWithBlock:^(YGLayout * layout) {
            layout.isEnabled= YES;
            
            layout.width =  50;
            layout.flexGrow = 1;
//            layout.display = YGDisplayNone;
        }];
        [view addSubview:sub2];
        
        
        [view.yoga applyLayoutPreservingOrigin:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (UIView *)createView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [self randomColor];
    return view;
}

- (CGFloat)randomNumber {
    return (arc4random() % 1000) / 1000.0;
}

- (UIColor*)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    return [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
}

#pragma mark - test
- (void)setupSample1{
    UIView *root = self.view;
    root.backgroundColor = [UIColor redColor];
    root.yoga.isEnabled = YES;
    root.yoga.width = self.view.bounds.size.width;
    root.yoga.height = self.view.bounds.size.height;
    root.yoga.alignItems = YGAlignCenter;
    root.yoga.justifyContent = YGJustifyCenter;
    
    UIView *child1 = [UIView new];
    child1.backgroundColor = [UIColor blueColor];
    child1.yoga.isEnabled = YES;
    child1.yoga.width = 100;
    child1.yoga.height = 100;
    
    UIView *child2 = [UIView new];
    child2.backgroundColor = [UIColor greenColor];
    child2.frame = (CGRect) {
        .size = {
            .width = 200,
            .height = 100,
        }
    };
    
    UIView *child3 = [UIView new];
    child3.backgroundColor = [UIColor yellowColor];
    child3.frame = (CGRect) {
        .size = {
            .width = 100,
            .height = 100,
        }
    };
    
    [child2 addSubview:child3];
    [root addSubview:child1];
    [root addSubview:child2];
    [root.yoga applyLayoutPreservingOrigin:NO];
    
    return;
    
}

- (void)setupSample2{
    UIView *root = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 300)];
    [root configureLayoutWithBlock:^void(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.alignItems = YGAlignCenter;
        layout.justifyContent =YGJustifyCenter;
        layout.padding = 20.0f;
    }];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = [UIColor blueColor]; 
    [image configureLayoutWithBlock:^void(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.marginBottom = 20.0f;
        layout.width=layout.height=100;
    }];
    [root addSubview:image];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 100)];
    text.backgroundColor = [UIColor orangeColor];
    [text configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled=YES;
        layout.width=100;
        layout.height=25;
    }];
    [root addSubview:text];
    
    [self.view addSubview:root];
    [root.yoga applyLayoutPreservingOrigin:YES];
}
@end
