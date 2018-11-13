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
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view addSubview:self.chatInputView];
}


#pragma mark - getter
- (HZChatInputView *)chatInputView{
    if (!_chatInputView) {
        _chatInputView = [HZChatInputView addInputView:self.view];
        _chatInputView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _chatInputView.textViewBackgroundColor = [UIColor whiteColor];
        _chatInputView.inputTextFont = [UIFont italicSystemFontOfSize:18];
        _chatInputView.maxTextHeight = 200;
        _chatInputView.placeholderText = @"input some..";
        _chatInputView.sendButtonNormalColor = [UIColor orangeColor];
        _chatInputView.sendButtonDisableColor = [UIColor grayColor];
    }
    return _chatInputView;    
}

@end
