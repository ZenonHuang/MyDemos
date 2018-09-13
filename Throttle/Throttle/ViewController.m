//
//  ViewController.m
//  Throttle
//
//  Created by mewe on 2018/9/6.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Throttle.h"
#import "NSObject+Debounce.h"

@interface ViewController ()
@property (nonatomic,strong) UIAlertController *alertVC;
@property (nonatomic,strong) Debounce          *debounce;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.debounce = [[Debounce alloc] init];
   

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showOne:(NSString *)one twoParam:(NSString *)two{
    NSLog(@"1 %@ ,2 %@ ",one,two);
}

- (void)show{
    
    [self presentViewController:self.alertVC animated:YES completion:nil];
}

#pragma mark - action

- (IBAction)tapButton:(id)sender {
    NSLog(@"点击 Throttle");
    [self hz_performSelector:@selector(show)
                withThrottle:10];
}

- (IBAction)tapDebouceButton:(id)sender {
    NSLog(@"点击 Debouce");
    
    {
        self.debounce.inteval   = 2;
        
        SEL myMethod  = @selector(showOne:twoParam:);
        self.debounce.aSelector = NSStringFromSelector(myMethod);
  
    
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:myMethod];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:myMethod];
        
        NSString *name1 = @"小明";
        NSString *name2 = @"小张";
        [invocation setArgument:&name1 atIndex:2];
        [invocation setArgument:&name2 atIndex:3];
        
        invocation.target = self;
        
        self.debounce.lastOperation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    }
    
    
    [self hz_performWithDebounce:self.debounce];
}

#pragma mark - getter

- (UIAlertController *)alertVC{
    if (!_alertVC) {
        _alertVC = [UIAlertController alertControllerWithTitle:@"提示"
                                                       message:nil
                                                preferredStyle:UIAlertControllerStyleActionSheet];
 
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了OK");
        }];

        [_alertVC addAction:okAction];
    
    }
    return _alertVC;
}


@end
