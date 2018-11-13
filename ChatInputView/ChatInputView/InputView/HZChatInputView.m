//
//  HZChatInputView.m
//  ChatInputView
//
//  Created by zz go on 2018/11/8.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import "HZChatInputView.h"


@interface HZChatInputView ()
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton   *plusButton;
@end

@implementation HZChatInputView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor grayColor];
    
    [self addSubview:self.textView];
    [self addSubview:self.plusButton];    
    

    return self;
}

#pragma mark - getter
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}

- (UIButton *)plusButton{
    if (!_plusButton) {
        _plusButton = [[UIButton alloc] init];
        _plusButton.backgroundColor = [UIColor orangeColor];
    }
    return _plusButton;
}
@end
