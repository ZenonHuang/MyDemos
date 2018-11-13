//
//  ViewController.m
//  ChatInputView
//
//  Created by zz go on 2018/11/8.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import "ViewController.h"
#import "HZChatInputView.h"


@interface ViewController ()
@property (nonatomic,strong) HZChatInputView *chatInputView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.chatInputView];

}

#pragma mark - getter
- (HZChatInputView *)chatInputView{
    if (!_chatInputView) {
        _chatInputView = [[HZChatInputView alloc] init];
    }
    return _chatInputView;    
}

@end
