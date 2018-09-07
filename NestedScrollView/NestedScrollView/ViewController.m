//
//  ViewController.m
//  NestedScrollView
//
//  Created by zz go on 2018/9/7.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import "ViewController.h"

static CGFloat topViewHeight    = 300;
static CGFloat headerViewHeight = 88;
static CGFloat subScrollHeight  = 800;

@interface ViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIView       *topView;
@property (nonatomic,strong) UIView       *headerView;
@property (nonatomic,strong) UIScrollView *subScrollView;

@property (nonatomic,assign) CGFloat      currentPanY;
@property (nonatomic,assign) BOOL      mainScrollEnable;
@property (nonatomic,assign) BOOL       subScrollEnable;

@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    { //init some data
        self.currentPanY = 0;
        self.mainScrollEnable = NO;
        self.subScrollEnable  = NO;
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(panGestureRecognizerAction:)];
        self.pan.delegate = self;
        [self.mainScrollView addGestureRecognizer:self.pan];
    }
    
    {// add subview
        [self.view addSubview:self.mainScrollView];
        [self.mainScrollView addSubview:self.topView];
        [self.mainScrollView addSubview:self.headerView];
        [self.mainScrollView addSubview:self.subScrollView];
    }
    
    {// configure ContentSize with ScrollView
        CGFloat height = topViewHeight + headerViewHeight +subScrollHeight;
        CGFloat width  = [self screenSize].width;
        self.mainScrollView.contentSize = CGSizeMake(width, height);
        
        self.subScrollView.contentSize  = CGSizeMake(width, subScrollHeight );
    }
    
 
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state!=UIGestureRecognizerStateChanged) {
        self.currentPanY = 0;
        //每次滑动清空
        self.mainScrollEnable = NO;
        self.subScrollEnable  = NO;
    }else{
        
        //获取当前在 mainScrollView 里的 Y 值
        CGFloat currentY = [recognizer translationInView:self.mainScrollView].y;
        
        //滑动中有一个
        if (self.mainScrollEnable||
            self.subScrollEnable) {
            if (self.currentPanY==0) {//如果 currentPanY 为0,则将它复制为 currentY.记录经过临界点的Y
                self.currentPanY = currentY;
            }
            CGFloat offsetY = self.currentPanY - currentY;//计算之后的偏移
            if (self.mainScrollEnable) {
                CGFloat supposeY = topViewHeight + offsetY;
                if (supposeY>=0) {
                    [self.mainScrollView setContentOffset:CGPointMake(0, supposeY)];
                }else{
                     [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
                }
            }else{
                [self.subScrollView setContentOffset:CGPointMake(0, offsetY)];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (scrollView==self.mainScrollView) {
      
        if (offsetY >= topViewHeight) {
            self.mainScrollView.scrollEnabled = NO;
            self.subScrollView .scrollEnabled = YES;
            
            [scrollView setContentOffset:CGPointMake(0, topViewHeight)];
            
            self.mainScrollEnable = NO;
            self.subScrollEnable  = YES;
        }
    }
    
    if (scrollView==self.subScrollView) {
     
        if (offsetY <= 0) {
            self.mainScrollView.scrollEnabled = YES;
            self.subScrollView .scrollEnabled = NO;
            
            [scrollView setContentOffset:CGPointMake(0, 0)];
            
            self.mainScrollEnable= YES;
            self.subScrollEnable = NO;
        }
    }
  
}

#pragma mark - private

- (CGSize)screenSize{
   return  [UIScreen mainScreen].bounds.size;
}

#pragma mark - getter

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self screenSize].width, [self screenSize].height)];
      
            view.scrollEnabled = YES;
            view.delegate = self;
            view.backgroundColor = [UIColor orangeColor];
            view.showsVerticalScrollIndicator = NO;
            view;
            
        });
    }
    return _mainScrollView;
}

- (UIView *)topView{
    if (!_topView) {
         CGRect rect = CGRectMake(0, 0,[self screenSize].width , topViewHeight);
        _topView = [[UIView alloc] initWithFrame:rect];
        _topView.backgroundColor = [UIColor redColor];
    }
    
    return _topView;
}

- (UIView *)headerView{
    if (!_headerView) {
        CGRect rect = CGRectMake(0, topViewHeight,[self screenSize].width , headerViewHeight);
        _headerView = [[UIView alloc] initWithFrame:rect];
        _headerView.backgroundColor = [UIColor blueColor];
    }
    
    return _headerView;
}

- (UIScrollView *)subScrollView{
    if (!_subScrollView) {
        _subScrollView = ({
            
            CGFloat y   = topViewHeight+headerViewHeight;
            CGFloat height = [self screenSize].height - headerViewHeight;
            CGRect rect = CGRectMake(0, y, [self screenSize].width, height);
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:rect];
            view.scrollEnabled = NO;
            view.delegate = self;
            view.backgroundColor = [UIColor greenColor];
            view;
            
        });
    }
    return _subScrollView;
}

@end
