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
    self.debounce.aSelector = NSStringFromSelector(@selector(show));
    self.debounce.inteval   = 8;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
