//
//  ViewController.m
//  LayoutTest
//
//  Created by mewe on 2017/12/19.
//  Copyright © 2017年 mewe. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import <UIView+Yoga.h>
#import <YGLayout.h>
#import <objc/Runtime.h>


typedef struct {
    CGRect frame;
    CGSize size;
    CGPoint orign;
}TestFrame;

typedef struct {
    int  one;
    int  two;
}TestNumber;

typedef struct {
    TestFrame frame1;
    TestFrame frame2;
    TestFrame frame3;
    TestFrame frame4;
    TestFrame frame5;
    TestFrame frame6;
    TestFrame frame7;
    TestFrame frame8;
    TestFrame frame9;
    TestFrame frame10;
}TestDoubleFrame;

@interface ViewController ()
@property (nonatomic) UITableView *tableView;
@end

@implementation ViewController {
    UITextField *_textField;
    UILabel *_indicateLabel;
    NSMutableArray *_views;
    
    NSMutableDictionary *_resultDictionary;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _views = [[NSMutableArray alloc] init];
    
    UIButton *autoLayoutButton = [self createButton:@"AutoLayout"];
    [autoLayoutButton addTarget:self action:@selector(generateViews)
               forControlEvents:UIControlEventTouchUpInside];
    [autoLayoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *nestedAutoLayoutButton = [self createButton:@"AutoLayout嵌套"];
    [nestedAutoLayoutButton addTarget:self action:@selector(generateNestedViews)
                     forControlEvents:UIControlEventTouchUpInside];
    [nestedAutoLayoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
    }];
    
    [@[autoLayoutButton, nestedAutoLayoutButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                                          withFixedItemLength:140
                                                                  leadSpacing:0
                                                                  tailSpacing:0];
    
    UIButton *frameButton = [self createButton:@"Frame"];
    [frameButton addTarget:self
                    action:@selector(generateFrameViews)
          forControlEvents:UIControlEventTouchUpInside];
    [frameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(autoLayoutButton.mas_top);
    }];
    
    UIButton *nestedFrameButton = [self createButton:@"Frame嵌套"];
    [nestedFrameButton addTarget:self
                          action:@selector(generateNestedFrameViews)
                forControlEvents:UIControlEventTouchUpInside];
    [nestedFrameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(frameButton.mas_bottom);
    }];
    [@[frameButton, nestedFrameButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                                withFixedItemLength:140
                                                        leadSpacing:0
                                                        tailSpacing:0];
    
    UIButton *flexBoxButton = [self createButton:@"FlexBox"];
    [flexBoxButton addTarget:self
                      action:@selector(generateFlexBoxViews)
            forControlEvents:UIControlEventTouchUpInside];
    [flexBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(frameButton.mas_top);
    }];
    
    UIButton *nestedFlexBoxButton = [self createButton:@"FlexBox嵌套"];
    [nestedFlexBoxButton addTarget:self
                            action:@selector(generateNestedFlexBoxViews)
                  forControlEvents:UIControlEventTouchUpInside];
    [nestedFlexBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(frameButton.mas_top);
    }];
    [@[flexBoxButton, nestedFlexBoxButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                                    withFixedItemLength:140
                                                            leadSpacing:0
                                                            tailSpacing:0];
    
    
    _textField = [[UITextField alloc] init];
    _textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(flexBoxButton.mas_top);
        make.height.mas_equalTo(20);
    }];
    
    _indicateLabel = [[UILabel alloc] init];
    _indicateLabel.textColor = [UIColor blackColor];
    _indicateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_indicateLabel];
    [_indicateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *printResult = [[UIButton alloc] init];
    [printResult setTitle:@"PrintResult" forState:UIControlStateNormal];
    [printResult setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [printResult addTarget:self action:@selector(printerResult) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printResult];
    [printResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    
    _resultDictionary = [[NSMutableDictionary alloc] init];
    [_resultDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"AutoLayout"];
    [_resultDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"NestedAutoLayout"];
    [_resultDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"Frame"];
    [_resultDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"NestedFrame"];
    [_resultDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"FlexBox"];
    [_resultDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"NestedFlexBox"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [_textField becomeFirstResponder];
}


#pragma mark  - private
- (UIButton *)createButton:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    [button  setTitle:title forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    return button;
}

#pragma mark AutoLayout 非嵌套
-(void)getNumStruct{
    return ;
}
-(TestFrame)getStruct{
    
    CGRect frame =(CGRect) { 
        .origin = (CGPoint){ .x =1,.y =1,},
        .size   = (CGSize){  .width = 1, .height=1},
    };
    
    CGSize size = (CGSize){  .width = 1, .height=1};
    CGPoint point =  (CGPoint){ .x =1,.y =1,};
    
    return (TestFrame){
        .frame = frame,
        .size  = size,
        .orign  = point,
    };
}

- (TestDoubleFrame)getTestStruct{
    
    return (TestDoubleFrame){
        .frame1 = [self getStruct],
        .frame2 = [self getStruct],
        .frame3 = [self getStruct],
        .frame4 = [self getStruct],
        .frame5 = [self getStruct],
        .frame6 = [self getStruct],
        .frame7 = [self getStruct],
        .frame8 = [self getStruct],
        .frame9 = [self getStruct],
        .frame10 = [self getStruct],
    };
}

- (void)generateViews {
    
    Method method = class_getInstanceMethod(self.class, @selector(getNumStruct));
    const char *encoding = method_getTypeEncoding(method);
    
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:encoding];
    NSLog(@"debug Desc %@",methodSignature.debugDescription);
    
    NSUInteger valueSize = 0;
    NSGetSizeAndAlignment(encoding, &valueSize, NULL);
    
    return;
    NSInteger number = _textField.text.integerValue;
    
    for (int i=0; i<100 ;i++) {
        
        
        for (UIView *view in _views) {
            [view removeFromSuperview];
        }
        _views = [[NSMutableArray alloc] init];
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        for (NSInteger i = 0; i < number; i++) {
            UIView *leftView = self.view;
            UIView *topView = self.view;
            if (_views.count != 0) {
                NSInteger left = arc4random() % _views.count;
                NSInteger top = arc4random() % _views.count;
                leftView = _views[left];
                topView = _views[top];
            }
            
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            
            NSInteger leftSpace = (arc4random() % 414) - (int)leftView.frame.origin.x;
            NSInteger topSpace = (arc4random() % 568) - (int)topView.frame.origin.y;
            
            UIView *newView = [[UIView alloc] init];
            newView.backgroundColor = color;
            [self.view addSubview:newView];
            [newView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_greaterThanOrEqualTo(0);
                make.right.mas_lessThanOrEqualTo(0);
                make.top.mas_greaterThanOrEqualTo(20);
                make.bottom.mas_lessThanOrEqualTo(-40);
                make.left.mas_equalTo(leftView).offset(leftSpace).priorityMedium();
                make.top.mas_equalTo(topView).offset(topSpace).priorityMedium();
                make.size.mas_equalTo(10);
            }];
            
            [_views addObject:newView];
        }
        NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeInterval = endTime - startTime;
        
        NSMutableDictionary *autoLayoutDictionary = _resultDictionary[@"AutoLayout"];
        NSMutableDictionary *currentTimesDictionary = autoLayoutDictionary[@(number)] ?: [[NSMutableDictionary alloc] init];
        NSNumber *times = currentTimesDictionary[@"times"] ? : @0;
        NSNumber *avgTime = currentTimesDictionary[@"avgTime"] ? : @0;
        currentTimesDictionary[@"avgTime"] = @((times.integerValue * avgTime.doubleValue + timeInterval) / (double)(times.integerValue + 1));
        currentTimesDictionary[@"times"] = @(times.integerValue + 1);
        [autoLayoutDictionary setObject:currentTimesDictionary forKey:@(number)];
        
        _indicateLabel.text = [NSString stringWithFormat:@"%ld: %f", (long)number, endTime-startTime];
        
    }
}

#pragma mark Frame 非嵌套
- (void)generateFrameViews {
    NSInteger number = _textField.text.integerValue;
    for (int i=0; i<100 ;i++) {
        
        for (UIView *view in _views) {
            [view removeFromSuperview];
        }
        _views = [[NSMutableArray alloc] init];
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        for (NSInteger i = 0; i < number; i++) {
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            
            NSInteger leftSpace = (arc4random() % 404) % (int)self.view.frame.size.width;
            NSInteger topSpace = (arc4random() % 676) % (int)self.view.frame.size.height + 20;
            
            UIView *newView = [[UIView alloc] init];
            newView.backgroundColor = color;
            newView.frame = CGRectMake(leftSpace, topSpace, 10, 10);
            [self.view addSubview:newView];
            
            [_views addObject:newView];
        }
        NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeInterval = endTime - startTime;
        
        NSMutableDictionary *frameDictionary = _resultDictionary[@"Frame"];
        NSMutableDictionary *currentTimesDictionary = frameDictionary[@(number)] ?: [[NSMutableDictionary alloc] init];
        NSNumber *times = currentTimesDictionary[@"times"] ? : @0;
        NSNumber *avgTime = currentTimesDictionary[@"avgTime"] ? : @0;
        currentTimesDictionary[@"avgTime"] = @((times.integerValue * avgTime.doubleValue + timeInterval) / (double)(times.integerValue + 1));
        currentTimesDictionary[@"times"] = @(times.integerValue + 1);
        [frameDictionary setObject:currentTimesDictionary forKey:@(number)];
        
        _indicateLabel.text = [NSString stringWithFormat:@"%ld: %f", (long)number, endTime-startTime];
    }
    
}

#pragma mark AutoLayout 嵌套
- (void)generateNestedViews {
    NSInteger number = _textField.text.integerValue;
    for (int i=0; i<100 ;i++) {
        
        for (UIView *view in _views) {
            [view removeFromSuperview];
        }
        _views = [[NSMutableArray alloc] init];
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        for (NSInteger i = 0; i < number; i++) {
            UIView *leftView = self.view;
            UIView *topView = self.view;
            if (_views.count != 0) {
                NSInteger left = arc4random() % _views.count;
                NSInteger top = arc4random() % _views.count;
                leftView = _views[left];
                topView = _views[top];
            }
            
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            
            UIView *newView = [[UIView alloc] init];
            newView.backgroundColor = color;
            [self.view addSubview:newView];
            if (_views.count == 0) {
                [self.view addSubview:newView];
                
                [newView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0.5);
                    make.top.mas_equalTo(20.5);
                    make.bottom.mas_equalTo(-80.5);
                    make.right.mas_equalTo(-0.5);
                }];
            } else {
                UIView *aView = _views[i - 1];
                [aView addSubview:newView];
                
                [newView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.mas_equalTo(1);
                    make.bottom.right.mas_equalTo(-1);
                }];
            }
            
            [_views addObject:newView];
        }
        NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeInterval = endTime - startTime;
        
        NSMutableDictionary *autoLayoutDictionary = _resultDictionary[@"NestedAutoLayout"];
        NSMutableDictionary *currentTimesDictionary = autoLayoutDictionary[@(number)] ?: [[NSMutableDictionary alloc] init];
        NSNumber *times = currentTimesDictionary[@"times"] ? : @0;
        NSNumber *avgTime = currentTimesDictionary[@"avgTime"] ? : @0;
        currentTimesDictionary[@"avgTime"] = @((times.integerValue * avgTime.doubleValue + timeInterval) / (double)(times.integerValue + 1));
        currentTimesDictionary[@"times"] = @(times.integerValue + 1);
        [autoLayoutDictionary setObject:currentTimesDictionary forKey:@(number)];
        
        _indicateLabel.text = [NSString stringWithFormat:@"%ld: %f", (long)number, endTime-startTime];
    }
}

