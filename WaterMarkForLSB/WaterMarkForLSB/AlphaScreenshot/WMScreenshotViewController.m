//
//  WMScreenshotViewController.m
//  WaterMarkForLSB
//
//  Created by zz go on 2021/1/17.
//

#import "WMScreenshotViewController.h"

@interface WMScreenshotViewController () 
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIButton *randomColorButton;
@property (nonatomic,strong) UIButton *resetButton;

@property (nonatomic,strong) UIButton *pngButton;
@property (nonatomic,strong) UIButton *jpegButton;

@end


@implementation WMScreenshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat imageY = 40;
    self.imageView.frame = CGRectMake(0,imageY , viewWidth, viewWidth);
   
    
    CGFloat space = 10;
    CGSize  buttonSize = CGSizeMake(100, 35);
    CGFloat buttonW = buttonSize.width;
    CGFloat buttonH = buttonSize.height;
    
    CGFloat resetuBtnY = CGRectGetMaxY(self.imageView.frame) + space;
    self.resetButton = [self createButton:@"透明背景色" frame:CGRectMake(0, resetuBtnY , buttonW,buttonH)];
    
    CGFloat randomBtnY = CGRectGetMaxY(self.resetButton.frame) + space;
    self.randomColorButton = [self createButton:@"随机背景色" frame:CGRectMake(0, randomBtnY, buttonW, buttonH)];
    
    CGFloat pngBtnY =  CGRectGetMaxY(self.randomColorButton.frame) + space;
    self.pngButton = [self createButton:@"png截图并保存至相册" frame:CGRectMake(0, pngBtnY, 2*buttonW, buttonH)];
    
    CGFloat jpegBtnY =  CGRectGetMaxY(self.pngButton.frame) + space;
    self.jpegButton = [self createButton:@"jpeg截图并保存至相册" frame:CGRectMake(0, jpegBtnY, 2*buttonW, buttonH)];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.resetButton];
    [self.view addSubview:self.randomColorButton];
    [self.view addSubview:self.pngButton];
    [self.view addSubview:self.jpegButton];
     
}


#pragma mark - private
- (void)tapButtonAction:(UIButton *)sender
{
    if (self.resetButton==sender) {
        
        self.imageView.backgroundColor = nil;
        return;
    }
    
    if (self.randomColorButton==sender) {
        
        NSArray *colorList = @[[UIColor redColor],[UIColor orangeColor],[UIColor greenColor]];
        NSUInteger colorIndex = arc4random() % colorList.count; 
        self.imageView.backgroundColor =[colorList objectAtIndex:colorIndex];
        return;
    }
    
    if (self.pngButton==sender) {
        
        [self savePNGImage];
        return;
    }
    
    if (self.jpegButton==sender) {
        
        [self saveJPEGImage];
        return;
    }
}

- (UIImage *)screenshotForJPEG
{
    NSData *jpegImageData = UIImageJPEGRepresentation([self screenshotImage], 0.9);
    
    UIImage *jpegImage = [[UIImage alloc] initWithData:jpegImageData];
    
    return jpegImage;
    
}

- (UIImage *)screenshotForPNG
{
    NSData *pngImageData = UIImagePNGRepresentation([self screenshotImage]);
    
    UIImage *pngImage = [[UIImage alloc] initWithData:pngImageData];
    
    return pngImage;
    
}

- (UIImage *)screenshotImage
{
    UIView *view = self.imageView;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO,[UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveJPEGImage {
    
    UIImage *cardImage = [self screenshotForJPEG];
    
    UIImageWriteToSavedPhotosAlbum(cardImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)savePNGImage {
    
    UIImage *cardImage = [self screenshotForPNG];
    
    UIImageWriteToSavedPhotosAlbum(cardImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = @"";
    if(error != NULL){
        msg = @"保存失败" ;
    }else{
        msg = @"已保存到相册";
    }
    NSLog(@"%@", msg);
}

- (UIButton *)createButton:(NSString *)title frame:(CGRect)frame
{
    UIButton *button = [UIButton new];
    button.frame = frame;
    button.backgroundColor = [UIColor blueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self 
               action:@selector(tapButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"demo2"];
        
    }
    return _imageView;
}

@end
