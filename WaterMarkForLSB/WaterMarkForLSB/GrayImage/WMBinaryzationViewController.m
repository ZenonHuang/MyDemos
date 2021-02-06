//
//  WMBinaryzationViewController.m
//  WaterMarkForLSB
//
//  Created by zz go on 2021/2/5.
//

#import "WMBinaryzationViewController.h"
#import "UIImage+Gray.h"

@interface WMBinaryzationViewController () 
@property (nonatomic,strong) UIImage *oringinImage;
@property (nonatomic,strong) UIImageView *binaryzationImageView;
@property (nonatomic,strong) UIImageView *oringinImageView;
@property (nonatomic,strong) UILabel *valueLabel;
@end


@implementation WMBinaryzationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat imageWidth  = 318;
    CGFloat imageHeight = 225;
    CGFloat imageY = 80;
    CGFloat imageX = (viewWidth-imageWidth)/2;
    CGFloat space = 10;
    
    self.binaryzationImageView.frame = CGRectMake(imageX,imageY , imageWidth, imageHeight);
   

    CGFloat binaryzationY = CGRectGetMaxY(self.binaryzationImageView.frame) + space;
    [self.view addSubview:self.binaryzationImageView];
    
    {// 滑动条slider  
        CGFloat sliderW = 240;
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((viewWidth - sliderW) / 2, binaryzationY + space,sliderW , 20)];  
        slider.minimumValue = 0;// 设置最小值  
        slider.maximumValue = 1;// 设置最大值  
        slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值  
        slider.continuous = YES;// 设置可连续变化  
        //    slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示  
        //    slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示  
        //    slider.thumbTintColor = [UIColor redColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示  
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法  
        [self.view addSubview:slider];  
        // 当前值label  
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth - 100) / 2, slider.frame.origin.y + 30, 100, 20)];  
        self.valueLabel.textAlignment = NSTextAlignmentCenter;  
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f", slider.value];  
        [self.view addSubview:self.valueLabel];  
        
        // 最小值label  
        UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x - 35, slider.frame.origin.y, 30, 20)];  
        minLabel.textAlignment = NSTextAlignmentRight;  
        minLabel.text = [NSString stringWithFormat:@"%.1f", slider.minimumValue];  
        [self.view addSubview:minLabel];  
        
        // 最大值label  
        UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x + slider.frame.size.width + 5, slider.frame.origin.y, 30, 20)];  
        maxLabel.textAlignment = NSTextAlignmentLeft;  
        maxLabel.text = [NSString stringWithFormat:@"%.1f", slider.maximumValue];  
        [self.view addSubview:maxLabel]; 
    }
     
    CGFloat oringinY = CGRectGetMaxY(self.valueLabel .frame) + 3*space;
    self.oringinImageView.frame = CGRectMake(imageX,oringinY , imageWidth, imageHeight);
    [self.view addSubview:self.oringinImageView];
}


#pragma mark - private

// slider变动时改变label值  
- (void)sliderValueChanged:(id)sender {  
    UISlider *slider = (UISlider *)sender;  
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f", slider.value];  
    
    self.binaryzationImageView.image = [self.oringinImage covertToBinaryzation:self.valueLabel.text.floatValue];
}  

#pragma mark - getter
- (UIImageView *)binaryzationImageView
{
    if (!_binaryzationImageView) {
        _binaryzationImageView = [UIImageView new];
        _binaryzationImageView.image = self.oringinImage;
        
    }
    return _binaryzationImageView;
}

- (UIImage *)oringinImage
{
    if (!_oringinImage) {
//        NSBundle *bundle = [NSBundle mainBundle];
//        NSString *resourcePath = [bundle resourcePath];
//        NSString *filePath = [resourcePath stringByAppendingPathComponent:@"IMG_0329.JPG"];
//        _oringinImage = [UIImage imageWithContentsOfFile:filePath];
        _oringinImage = [UIImage imageNamed:@"yangchaoyue2"];
    }
  
    return _oringinImage;
}

- (UIImageView *)oringinImageView
{
    if (!_oringinImageView) {
        _oringinImageView = [UIImageView new];
        _oringinImageView.image = self.oringinImage;
        
    }
    return _oringinImageView;
}

@end


