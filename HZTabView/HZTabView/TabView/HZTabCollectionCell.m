//
//  HZTabCollectionCell.m
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import "HZTabCollectionCell.h"

@interface HZTabCollectionCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView  *indicatorView;
@end

@implementation HZTabCollectionCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.indicatorView];
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat titleHeight = 20;
    self.titleLabel.frame = CGRectMake(0, (size.height - titleHeight)/2, size.width, titleHeight);
    
    CGFloat height = 2;
    self.indicatorView.frame = CGRectMake(0, size.height-height, size.width, height);
}

#pragma mark - private

- (void)configureSelected:(BOOL)isSelected{
    if (isSelected) {
        self.titleLabel.textColor = [UIColor grayColor];
        self.indicatorView.backgroundColor = [UIColor clearColor];
        return;
    }
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.indicatorView.backgroundColor = [UIColor redColor];
}

#pragma mark - setter
- (void)setModel:(HZTabModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self configureSelected:model.selected];
}

#pragma mark - getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
    }
    return _titleLabel;
}

- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        
    }
    return _titleLabel;
}

@end
