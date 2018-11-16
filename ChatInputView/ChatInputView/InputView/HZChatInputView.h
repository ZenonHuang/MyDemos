//
//  HZChatInputView.h
//  ChatInputView
//
//  Created by zz go on 2018/11/8.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZChatInputView;

@protocol HZChatInputViewDelegate <NSObject>

@optional
- (void)hz_chatInputView:(HZChatInputView *)chatInputView keyboardWillShow:(NSDictionary *)userInfo;
- (void)hz_chatInputView:(HZChatInputView *)chatInputView keyboardWillHide:(NSDictionary *)userInfo;
- (void)hz_chatInputView:(HZChatInputView *)chatInputView textChange:(NSString *)text;
@required
- (void)hz_chatInputView:(HZChatInputView *)chatInputView sendText:(NSString *)text;
- (void)hz_chatInputView:(HZChatInputView *)chatInputView tapImageButton:(UIButton *)button;
@end

@interface HZChatInputView : UIView
//TextView
@property (nonatomic,assign) int maxTextHeight;
@property (nonatomic,copy)   NSString  *text;
@property (nonatomic,assign) UIEdgeInsets textInsets;
@property (nonatomic,assign) CGFloat   textViewCornerRadius;
@property (nonatomic,strong) UIColor   *textViewBackgroundColor;
@property (nonatomic,strong) UIFont    *inputTextFont;
@property (nonatomic,copy)   NSString  *placeholderText;
@property (nonatomic,strong) UIColor   *placeholderColor;
//sendbutton
@property (nonatomic,strong) UIColor    *sendButtonNormalColor;
@property (nonatomic,strong) UIColor    *sendButtonDisableColor;
@property (nonatomic,assign) CGFloat    sendButtonCornerRadius;

@property (nonatomic,weak) id<HZChatInputViewDelegate> delegate;

+ (HZChatInputView *)addFromChatView:(UIView *)chatView;

@end

