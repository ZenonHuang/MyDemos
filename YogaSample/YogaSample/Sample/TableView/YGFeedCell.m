//
//  YGFeedView.m
//  YogaSample
//
//  Created by mewe on 2018/1/2.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

#import "YGFeedCell.h"
#import "UIView+Yoga.h"

@interface YGFeedView : UIView

@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *contentLabel;
@property (nonatomic, strong)  UIImageView *contentImageView;
@property (nonatomic, strong)  UILabel *usernameLabel;
@property (nonatomic, strong)  UILabel *timeLabel;
@property (nonatomic, strong)  UIView  *bottomDiv;
@end

@implementation YGFeedView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
         _titleLabel = [UILabel new];
        
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        
        _contentImageView = [UIImageView new];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        _usernameLabel = [UILabel new];
        
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_titleLabel];
        [self addSubview:_contentLabel];
        [self addSubview:_contentImageView];
        
        self.bottomDiv = [[UIView alloc] init];
  
        [self.bottomDiv addSubview:_usernameLabel];
        [self.bottomDiv addSubview:_timeLabel];
        
        [self addSubview:self.bottomDiv];
        
   
    }
    
    return self;
}

- (void)configData:(YGFeedEntity *)entity{

    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    _contentLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    if (entity.imageName.length>0) {
        _contentImageView.yoga.display = YGDisplayFlex;
        _contentImageView.image = [UIImage imageNamed:entity.imageName];
    
    }else{
          _contentImageView.image = nil;
        _contentImageView.yoga.display = YGDisplayNone;
    }
  
    
    _usernameLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.username attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    _timeLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.time attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    [self layoutView];
    
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

    YGLayoutConfigurationBlock growWrapConfigureBlock  = ^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexGrow  = 1.0;
        layout.flexWrap  = YGWrapWrap;
    } ;
    
    [_usernameLabel configureLayoutWithBlock:growWrapConfigureBlock];
    _usernameLabel.yoga.marginLeft = 10;
    
    [_timeLabel configureLayoutWithBlock:growWrapConfigureBlock];
    _timeLabel.yoga.marginRight = 10;

   
    
    [self.bottomDiv configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled      = YES;
        layout.flexDirection  = YGFlexDirectionRow;
        layout.justifyContent = YGJustifySpaceBetween;
        layout.alignItems     = YGAlignCenter;
        
        layout.marginTop      = 10;
        layout.marginBottom   = 10;
    }];
    

    [self configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled     = YES;
        layout.width      = [UIScreen mainScreen].bounds.size.width;
        layout.flexGrow   = 1.0;
    }];
 
    [self.yoga applyLayoutPreservingOrigin:YES];
    
}

@end


@interface YGFeedCell ()
@property (nonatomic, strong) YGFeedView *feedView;
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
    
    [self.contentView addSubview:self.feedView];

    [self.contentView.yoga applyLayoutPreservingOrigin:YES];
    return self;
}

- (void)configureData:(YGFeedEntity *)entity{
    
    [self.feedView configData:entity];

    [self.contentView.yoga applyLayoutPreservingOrigin:YES]; 
    
}

- (YGFeedView *)feedView{
    if (!_feedView) {
        _feedView = [[YGFeedView alloc] init];
    }
    return _feedView;
}

@end

@implementation  UITableView (TemplateCell)
- (CGFloat)heightForData:(YGFeedEntity *)entity cellIdentifier:(NSString *)identifier{
    
    YGFeedCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    [cell prepareForReuse];
    

    [cell configureData:entity];
    
    return cell.contentView.yoga.intrinsicSize.height;
}
@end