#pragma mark Frame 嵌套
- (void)generateNestedFrameViews {
    NSInteger number = _textField.text.integerValue;
    
    for (int i=0; i<100 ;i++) {
        
        for (UIView *view in _views) {
            [view removeFromSuperview];
        }
        _views = [[NSMutableArray alloc] init];
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        for (NSInteger i = 0; i < number; i++) {
            UIView *leftView = self.view;
            UIView *topView = self.view;
            if (_views.count != 0) {
                NSInteger left = arc4random() % _views.count;
                NSInteger top = arc4random() % _views.count;
                leftView = _views[left];
                topView = _views[top];
            }
            
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            
            UIView *newView = [[UIView alloc] init];
            newView.backgroundColor = color;
            [self.view addSubview:newView];
            if (_views.count == 0) {
                [self.view addSubview:newView];
                
                CGSize size =  self.view.frame.size;
                newView.frame = CGRectMake(0.5, 20.5,size.width - 1, size.height - 20.5 - 80.5);
                
            } else {
                UIView *aView = _views[i - 1];
                [aView addSubview:newView];
                
                CGSize size =  aView.frame.size;
                newView.frame = CGRectMake(1, 1,size.width - 2, size.height - 2);
            }
            
            [_views addObject:newView];
        }
        NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeInterval = endTime - startTime;
        
        NSMutableDictionary *autoLayoutDictionary = _resultDictionary[@"NestedFrame"];
        NSMutableDictionary *currentTimesDictionary = autoLayoutDictionary[@(number)] ?: [[NSMutableDictionary alloc] init];
        NSNumber *times = currentTimesDictionary[@"times"] ? : @0;
        NSNumber *avgTime = currentTimesDictionary[@"avgTime"] ? : @0;
        currentTimesDictionary[@"avgTime"] = @((times.integerValue * avgTime.doubleValue + timeInterval) / (double)(times.integerValue + 1));
        currentTimesDictionary[@"times"] = @(times.integerValue + 1);
        [autoLayoutDictionary setObject:currentTimesDictionary forKey:@(number)];
        
        _indicateLabel.text = [NSString stringWithFormat:@"%ld: %f", (long)number, endTime-startTime];
    }
}

