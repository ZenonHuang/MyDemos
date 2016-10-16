//
//  ViewController.m
//  RongCloudDemo
//
//  Created by zzgo on 2016/10/15.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "ViewController.h"


static NSString *token1=@"IfM04Dmcu4n1rKRMhf5Uu3Oex6Vj7gSaQj8eHNdh10Izq+wvTu0YIsv+P/8bcUZdOKuKq16vOHeXYmr8tFvDhOIMBClcm8QR";
static NSString *token2=@"66YLA34rwjSkX70vuqsvtbmS1kkuf2mnZxVQMMqcQdTbUGn+2hIz1T/zf/wsfvFuPJqcxZMVRix41ERvIVbStw==";

static NSString *userID1=@"testUser";
static NSString *userID2=@"zzgo";

@interface ViewController ()
@property(nonatomic,strong) NSString* loginToken;
@property(nonatomic,strong) NSString* peerID;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginWithToken2:(id)sender {
    self.loginToken=token2;
    //聊天的对方ID
    self.peerID=userID1;
    [self linkServer];
    [self pushChatView];
}
- (IBAction)loginWithToken1:(id)sender {
    self.loginToken=token1;
    self.peerID=userID2;
    [self linkServer];
    [self pushChatView];
}

-(void)linkServer{
    //3.连接服务器
    [[RCIM sharedRCIM] connectWithToken:self.loginToken success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%li", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}

-(void)pushChatView{
    //新建一个聊天会话View Controller对象
    RCConversationViewController *chat = [[RCConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = @"targetIdYouWillChatIn";
    //设置聊天会话界面要显示的标题
    chat.title = @"title";
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
