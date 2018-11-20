//
//  HZTabView.m
//  HZTabView
//
//  Created by ZenonHuang on 2018/11/19.
//  Copyright © 2018年 ZenonHuang. All rights reserved.
//

#import "HZTabView.h"
#import "HZTabCollectionCell.h"

static NSString *tabCellID = @"tabCellID";

@interface HZTabView ()<UICollectionViewDelegate,UICollectionViewDataSource,HZTabCollectionCellDataSource>
@property (nonatomic,strong) UICollectionView *titleCollectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) CGFloat itemWidth;
@end

@implementation HZTabView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    
    [self addSubview:self.lineView];
    [self addSubview:self.titleCollectionView];
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    self.titleCollectionView.frame = CGRectMake(0, 0, size.width, size.height);

    [self moveLineView];
}

#pragma mark - private
- (void)moveLineView{
    CGSize size = self.bounds.size;
    
    CGFloat height = self.lineHeight==0 ? 2 : self.lineHeight;

    CGFloat lineX = self.currentSelectedIndex*self.itemWidth;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.lineStyle == HZTabViewLineStyleDefault) {
               self.lineView.frame = CGRectMake(lineX, size.height-height, self.itemWidth, height);
        }
        
        if (self.lineStyle == HZTabViewLineStyleBackground) {
            self.lineView.frame = CGRectMake(lineX, 0, self.itemWidth, size.height);
        }
        
    }];
 
}

#pragma mark - public
- (void)reloadData{
    [self.titleCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.titleList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HZTabCollectionCell *tabCell = [collectionView dequeueReusableCellWithReuseIdentifier:tabCellID
                                                                             forIndexPath:indexPath];
    tabCell.dataSource = self;
    if (indexPath.row>self.titleList.count) {
        NSAssert(NO, @"indexPat.row error -- 检查数据源");
        return tabCell;
    }
    
    HZTabModel *model = [self.titleList objectAtIndex:indexPath.row];
    model.selected = (self.currentSelectedIndex==indexPath.item);
    tabCell.model = model;
    
    return tabCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.currentSelectedIndex==indexPath.item) {
        return;
    }
    
    if (indexPath.row>self.titleList.count) {
        NSAssert(NO, @"indexPat.row error -- 检查数据源");
    }
    
    
    //取消之前选择
    HZTabModel *preModel = [self.titleList objectAtIndex:self.currentSelectedIndex];
    preModel.selected = NO;
    HZTabCollectionCell *preCell = (HZTabCollectionCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectedIndex inSection:0]];
    preCell.model = preModel;
    
    //设置当前选中
    HZTabModel *model = [self.titleList objectAtIndex:indexPath.row];
    model.selected = YES;
    HZTabCollectionCell *cell = (HZTabCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.model = model;
    
    //更新当前 index
    self.currentSelectedIndex = indexPath.item;
    
    [self moveLineView];
    
    if ([self.delegate respondsToSelector:@selector(hz_tabView:didSelected:)]) {
        [self.delegate hz_tabView:self didSelected:self.currentSelectedIndex];
    }

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger count = self.titleList.count;
    
    if (count>0) {
        return CGSizeMake(self.bounds.size.width/count, 40);
    }
    
    return CGSizeZero;
}

#pragma mark HZTabCollectionCellDataSource

- (UIColor *)hz_tabCellNormalTextColor{
    if (!self.normalTextColor) {
        return [UIColor blackColor];
    }
    return self.normalTextColor;
}

- (UIColor *)hz_tabCellSelectedTextColor{
    if (!self.selectedTextColor) {
        return [UIColor redColor];
    }
    return self.selectedTextColor;
}


#pragma mark - setter
- (void)setLineColor:(UIColor *)lineColor{
    self.lineView.backgroundColor = lineColor;
}

#pragma mark - getter
- (NSArray *)titleList{
    if (!_titleList) {
        _titleList = [[NSArray array] init];
    }
    return _titleList;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置UICollectionView为横向滚动
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 每一行cell之间的间距
        _flowLayout.minimumLineSpacing = 0;
        // 每一列cell之间的间距
        // flowLayout.minimumInteritemSpacing = 10;
        // 设置第一个cell和最后一个cell,与父控件之间的间距
//        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        
        //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
        //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
    }
    return _flowLayout;
}

- (UICollectionView *)titleCollectionView{
    if (!_titleCollectionView) {
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                  collectionViewLayout:self.flowLayout];
        _titleCollectionView.backgroundColor = [UIColor clearColor];
        _titleCollectionView.delegate = self;
        _titleCollectionView.dataSource = self;
        [_titleCollectionView registerClass:[HZTabCollectionCell class]
                 forCellWithReuseIdentifier:tabCellID];
    }
    return _titleCollectionView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
}

- (CGFloat)itemWidth{
   NSUInteger count = self.titleList.count;
    
    if (count>0) {
        return self.bounds.size.width/count;
    }
    
    return 0;
}
@end
