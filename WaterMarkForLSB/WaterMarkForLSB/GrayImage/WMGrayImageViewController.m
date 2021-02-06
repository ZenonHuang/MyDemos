//
//  WMGrayImageViewController.m
//  WaterMarkForLSB
//
//  Created by zz go on 2021/2/4.
//

#import "WMGrayImageViewController.h"
#import "UIImage+Gray.h"

@interface WMGrayImageViewController () 
@property (nonatomic,strong) UIImageView *originImageView;

@property (nonatomic,strong) UIButton *maxButton;
@property (nonatomic,strong) UIButton *averageButton;

@property (nonatomic,strong) UIButton *WeightedAverageButton;

@property (nonatomic,strong) UIButton *redButton;
@property (nonatomic,strong) UIButton *greenButton;
@property (nonatomic,strong) UIButton *blueButton;

@end


@implementation WMGrayImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat imageWidth = 277;
    CGFloat imageY = 80;
    CGFloat viewWidth = self.view.bounds.size.width;
    self.originImageView.frame = CGRectMake((viewWidth-imageWidth)/2,imageY , imageWidth, 219.5);
   
    
    CGFloat space = 10;
    CGSize  buttonSize = CGSizeMake(100, 35);
    CGFloat buttonW = buttonSize.width;
    CGFloat buttonH = buttonSize.height;
    
    CGFloat averageBtnY = CGRectGetMaxY(self.originImageView.frame) + space;
    self.averageButton = [self createButton:@"平均值" frame:CGRectMake(0, averageBtnY , buttonW,buttonH)];
    
    CGFloat maxBtnY = CGRectGetMaxY(self.averageButton.frame) + space;
    self.maxButton = [self createButton:@"最大值" frame:CGRectMake(0, maxBtnY, buttonW, buttonH)];
    
    CGFloat weighteBtnY =  CGRectGetMaxY(self.maxButton.frame) + space;
    self.WeightedAverageButton = [self createButton:@"加权平均值" frame:CGRectMake(0, weighteBtnY, 2*buttonW, buttonH)];
    
    CGFloat redBtnY =  CGRectGetMaxY(self.WeightedAverageButton.frame) + space;
    self.redButton = [self createButton:@"分量法-R" frame:CGRectMake(0, redBtnY, 2*buttonW, buttonH)];
    
    CGFloat greenButtonY =  CGRectGetMaxY(self.redButton.frame) + space;
    self.greenButton = [self createButton:@"分量法-G" frame:CGRectMake(0, greenButtonY, 2*buttonW, buttonH)];
    
    CGFloat blueButtonY =  CGRectGetMaxY(self.greenButton.frame) + space;
    self.blueButton = [self createButton:@"分量法-B" frame:CGRectMake(0, blueButtonY, 2*buttonW, buttonH)];
    
    [self.view addSubview:self.originImageView];
    [self.view addSubview:self.averageButton];
    [self.view addSubview:self.maxButton];
    [self.view addSubview:self.WeightedAverageButton];
    [self.view addSubview:self.redButton];
    [self.view addSubview:self.greenButton];
    [self.view addSubview:self.blueButton];
     
}


#pragma mark - private
- (void)tapButtonAction:(UIButton *)sender
{
    UIImage *image = [UIImage imageNamed:@"yangchaoyue"];
    if (self.averageButton==sender) {
        
        self.originImageView.image = [UIImage grayForImage:image forType:GrayImageTypeAverage];
        return;
    }
    
    if (self.maxButton==sender) {
        
        self.originImageView.image = [UIImage grayForImage:image forType:GrayImageTypeMax];
        return;
    }
    
    if (self.WeightedAverageButton==sender) {
        
        self.originImageView.image = [UIImage grayForImage:image forType:GrayImageTypeWeightedAverage];
        return;
    }
    
    if (self.redButton==sender) {
        
        self.originImageView.image = [UIImage grayForImage:image forType:GrayImageTypeRed];
        return;
    }
    if (self.greenButton==sender) {
        
        self.originImageView.image = [UIImage grayForImage:image forType:GrayImageTypeGreen];
        return;
    }
    if (self.blueButton==sender) {
        
        self.originImageView.image = [UIImage grayForImage:image forType:GrayImageTypeBlue];
        return;
    }
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
- (UIImageView *)originImageView
{
    if (!_originImageView) {
        _originImageView = [UIImageView new];
        _originImageView.image = [UIImage imageNamed:@"yangchaoyue"];
        
    }
    return _originImageView;
}

@end

