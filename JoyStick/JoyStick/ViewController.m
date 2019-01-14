//
//  ViewController.m
//  JoyStick
//
//  Created by ZenonHuang on 2019/1/14.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "ViewController.h"
#import "Lib/HZJoyStick.h"

@interface ViewController ()<HZJoyStickDelegate>
@property (nonatomic,strong) HZJoyStick *joyStick;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
 
    [self.view addSubview:self.joyStick];
}

#pragma mark - delegate
- (void)hz_joyStickDidMoveOffsetX:(CGFloat)x offsetY:(CGFloat)y
{
    NSLog(@"OffsetX: %@ OffsetY: %@",@(x),@(y));
}

#pragma mark - getter
- (HZJoyStick *)joyStick
{
    if (!_joyStick) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize stickSize = CGSizeMake(200, 200);
        CGRect frame = CGRectMake((screenSize.width - stickSize.width)/2, (screenSize.height - stickSize.height)/2, stickSize.width, stickSize.height);
        _joyStick = [[HZJoyStick alloc] initWithFrame:frame];
        _joyStick.moveDelegate = self;
    }
    return _joyStick;
}
@end
