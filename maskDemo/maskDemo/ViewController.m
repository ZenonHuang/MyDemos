//
//  ViewController.m
//  maskDemo
//
//  Created by zz go on 2016/10/13.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic) CAShapeLayer *maskLayer;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //创建一个mask
    _maskLayer = [[CAShapeLayer alloc]init];
    //设置mask的路径
    _maskLayer.path = [[UIBezierPath bezierPathWithOvalInRect:_btn.frame] CGPath];
    
    //将mask添加到view上
    self.view.layer.mask = _maskLayer;
}

- (IBAction)tapBtn:(id)sender {
    //以红色圆形的中心为原点，画一个足够大的圆，把整个self.view包含在园内（脑补一下）
    //计算出这个大圆的半径newR
    CGFloat newR = sqrt((self.view.frame.size.width-_btn.frame.size.width/2.0)*(self.view.frame.size.width-_btn.frame.size.width/2.0) + (self.view.frame.size.height-_btn.frame.size.height/2.0)*(self.view.frame.size.height-_btn.frame.size.height/2.0));
    
    //path是大圆的路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(_btn.frame, -newR, -newR)];
    
    //设置mask路径，保持动画完成后的状态
    _maskLayer.path = [path CGPath];
    
    //创建动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)([[UIBezierPath bezierPathWithOvalInRect:_btn.frame] CGPath]);
    maskLayerAnimation.toValue = (__bridge id)([path CGPath]);
    maskLayerAnimation.duration = 2;
    
    //添加动画
    [_maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
