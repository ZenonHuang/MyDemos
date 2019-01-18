//
//  ViewController.m
//  FloatView
//
//  Created by ZenonHuang on 2019/1/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "ViewController.h"
#import "FloatView.h"


static CGFloat const kFloatViewLength = 80;

@interface ViewController ()<FloatViewDelegate>
@property (nonatomic,strong) FloatView *floatView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.floatView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat safeTop = 0;
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeTop = self.view.safeAreaInsets.top;
        safeBottom = self.view.safeAreaInsets.bottom;
    }
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.floatView.freeRect = CGRectMake(0, safeTop, size.width,size.height - safeTop - safeBottom );
}

#pragma mark - private
- (void)setupStopView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           if (!self.floatView.inDrag) {//处于停止状态，才动画
               // 特殊情况 -- 1次停止三秒内，2次发起拖动，在1次三秒内停下，刚好触发，会马上缩小，需要做函数防抖
               CGPoint origin = self.floatView.frame.origin;
               [UIView animateWithDuration:0.3
                                     delay:0
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    
                                    self.floatView.frame = CGRectMake(origin.x, origin.y, kFloatViewLength/2, kFloatViewLength/2);
                                    self.floatView.alpha = 0.7;
                                }
                                completion:^(BOOL finished) {
                                    [self.floatView resetState];
                                }];
           }
  
    });
    
 

}

- (void)setupBeginView
{
    CGPoint origin = self.floatView.frame.origin;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.floatView.frame = CGRectMake(origin.x, origin.y, kFloatViewLength, kFloatViewLength);
                         self.floatView.alpha = 1.0;
                     }
                     completion:nil];

}

#pragma mark - FloatViewDelegate
- (void)FloatViewDidStopDrag:(FloatView *)view
{
    [self setupStopView];
}

- (void)FloatViewDidBeginDrag:(FloatView *)view
{
    [self setupBeginView];
}

#pragma mark - getter
- (FloatView *)floatView
{
    if (!_floatView) {
        _floatView = [[FloatView alloc] initWithFrame:CGRectMake(80, 80, kFloatViewLength, kFloatViewLength)];
        _floatView.backgroundColor = [UIColor orangeColor];
        _floatView.isKeepBounds = YES;
        _floatView.delegate = self;
    }
    
    return _floatView;
}
@end
