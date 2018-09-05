//
//  ViewController.m
//  ChatDemo
//
//  Created by zzgo on 16/9/5.
//  Copyright © 2016年 zzgo. All rights reserved.
//
#import "HZConversationListViewController.h"
#import "LCCKContactManager.h"
#import "LCCKTool.h"
#import "LCCKUtil.h"
#import "LCChatKitExample.h"
#import "NSObject+LCCKHUD.h"
#import "ViewController.h"
#import <ChatKit/LCChatKit.h>

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

@interface ViewController ()
@property (nonatomic, strong) LCCKContactListViewController *secondViewController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //打开客户端
    [LCCKUtil showProgressText:@"open client ..." duration:10.0f];
    [LCChatKitExample invokeThisMethodAfterLoginSuccessWithClientId:@"uii"
        success:^{
          [LCCKUtil hideProgress];
          NSLog(@"登录成功");
        }
        failed:^(NSError *error) {
          [LCCKUtil hideProgress];
          NSLog(@"登录失败");
        }];
    //    WS(ws);
}
//点击到会话列表
- (IBAction)touchConversionBtn:(UIButton *)sender
{
    HZConversationListViewController *firstViewController =
        [[HZConversationListViewController alloc] init];

    [[LCChatKit sharedInstance] setDidSelectConversationsListCellBlock:^(
                                    NSIndexPath *indexPath, AVIMConversation *conversation,
                                    LCCKConversationListViewController *controller) {
      LCCKConversationViewController *conversationViewController =
          [[LCCKConversationViewController alloc]
              initWithConversationId:conversation.conversationId];
      [controller.navigationController pushViewController:conversationViewController animated:YES];
    }];

    [self.navigationController pushViewController:firstViewController animated:YES];
}
//点击到联系人列表
- (IBAction)touchContactBtn:(UIButton *)sender
{
    //获取用户数组
    NSArray *users = [[LCChatKit sharedInstance] getCachedProfilesIfExists:self.allPersonIds
                                                           shouldSameCount:YES
                                                                     error:nil];
    //获取当前用户id
    NSString *currentClientID = [[LCChatKit sharedInstance] clientId];
    //初始化联系人列表
    LCCKContactListViewController *secondViewController = [[LCCKContactListViewController alloc]
        initWithContacts:[NSSet setWithArray:users]
                 userIds:[NSSet setWithArray:self.allPersonIds]
         excludedUserIds:[NSSet setWithArray:@[ currentClientID ]]
                    mode:LCCKContactListModeNormal];
    [secondViewController setSelectedContactCallback:^(UIViewController *viewController,
                                                       NSString *peerId) {
      [LCChatKitExample exampleOpenConversationViewControllerWithPeerId:peerId
                                               fromNavigationController:self.tabBarController
                                                                            .navigationController];
    }];
    [secondViewController
        setDeleteContactCallback:^BOOL(UIViewController *viewController, NSString *peerId) {
          [[LCCKContactManager defaultManager] removeContactForPeerId:peerId];
          return YES;
        }];

    secondViewController.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(signOut)];
    //    secondViewController.navigationItem.leftBarButtonItem =
    //        [[UIBarButtonItem alloc] initWithTitle:@"添加好友"
    //                                         style:UIBarButtonItemStylePlain
    //                                        target:self
    //                                        action:@selector(addFriend)];
    self.secondViewController = secondViewController;

    // push
    [self.navigationController pushViewController:self.secondViewController animated:YES];
}

- (IBAction)touchChatKitButton:(UIButton *)sender
{
    //群聊，ConversationId为LCChatKit群的id
    //    [LCChatKitExample
    //        exampleOpenConversationViewControllerWithConversaionId:@"570da6a9daeb3a63ca5b07b0"
    //                                      fromNavigationController:self];
    //单聊，根据PerrID打开
    //    [LCChatKitExample exampleOpenConversationViewControllerWithPeerId:@"oops"
    //                                             fromNavigationController:self.navigationController];
    LCCKConversationViewController *conversationViewController =
        [[LCCKConversationViewController alloc] initWithConversationId:@"570da6a9daeb3a63ca5b07b0"];
    conversationViewController.enableAutoJoin = YES;

    //设置会话页面的viewWillDisappear
    [conversationViewController
        setViewWillDisappearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
          [[self class] lcck_hideHUDForView:viewController.view];
        }];
    //设置会话页面的viewWillAppear
    [conversationViewController
        setViewWillAppearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
          [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                      animated:aAnimated];
        }];
    // push
    [self.navigationController pushViewController:conversationViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 联系人列表所用方法
- (NSArray *)allPersonIds
{
    NSArray *allPersonIds = [[LCCKContactManager defaultManager] fetchContactPeerIds];
    return allPersonIds;
}

- (void)addFriend
{
    NSString *additionUserId = self.arc4randomString;
    NSMutableSet *addedUserIds = [NSMutableSet setWithSet:self.secondViewController.userIds];
    [addedUserIds addObject:additionUserId];
    self.secondViewController.userIds = [addedUserIds copy];
}

- (NSString *)arc4randomString
{
    int a = arc4random_uniform(100000000);
    NSString *arc4randomString = [NSString stringWithFormat:@"%@", @(a)];
    return arc4randomString;
}

- (void)showPopOverMenu:(UIBarButtonItem *)sender event:(UIEvent *)event
{
    //   点击菜单的对应事件
}
/**
 *  退出
 */
- (void)signOut
{
    [LCChatKitExample signOutFromViewController:self.secondViewController];
}

@end
