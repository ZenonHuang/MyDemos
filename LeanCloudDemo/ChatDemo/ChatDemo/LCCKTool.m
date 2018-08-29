//
//  LCCKTool.m
//  ChatDemo
//
//  Created by zzgo on 16/9/6.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import "LCCKExampleConstants.h"
#import "LCCKTool.h"
#import "LCCKUser.h"
#import "LCCKUtil.h"
#import "NSObject+LCCKHUD.h"
#import "ViewController.h"
#import <LCChatKit.h>

static NSString *const LCCKAPPID = @"dYRQ8YfHRiILshUnfFJu2eQM-gzGzoHsz";
static NSString *const LCCKAPPKEY = @"ye24iIK6ys8IvaISMC4Bs5WK";

@interface LCCKTool ()

@end

@implementation LCCKTool

#pragma mark - 初始化设置
+ (void)invokeThisMethodInDidFinishLaunching
{
    //开启 LeanCloud 服务
    [LCChatKit setAppId:LCCKAPPID appKey:LCCKAPPKEY];
    // 如果APP是在国外使用，开启北美节点
    // [AVOSCloud setServiceRegion:AVServiceRegionUS];
    // 启用未读消息
    [AVIMClient setUserOptions:@{ AVIMUserOptionUseUnread : @(YES) }];
    [AVOSCloud registerForRemoteNotification];
    [AVIMClient setTimeoutIntervalInSeconds:20];
    //添加输入框底部插件，如需更换图标标题，可子类化，然后调用 `+registerSubclass`
    [LCCKInputViewPluginTakePhoto registerSubclass];
    [LCCKInputViewPluginPickImage registerSubclass];
    [LCCKInputViewPluginLocation registerSubclass];
}
+ (void)invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)invokeThisMethodInApplication:(UIApplication *)application
         didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive) {
        // 应用在前台时收到推送，只能来自于普通的推送，而非离线消息推送
    }
    else {
        /*!
         *  当使用 https://github.com/leancloud/leanchat-cloudcode 云代码更改推送内容的时候
         {
         aps =     {
         alert = "lcckkit : sdfsdf";
         badge = 4;
         sound = default;
         };
         convid = 55bae86300b0efdcbe3e742e;
         }
         */
        [[LCChatKit sharedInstance] didReceiveRemoteNotification:userInfo];
    }
}

+ (void)invokeThisMethodInApplicationWillResignActive:(UIApplication *)application
{
    [[LCChatKit sharedInstance] syncBadge];
}

+ (void)invokeThisMethodInApplicationWillTerminate:(UIApplication *)application
{
    [[LCChatKit sharedInstance] syncBadge];
}
#pragma mark - 聊天

+ (void)startMessageWithClientId:(NSString *)clientId callback:(callBackResult)result
{
    [[LCChatKit sharedInstance] openWithClientId:clientId
                                        callback:^(BOOL succeeded, NSError *error) {
                                          succeeded ? result(YES, nil) : result(NO, error);
                                        }];
}

+ (void)closeMessage:(callBackResult)result
{
    [[LCChatKit sharedInstance] closeWithCallback:^(BOOL succeeded, NSError *error) {
      succeeded ? result(YES, nil) : result(NO, error);
    }];
}
#pragma mark - 设置
+ (void)setting
{
    //
    [[LCChatKit sharedInstance] setDidSelectConversationsListCellBlock:^(
                                    NSIndexPath *indexPath, AVIMConversation *conversation,
                                    LCCKConversationListViewController *controller) {
      NSLog(@"conversation selected");
      LCCKConversationViewController *conversationVC = [[LCCKConversationViewController alloc]
          initWithConversationId:conversation.conversationId];

      [conversationVC
          setFetchConversationHandler:^(AVIMConversation *conversation,
                                        LCCKConversationViewController *conversationController) {
            if (!conversation) { //假如为Nil，获取失败
                NSLog(@"会话获取失败");
            }
          }];
      [controller.navigationController pushViewController:conversationVC animated:YES];

    }];

    //设置根据 userId 获取到一个 User 对象的逻辑。ChatKit 会在需要用到 User信息时调用这个逻辑
    [[LCChatKit sharedInstance]
        setFetchProfilesBlock:^(NSArray<NSString *> *userIds,
                                LCCKFetchProfilesCompletionHandler completionHandler) {
          NSLog(@"设置用户体系，获取id");
        }];

    //  实现此方法，ChatKit 会为以下行为添加签名：
    // open（开启聊天）、start（创建对话）、kick（踢人）、invite（邀请）。反之不会。
    [[LCChatKit sharedInstance]
        setGenerateSignatureBlock:^(NSString *clientId, NSString *conversationId, NSString *action,
                                    NSArray *clientIds,
                                    LCCKGenerateSignatureCompletionHandler completionHandler){

        }];
}

@end