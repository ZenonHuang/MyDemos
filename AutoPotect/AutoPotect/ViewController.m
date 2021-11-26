//
//  ViewController.m
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//

#import "ViewController.h"
#import "HZTestObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //数组
    [HZTestObject testArrayCase];
    
    //字典
//    [HZTestObject testDictCase];
    
    //类方法 unrecognized
//    HZTestObject *obj = [HZTestObject new];
//    [obj performSelector:@selector(testClsMethod)];
    
    //实例 unrecognized
//    UIButton *testButton = [[UIButton alloc] init];
//    [testButton performSelector:@selector(testSomeMethod:)];
}


@end
