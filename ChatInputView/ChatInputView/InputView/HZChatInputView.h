//
//  HZChatInputView.h
//  ChatInputView
//
//  Created by zz go on 2018/11/8.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZChatInputView : UIView
///textView 的最大高
@property (nonatomic,assign) int maxTextHeight;

@property (nonatomic,copy)   NSString  *text;
@property (nonatomic,strong) UIColor   *textViewBackgroundColor;
@property (nonatomic,strong) UIFont    *inputTextFont;

@property (nonatomic,strong) UIColor    *sendButtonNormalColor;
@property (nonatomic,strong) UIColor    *sendButtonDisableColor;

@property (nonatomic,copy) NSString *placeholderText;

+ (HZChatInputView *)addInputView:(UIView *)chatView;

@end

