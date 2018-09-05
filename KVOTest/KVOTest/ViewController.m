//
//  ViewController.m
//  KVOTest
//
//  Created by mewe on 2018/3/23.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "Fizz.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Fizz *fizz = [[Fizz alloc] init];
    [fizz addObserver:self
           forKeyPath:@"number"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    fizz.number = @2;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"number"]) {
        NSLog(@"%@", change);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