#pragma mark FlexBox 非嵌套
- (void)generateFlexBoxViews {
    NSInteger number = _textField.text.integerValue;
    for (int i=0; i<100 ;i++) {
        
        for (UIView *view in _views) {
            [view removeFromSuperview];
        }
        _views = [[NSMutableArray alloc] init];
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        for (NSInteger i = 0; i < number; i++) {
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            
            NSInteger leftSpace = (arc4random() % 404) % (int)self.view.frame.size.width;
            NSInteger topSpace = (arc4random() % 676) % (int)self.view.frame.size.height + 20;
            
            UIView *newView = [[UIView alloc] init];
            newView.backgroundColor = color;
            
            [newView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
                layout.isEnabled = YES;
                layout.width = 10;
                layout.height = 10;
                layout.marginLeft = leftSpace;
                layout.marginTop = topSpace;
            }];
            [newView.yoga applyLayoutPreservingOrigin:YES];
            [self.view addSubview:newView];
            
            [_views addObject:newView];
        }
        NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeInterval = endTime - startTime;
        
        NSMutableDictionary *frameDictionary = _resultDictionary[@"FlexBox"];
        NSMutableDictionary *currentTimesDictionary = frameDictionary[@(number)] ?: [[NSMutableDictionary alloc] init];
        NSNumber *times = currentTimesDictionary[@"times"] ? : @0;
        NSNumber *avgTime = currentTimesDictionary[@"avgTime"] ? : @0;
        currentTimesDictionary[@"avgTime"] = @((times.integerValue * avgTime.doubleValue + timeInterval) / (double)(times.integerValue + 1));
        currentTimesDictionary[@"times"] = @(times.integerValue + 1);
        [frameDictionary setObject:currentTimesDictionary forKey:@(number)];
        
        _indicateLabel.text = [NSString stringWithFormat:@"%ld: %f", (long)number, endTime-startTime];
    }
    
}

