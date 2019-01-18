//
//  ViewController.m
//  DynamicDelegate
//
//  Created by ZenonHuang on 2019/1/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "ViewController.h"
#import "HZManager+Blocks.h"

@interface ViewController ()
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,strong) HZManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - action
- (IBAction)tapCountButton:(id)sender {
    
    [self.manager count];
    
}

#pragma mark - getter
- (HZManager *)manager
{
    if (!_manager) {
        _manager = [[HZManager alloc] init];
        
        [_manager bk_setCountBlock:^(NSInteger num) {
            self.numLabel.text = [NSNumber numberWithInteger:num].stringValue;
        }];
    }
    
    return _manager;
}
@end
