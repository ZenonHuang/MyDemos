//
//  ViewController.m
//  HZDragDropCollectionView
//
//  Created by zz go on 2017/5/6.
//  Copyright © 2017年 zzgo. All rights reserved.
//

#import "HZBrowserViewController.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapGoButton:(id)sender {
   HZBrowserViewController *vc= [HZBrowserViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
