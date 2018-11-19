//
//  ViewController.m
//  ChatInputView
//
//  Created by zz go on 2018/11/8.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import "ViewController.h"
#import "HZChatInputView.h"


@interface ViewController ()<HZChatInputViewDelegate>
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
#pragma mark - HZChatInputViewDelegate
-(void)hz_chatInputView:(HZChatInputView *)chatInputView keyboardWillShow:(NSDictionary *)userInfo{
    
}

- (void)hz_chatInputView:(HZChatInputView *)chatInputView keyboardWillHide:(NSDictionary *)userInfo{
    
}

- (void)hz_chatInputView:(HZChatInputView *)chatInputView textChange:(NSString *)text{
    
}

- (void)hz_chatInputView:(HZChatInputView *)chatInputView sendText:(NSString *)text{
    
}

- (void)hz_chatInputView:(HZChatInputView *)chatInputView tapImageButton:(UIButton *)button{
    
}

#pragma mark - getter
- (HZChatInputView *)chatInputView{
    if (!_chatInputView) {
        _chatInputView = [HZChatInputView addFromChatView:self.view];
        _chatInputView.delegate = self;
        _chatInputView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _chatInputView.textViewBackgroundColor = [UIColor whiteColor];
        _chatInputView.inputTextFont = [UIFont systemFontOfSize:15];
        _chatInputView.maxTextHeight = 200;
        _chatInputView.placeholderText = @"input some..";
        _chatInputView.sendButtonNormalColor = [UIColor orangeColor];
        _chatInputView.sendButtonDisableColor = [UIColor grayColor];
        _chatInputView.textViewCornerRadius = 5;
        _chatInputView.sendButtonCornerRadius = 5;
    }
    return _chatInputView;    
}

@end
