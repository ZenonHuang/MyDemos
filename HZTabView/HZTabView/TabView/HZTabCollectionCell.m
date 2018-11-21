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
@end

@implementation HZTabCollectionCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.titleLabel];
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
   
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(size.width, MAXFLOAT)];;
    CGFloat titleHeight = titleSize.height;
    
    self.titleLabel.frame = CGRectMake(0, (size.height - titleHeight)/2, size.width, titleHeight);

}

#pragma mark - private

- (void)configureSelected:(BOOL)isSelected{
    if (isSelected) {
        self.titleLabel.textColor = [self.dataSource hz_tabCellSelectedTextColor];
        self.titleLabel.font      = [self.dataSource hz_tabCellSelectedFont];
        return;
    }
    
    self.titleLabel.textColor = [self.dataSource hz_tabCellNormalTextColor];
    self.titleLabel.font      = [self.dataSource hz_tabCellNormalFont];
}

#pragma mark - setter
- (void)setModel:(HZTabModel *)model{
    NSAssert([model isKindOfClass:[HZTabModel class]], @"检查传入的 model 类型");
    _model = model;
    self.titleLabel.text = model.title;
    [self configureSelected:model.selected];
    [self layoutSubviews];
}

#pragma mark - getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [self.dataSource hz_tabCellNormalFont];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
