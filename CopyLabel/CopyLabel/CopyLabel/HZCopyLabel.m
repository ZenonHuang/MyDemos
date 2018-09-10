//
//  HZCopyLabel.m
//  CopyLabel
//
//  Created by mewe on 2018/9/10.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "HZCopyLabel.h"

@interface HZCopyLabel ()

@end

@implementation HZCopyLabel

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyText:)) {
        return YES;
    }
    return NO;
}

- (void)copyText:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    [pboard setString:self.text];
}

- (void)attachLongTapHandler
{
    [self setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
    [self addGestureRecognizer:longPress];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self attachLongTapHandler];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self attachLongTapHandler];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachLongTapHandler];
    }
    return self;
}


- (void)handleLongTap:(UILongPressGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[copyMenuItem]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

@end

