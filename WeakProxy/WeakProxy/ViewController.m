//
//  ViewController.m
//  WeakProxy
//
//  Created by zz go on 2020/6/2.
//  Copyright © 2020 ZenonHuang. All rights reserved.
//

#import "ViewController.h"
#import "WeakProxy.h"


@protocol testProtocol <NSObject>

- (void)doSome;

@end


@interface TestProxy : WeakProxy

@end

@implementation TestProxy



@end

@interface TestObj : NSObject<testProtocol>

@end
@implementation TestObj

- (void)doSome
{
    NSLog(@"test obj");
}

- (NSString *)debugDescription
{
    return @"TestObj 123";
}
@end




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        WeakProxy *delegateProxy;
        @autoreleasepool {
            TestObj *delegate = [TestObj new];
            delegateProxy = [[TestProxy alloc] initWithTarget:delegate];
            [(id<testProtocol>)delegateProxy doSome];
        }
    
        [(id<testProtocol>)delegateProxy doSome];


}


@end
