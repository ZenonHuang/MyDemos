//
//  HZEditorProfileViewController+HZBrowserViewController.m
//  gosparkchat
//
//  Created by ZenonHuang on 2017/1/18.
//  Copyright © 2017年 gospark. All rights reserved.
//

#import "HZBrowserViewController.h"
#import "HZBrowserCell.h"
#import "Masonry.h"


#define angelToRandian(x)  ((x)/180.0*M_PI)


//设备的宽高
#define SCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif



static NSString *const pictureCellIdentifier = @"pictureCollectionCellId";
static NSString *const plusCellIdentifier = @"plusCellIdentifier";

@interface HZBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,
                                        UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,readwrite,strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic,readwrite,strong) UICollectionView *broswerCollectionView;
@property (nonatomic,readwrite,strong) NSArray          *pictureArray;
@property (nonatomic,readwrite,strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic,readwrite,strong) UIView *mappingImageCell;         //拖动cell的截图
@property (nonatomic,readwrite,assign) BOOL  shakeWhenMoving;
@end

@interface HZBrowserViewController ()
@property (nonatomic,readwrite,strong) UIImage          *uploadImage;
@end


@implementation HZBrowserViewController
#pragma mark - life cycle
-(void)viewDidLoad{
    [super viewDidLoad];

    self.navigationItem.title=@"album";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.broswerCollectionView];
    [self.broswerCollectionView addGestureRecognizer:self.longPressGesture];
#warning TODO 进入晃动模式时，可以直接pan手势拖拽图标，不需要长按触发
    self.navigationItem.rightBarButtonItem=self.rightBarButtonItem;
    
}

#pragma mark - private
- (void)hz_shakeAllCell{
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.rotation";
    anim.values=@[@(angelToRandian(-1)),@(angelToRandian(1)),@(angelToRandian(-1))];
    anim.repeatCount=MAXFLOAT;
    anim.duration=0.2;
    NSArray *cells = [self.broswerCollectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        if ([cell isKindOfClass:[HZBrowserCell class]]) {
            HZBrowserCell *browserCell=( HZBrowserCell *)cell;
            [browserCell showDelete:YES];
            /**如果加了shake动画就不用再加了*/
            if (![cell.layer animationForKey:@"shake"]) {
                [cell.layer addAnimation:anim forKey:@"shake"];
            }
        }
    }
    
    if (![self.mappingImageCell.layer animationForKey:@"shake"]) {
        [self.mappingImageCell.layer addAnimation:anim forKey:@"shake"];
    }
}

- (void)hz_stopShakeAllCell{
    //    if (!_shakeWhenMoveing || _editing) {
    //        return;
    //    }
    if (self.shakeWhenMoving) {
        NSArray *cells = [self.broswerCollectionView visibleCells];
        for (UICollectionViewCell *cell in cells) {
            [cell.layer removeAllAnimations];
            if ([cell isKindOfClass:[HZBrowserCell class]]) {
                HZBrowserCell *browserCell=( HZBrowserCell *)cell;
                [browserCell showDelete:NO];
            }
        }
        [self.mappingImageCell.layer removeAllAnimations];
        
        self.shakeWhenMoving=NO;
    }
    
}
#pragma mark - Action
-(void)handleLongGesture:(UILongPressGestureRecognizer *)gesture{
    
    CGPoint point=[gesture locationInView:self.broswerCollectionView];
    NSIndexPath *indexPath =[self.broswerCollectionView indexPathForItemAtPoint:point];
    if (indexPath.row==self.pictureArray.count) {//添加相机cell
        return;
    }
    
    
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.shakeWhenMoving=YES;
            if (indexPath) {
                [self.broswerCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            
            UICollectionViewCell *cell=(UICollectionViewCell *)[self.broswerCollectionView
                                                                dequeueReusableCellWithReuseIdentifier:pictureCellIdentifier
                                                                                          forIndexPath:indexPath];
            
            /** 截图 **/
            UIView* cellView = [cell snapshotViewAfterScreenUpdates:YES];
            cellView.center = cell.center;
            
            self.mappingImageCell = UIViewContentModeScaleToFill;
            self.mappingImageCell = cellView;
            
            CGRect rect=cellView.frame;
            self.mappingImageCell.frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.2, rect.size.height*1.2);

            
            
            cell.hidden = YES;
            [self.broswerCollectionView addSubview:self.mappingImageCell];
            
            [self hz_shakeAllCell];
        }
        case UIGestureRecognizerStateChanged:
        {
            self.shakeWhenMoving=YES;
            /** 更新cell的位置 **/
            self.mappingImageCell.center = point;
            CGRect rect=self.mappingImageCell.frame;
            self.mappingImageCell.frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.2, rect.size.height*1.2);

            
            [self.broswerCollectionView updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            //            self.shakeWhenMoving=NO;
            UICollectionViewCell *cell = [self.broswerCollectionView cellForItemAtIndexPath:indexPath];
            self.mappingImageCell.center = cell.center;
            
            [self.mappingImageCell removeFromSuperview];
            cell.hidden           = NO;
            self.mappingImageCell = nil;
            
            [self.broswerCollectionView endInteractiveMovement];
            //            [self hz_stopShakeAllCell];
            //            [self hz_shakeAllCell];
            break;
        }
        default:
        {
            //            self.shakeWhenMoving=NO;
            [self.broswerCollectionView cancelInteractiveMovement];
            break;
        }
    }
    
    
}

