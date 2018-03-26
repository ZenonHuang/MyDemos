//
//  YGSampleView.m
//  YogaSample
//
//  Created by mewe on 2017/12/25.
//  Copyright © 2017年 zenonhuang. All rights reserved.
//

#import "YGSampleView.h"
#import "UIView+Yoga.h"

@interface YGSampleView ()
@property (nonatomic,readwrite,strong) UIView *redView;
@property (nonatomic,readwrite,strong) UIView *yellowView;
@property (nonatomic,readwrite,strong) UIView *blueView;
@end

@implementation YGSampleView

- (instancetype)initWithType:(YGSampleType)type
{
    self = [super initWithFrame:(CGRect){
        .size = {
            .width = [UIScreen mainScreen].bounds.size.width,
            .height = [UIScreen mainScreen].bounds.size.height,
        }
    }];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.redView    = [self createView:[UIColor redColor]];
    self.yellowView = [self createView:[UIColor yellowColor]];
    self.blueView   = [self createView:[UIColor blueColor]];
    
    [self setupType:type];
    
    return self;
}



#pragma mark - private
- (void)setupType:(YGSampleType)type{
    
    switch (type) {
        case YGSampleTypeCenter:
        {
            [self configureLayoutWithBlock:^(YGLayout *layout) {
                layout.isEnabled = YES;
                layout.justifyContent =  YGJustifyCenter;
                layout.alignItems     =  YGAlignCenter;
            }];
            
            [self.redView configureLayoutWithBlock:^(YGLayout *layout) {
                layout.isEnabled = YES;
                layout.width=layout.height= 100;
                
            }];
            
            [self addSubview:self.redView];
            
            
            
   
            
            break;
        }
        case YGSampleTypeNested:
        {
            [self setupType:YGSampleTypeCenter];
            [self.yellowView configureLayoutWithBlock:^(YGLayout *layout) {
                layout.isEnabled = YES;
                layout.margin = 10;
                layout.flexGrow = 1;
            }];
            [self.redView addSubview:self.yellowView];
            
            break;
        }
        case YGSampleTypeSpace:
        {
            [self configureLayoutWithBlock:^(YGLayout *layout) {
                layout.isEnabled = YES;
                layout.flexDirection  =  YGFlexDirectionRow;
                layout.alignItems     =  YGAlignCenter;
                
                layout.paddingHorizontal = 5;
            }];
            
            
            YGLayoutConfigurationBlock layoutBlock =^(YGLayout *layout) {
                layout.isEnabled = YES;
                
                layout.height= 100;
                layout.marginHorizontal = 5;
                layout.flexGrow = 1;
            };
            
            
            [self.redView configureLayoutWithBlock:layoutBlock];
            [self.yellowView configureLayoutWithBlock:layoutBlock];
            
           
            [self addSubview:self.yellowView];
            [self addSubview:self.redView];
            
            break;
        }
        case YGSampleTypeScrollView:
        {
            [self configureLayoutWithBlock:^(YGLayout *layout) {
                layout.isEnabled = YES;
                layout.justifyContent =  YGJustifyCenter;
                layout.alignItems     =  YGAlignStretch;
            }];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init] ;
            scrollView.backgroundColor = [UIColor grayColor];
            [scrollView configureLayoutWithBlock:^(YGLayout *layout) {
                layout.isEnabled = YES;

                layout.flexDirection = YGFlexDirectionColumn;
                layout.height =500;
            }];
            [self addSubview:scrollView];

            UIView *contentView = [UIView new];
            [contentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
                layout.isEnabled = YES;
                
                layout.alignItems = YGAlignCenter;
            }];
            
            
            for ( int i = 1 ; i <= 20 ; ++i )
            {
                UIView *item = [UIView new];
                item.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                                                  saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                                  brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                                       alpha:1];
                [item  configureLayoutWithBlock:^(YGLayout *layout) {
                    layout.isEnabled = YES;

                    layout.height     = 20*i;
                    layout.width      = 200;
                   
                }];

                [contentView addSubview:item];
            }
            
            [scrollView addSubview:contentView];
            [scrollView.yoga applyLayoutPreservingOrigin:YES];
            scrollView.contentSize = contentView.bounds.size;
            
            break;
        }
        case YGSampleTypeSpaceBetween:
        {
            [self configureLayoutWithBlock:^(YGLayout *layout) {
                layout.isEnabled = YES;
                
                layout.justifyContent =  YGJustifySpaceBetween;
                layout.alignItems     =  YGAlignCenter;
            }];
            
            for ( int i = 1 ; i <= 10 ; ++i )
            {
                UIView *item = [UIView new];
                item.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                                                  saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                                  brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                                       alpha:1];
                [item  configureLayoutWithBlock:^(YGLayout *layout) {
                    layout.isEnabled = YES;
                    
                    layout.height     = 10*i;
                    layout.width      = 10*i;
                }];
                
                [self addSubview:item];
            }
            break;
        }
        case YGSampleTypeCenterAnimation:{
            [self setupType:YGSampleTypeCenter];
            //动画
            [UIView animateWithDuration:1 animations:^{
                [self.redView configureLayoutWithBlock:^(YGLayout *layout) {
                    layout.isEnabled = YES;
                    layout.width=layout.height= 10;
                    
                }];
                [self.yoga applyLayoutPreservingOrigin:YES];
                [self layoutIfNeeded];
            }];
            break;
        }
        default:
            break;
    }
    
    [self.yoga applyLayoutPreservingOrigin:YES];
    

}

- (UIView *)createView:(UIColor *)color{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

@end
