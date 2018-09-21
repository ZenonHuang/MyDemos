//
//  ViewController.m
//  JSCoreDemo
//
//  Created by mewe on 2018/9/19.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()
@property (nonatomic,strong) JSContext *context;
@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (IBAction)tapCallOC:(id)sender {
    [self configureJSCallNative];
}

- (IBAction)tapCallJS:(id)sender {
    [self configureNativeCallJS];
}


#pragma mark - priate

//OC 调用 JS
- (void)configureNativeCallJS{
    JSContext *context = [[JSContext alloc] init];
    JSValue  *value = [context evaluateScript:@"2+2"];
    NSLog(@" native -> js: %d ",[value toInt32]);
}


//JS 调用 OC
- (void)configureJSCallNative{
    
    //1.定义好和 js 对应的对象/函数
    self.context = [[JSContext alloc] init];
    // 做引用，将 JS 内的元素引用过来解释，比如方法可以解释成 Block，对象也可以指向 OC 的 Native 对象
    self.context[@"obj"] = @"hi,JavasriptCore";
    self.context[@"yourFunc"] = ^(id parameter){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"parameter %@",parameter);
        });
    };
    
    //2.执行 js
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    [self.context evaluateScript:script];
    
}




@end