#pragma mark 保存按钮 点击事件
-(void)onRightNavButtonTapped:(UIBarButtonItem *)sender event:(UIEvent *)event{
    //    self.shakeWhenMoving=NO;
    [self hz_stopShakeAllCell];
    
//    self.uploadAPI.imgs= self.pictureArray;
   
    
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictureArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.pictureArray.count) {//假如为相册，为最后一个添加照片的Cell
        UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView
                                                            dequeueReusableCellWithReuseIdentifier:plusCellIdentifier
                                                            forIndexPath:indexPath];
        UIImageView *pictureView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_service_img"]];
        
        [cell.contentView addSubview:pictureView];
        [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.and.left.right.equalTo(cell.contentView);
        }];
        return cell;
    }
    
    HZBrowserCell *cell=(HZBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:pictureCellIdentifier
                                                                                   forIndexPath:indexPath];
    
    [cell setupImageUrl:self.pictureArray[indexPath.row]];
    [cell showDelete:NO];
    @weakify(self);
    
    [cell setCellHandler:^(NSString *desc) {
        @strongify(self);
        NSMutableArray *mutList=[NSMutableArray arrayWithArray:self.pictureArray];
        [mutList removeObjectAtIndex:indexPath.row];
        self.pictureArray=[mutList copy];
        [self.broswerCollectionView reloadData];
        
    }];
    
    
    if (!self.shakeWhenMoving) {
        return cell;
    }
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.rotation";
    anim.values=@[@(angelToRandian(-1)),@(angelToRandian(1)),@(angelToRandian(-1))];
    anim.repeatCount=MAXFLOAT;
    anim.duration=0.2;
    
    [cell showDelete:YES];
    
    /**如果加了shake动画就不用再加了*/
    if (![cell.layer animationForKey:@"shake"]) {
        [cell.layer addAnimation:anim forKey:@"shake"];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView 
  moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath 
          toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSMutableArray *mutList =[NSMutableArray arrayWithArray:self.pictureArray];
    
    [mutList exchangeObjectAtIndex:destinationIndexPath.item 
                 withObjectAtIndex:sourceIndexPath.item ];
    
    self.pictureArray=[mutList copy];
    
    
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.pictureArray.count) {
        
        if (self.pictureArray.count>=9) {
//            [self hz_showAlertWithTitle:nil message:@"图片不能超过9张"];
            return;
        }        
        // 判断当前的sourceType是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *pickerVC  = [[UIImagePickerController alloc] init];
            pickerVC.allowsEditing = NO;
            // 设置资源来源（相册、相机、图库之一）
            pickerVC.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            pickerVC.delegate=self;
            
            [self presentViewController:pickerVC animated:YES completion:nil];
        }
        
        return;
    }
    

   
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    UIImage *image=info[UIImagePickerControllerOriginalImage];
  
}



#pragma mark - setter


#pragma mark - getter
-(UICollectionView *)broswerCollectionView{
    if (!_broswerCollectionView) {
        
        
        UICollectionViewFlowLayout *layout=[UICollectionViewFlowLayout new];
        layout.itemSize=CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
        layout.minimumLineSpacing=0;
        layout.minimumInteritemSpacing=0;
        
        _broswerCollectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        
        _broswerCollectionView.delegate=self;
        _broswerCollectionView.dataSource=self;
        
        _broswerCollectionView.alwaysBounceHorizontal=NO;
        
        
        [_broswerCollectionView registerClass:[HZBrowserCell class]
                   forCellWithReuseIdentifier:pictureCellIdentifier];
        [_broswerCollectionView registerClass:[UICollectionViewCell class]
                   forCellWithReuseIdentifier:plusCellIdentifier];
    }
    return _broswerCollectionView;
}

-(NSArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray=@[@"",@""];
    }
    return _pictureArray;
}



-(UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    }
    return _longPressGesture;
}

-(UIBarButtonItem *)rightBarButtonItem{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"save"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self 
                                                            action:@selector(onRightNavButtonTapped:event:)];

    }
    return _rightBarButtonItem;
}
@end
