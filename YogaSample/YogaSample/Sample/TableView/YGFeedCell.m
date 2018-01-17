//
//  YGFeedView.m
//  YogaSample
//
//  Created by mewe on 2018/1/2.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import "YGFeedCell.h"
#import "UIView+Yoga.h"


@interface YGFeedView ()
@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *contentLabel;
@property (nonatomic, strong)  UIImageView *contentImageView;
@property (nonatomic, strong)  UILabel *usernameLabel;
@property (nonatomic, strong)  UILabel *timeLabel;
@end

@implementation YGFeedView

- (instancetype)initWithData:(YGFeedEntity *)entity{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configData:entity];
        [self layoutView];
    }
    
    return self;
}

- (void)configData:(YGFeedEntity *)entity{
    
    _titleLabel = [UILabel new];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    
    _contentImageView = [UIImageView new];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _usernameLabel = [UILabel new];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    _contentLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    if (entity.imageName.length>0) {
          _contentImageView.image = [UIImage imageNamed:entity.imageName];
    }
  
    
    _usernameLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.username attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    _timeLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.time attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    

}

- (void)layoutView {
    

  YGLayoutConfigurationBlock marginWrapConfigureBlock  = ^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.marginTop = 10;
        layout.marginLeft= layout.marginRight = layout.marginBottom  = 0;
        layout.flexWrap  = YGWrapWrap;
    } ; 
    
    [_titleLabel configureLayoutWithBlock:marginWrapConfigureBlock];
    _titleLabel.yoga.marginLeft = 10;
    
    [_contentLabel configureLayoutWithBlock:marginWrapConfigureBlock];
     _contentLabel.yoga.marginLeft = 10;
    
    [_contentImageView configureLayoutWithBlock:marginWrapConfigureBlock];
    _contentImageView.yoga.maxHeight = 150;
    

    YGLayoutConfigurationBlock growWrapConfigureBlock  = ^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexGrow  = 1.0;
        layout.flexWrap  = YGWrapWrap;
    } ;
    
    [_usernameLabel configureLayoutWithBlock:growWrapConfigureBlock];
    _usernameLabel.yoga.marginLeft = 10;
    
    [_timeLabel configureLayoutWithBlock:growWrapConfigureBlock];
    _timeLabel.yoga.marginRight = 10;

    UIView *div = [[UIView alloc] init];
    [div configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled      = YES;
        layout.flexDirection  = YGFlexDirectionRow;
        layout.justifyContent = YGJustifySpaceBetween;
        layout.alignItems     = YGAlignCenter;

        layout.marginTop      = 10;
        layout.marginBottom   = 10;
    }];

    [self addSubview:_titleLabel];
    [self addSubview:_contentLabel];
    [self addSubview:_contentImageView];

    [div addSubview:_usernameLabel];
    [div addSubview:_timeLabel];

    [self addSubview:div];

    [self configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled     = YES;
        layout.width      = [UIScreen mainScreen].bounds.size.width;
        layout.flexGrow   = 1.0;
    }];
 
    [self.yoga applyLayoutPreservingOrigin:YES];
    
}

@end


@interface YGFeedCell ()
@property (nonatomic, strong)  UILabel *titleLabel;
@end


@implementation YGFeedCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }

    [self.contentView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled     = YES;
        layout.flexDirection = YGFlexDirectionColumn;
//        layout.alignContent  = YGAlignCenter;
        layout.flexWrap      = YGWrapWrap;
    }];
  
    return self;
}

- (void)configureFeedView:(YGFeedView *)feedView{

    //delete old
    for (UIView *sub in self.contentView.subviews) {
        if ([sub isKindOfClass:[YGFeedView class]]) {
            [sub removeFromSuperview];
        }
    }
    
    //setup new
    if (feedView.superview) {
        UIView *superView = feedView.superview;
        [feedView removeFromSuperview];
        //superview 重新计算，避免仍持有 feedview 布局
        [superView.yoga applyLayoutPreservingOrigin:YES];
    }


    [self.contentView     addSubview:feedView];
    [self.contentView.yoga applyLayoutPreservingOrigin:YES];

}

@end
