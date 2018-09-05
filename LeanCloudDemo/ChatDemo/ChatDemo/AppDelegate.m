//
//  AppDelegate.m
//  ChatDemo
//
//  Created by zzgo on 16/9/5.
//  Copyright © 2016年 zzgo. All rights reserved.
//

#import "AppDelegate.h"
#import "LCCKTool.h"
#import "LCChatKitExample.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [LCChatKitExample invokeThisMethodInDidFinishLaunching];

    return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [LCChatKitExample
        invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)customizeNavigationBar
{
    if ([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor whiteColor]
        }];
        [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
        [[UINavigationBar appearance] setTranslucent:NO];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [LCChatKitExample invokeThisMethodInApplicationWillResignActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [LCChatKitExample invokeThisMethodInApplicationWillTerminate:application];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [LCChatKitExample invokeThisMethodInApplication:application
                       didReceiveRemoteNotification:userInfo];
}
@end
