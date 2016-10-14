//
//  ViewController.m
//  PulsingHalo
//
//  Created by zzgo on 2016/10/14.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import "ViewController.h"
#import <PulsingHalo.h>
#import <PulsingHaloLayer.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  PulsingHaloLayer *halo = [PulsingHaloLayer layer];
  halo.position = self.view.center;
  //layer number 波纹层数
  halo.haloLayerNumber = 3;
  halo.radius=240;
  [self.view.layer addSublayer:halo];
  [halo start];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
