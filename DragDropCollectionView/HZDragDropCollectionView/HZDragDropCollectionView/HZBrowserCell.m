//
//  HZBrowserCell.m
//  gosparkchat
//
//  Created by zz go on 2017/1/21.
//  Copyright © 2017年 gospark. All rights reserved.
//

#import "Masonry.h"
#import "HZBrowserCell.h"


@interface HZBrowserCell ()
@property (nonatomic,readwrite,strong) UIImageView *photoView;
@property (nonatomic,readwrite,strong) UIButton    *deleteButton;
@end


@implementation HZBrowserCell
#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self.contentView addSubview:self.photoView];

    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}

#pragma mark - Action
-(void)touchDeleteButton{
    !self.cellHandler?:self.cellHandler(@"");
}

#pragma mark - Public
- (void)setupImageUrl:(NSString *)urlString 
{
    [self.photoView setImage:[UIImage imageNamed:@"test"]];
}

- (void)showDelete:(BOOL)isShow{
    if (isShow) {
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photoView).offset(-5);
            make.right.equalTo(self.photoView).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.left.top.equalTo(self.contentView).offset(10);
            make.right.bottom.equalTo(self.contentView).offset(-10);
        }];
    }else{
        [self.deleteButton removeFromSuperview];
        [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.left.right.and.top.bottom.equalTo(self.contentView);
        }];
    }

}
#pragma mark - setter/getter
-(void)setCellHandler:(HZBrowserHandler)cellHandler{
    _cellHandler=cellHandler;
}

- (UIImageView *)photoView
{
    if (!_photoView) {
        _photoView = [UIImageView new];
    }
    return _photoView;
}

-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton=[UIButton new];
        [_deleteButton setTitle:@"x" forState:UIControlStateNormal];
        [_deleteButton setBackgroundColor:[UIColor redColor]];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self  
                          action:@selector(touchDeleteButton) 
                forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.layer.cornerRadius=30/2;
    }
    return _deleteButton;
}
@end