#pragma mark FlexBox 嵌套
- (void)generateNestedFlexBoxViews{
    
    NSInteger number = _textField.text.integerValue;
    
    for (int i=0; i<100 ;i++) {
        
        for (UIView *view in _views) {
            [view removeFromSuperview];
        }
        _views = [[NSMutableArray alloc] init];
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        for (NSInteger i = 0; i < number; i++) {
            
            @autoreleasepool {
                // Code benefitting from a local autorelease pool.
                
                
                UIView *leftView = self.view;
                UIView *topView = self.view;
                if (_views.count != 0) {
                    NSInteger left = arc4random() % _views.count;
                    NSInteger top = arc4random() % _views.count;
                    leftView = _views[left];
                    topView = _views[top];
                }
                
                CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
                CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
                CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
                UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
                
                UIView *newView = [[UIView alloc] init];
                newView.backgroundColor = color;
                [self.view addSubview:newView];
                if (_views.count == 0) {
                    
                    [newView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
                        layout.isEnabled = YES;
                        layout.width = self.view.frame.size.width-2;
                        layout.height = self.view.frame.size.height- 20.5 - 80.5;
                        layout.marginLeft = 1;
                        layout.marginTop = 20.5;
                    }];
                    [self.view addSubview:newView];
                    [newView.yoga applyLayoutPreservingOrigin:YES];
                    
                    
                } else {
                    UIView *aView = _views[i - 1];
                    
                    [newView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
                        layout.isEnabled = YES;
                        layout.width =  aView.frame.size.width-2;
                        layout.height =  aView.frame.size.height- 2;
                        layout.marginLeft = 1;
                        layout.marginTop = 1;
                    }];
                    [aView addSubview:newView];
                    [newView.yoga applyLayoutPreservingOrigin:YES];
                }
                
                [_views addObject:newView];
            }
        }
        
        
        NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeInterval = endTime - startTime;
        
        NSMutableDictionary *autoLayoutDictionary = _resultDictionary[@"NestedFlexBox"];
        NSMutableDictionary *currentTimesDictionary = autoLayoutDictionary[@(number)] ?: [[NSMutableDictionary alloc] init];
        NSNumber *times = currentTimesDictionary[@"times"] ? : @0;
        NSNumber *avgTime = currentTimesDictionary[@"avgTime"] ? : @0;
        currentTimesDictionary[@"avgTime"] = @((times.integerValue * avgTime.doubleValue + timeInterval) / (double)(times.integerValue + 1));
        currentTimesDictionary[@"times"] = @(times.integerValue + 1);
        [autoLayoutDictionary setObject:currentTimesDictionary forKey:@(number)];
        
        _indicateLabel.text = [NSString stringWithFormat:@"%ld: %f", (long)number, endTime-startTime];
    }
}

#pragma mark Other
- (void)printerResult {
    NSLog(@"%@", _resultDictionary);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
