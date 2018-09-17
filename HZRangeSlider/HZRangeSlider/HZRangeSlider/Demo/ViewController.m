//
//  ViewController.m
//  HZRangeSlider
//
//  Created by zz go on 2017/5/5.
//  Copyright © 2017年 zzgo. All rights reserved.
//

#import "HZRangeSlider.h"
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)dragSlider:(HZRangeSlider *)sender {
    self.rangeLabel.text=[NSString stringWithFormat:@"当前范围：%.2f - %.2f",sender.minimumValue,sender.maximumValue];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
