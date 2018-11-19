//
//  HZTabView.m
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import "HZTabView.h"
#import "HZTabCollectionCell.h"

@interface HZTabView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *titleCollectionView;
@end

@implementation HZTabView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self addSubview:self.titleCollectionView];

    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    self.titleCollectionView.frame = CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.titleList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HZTabCollectionCell *tabCell = [[HZTabCollectionCell alloc] init];
    if (indexPath.row>self.titleList.count) {
        NSAssert(NO, @"indexPat.row error -- 检查数据源");
        return tabCell;
    }
    
    HZTabModel *model = [self.titleList objectAtIndex:indexPath.row];
    tabCell.model = model;
    
    return tabCell;
}

#

#pragma mark - getter
- (NSArray *)titleList{
    if (!_titleList) {
        _titleList = [[NSArray array] init];
    }
    return _titleList;
}

- (UICollectionView *)titleCollectionView{
    if (!_titleCollectionView) {
        _titleCollectionView = [[UICollectionView alloc] init];
        _titleCollectionView.delegate = self;
        _titleCollectionView.dataSource = self;
    }
    return _titleCollectionView;
}

@end
