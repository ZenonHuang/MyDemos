//
//  LCCKTool.h
//  ChatDemo
//
//  Created by zzgo on 16/9/6.
//  Copyright © 2016年 zzgo. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^callBackResult)(BOOL succeeded, NSError *error);

@interface LCCKTool : NSObject
+ (void)invokeThisMethodInDidFinishLaunching;
+ (void)invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)invokeThisMethodInApplication:(UIApplication *)application
         didReceiveRemoteNotification:(NSDictionary *)userInfo;
+ (void)invokeThisMethodInApplicationWillResignActive:(UIApplication *)application;
+ (void)invokeThisMethodInApplicationWillTerminate:(UIApplication *)application;
//聊天服务
+ (void)startMessageWithClientId:(NSString *)clientId callback:(callBackResult)result;
+ (void)closeMessage:(callBackResult)result;
// init 设置需要统一做配置的地方
+ (void)setting;
@end