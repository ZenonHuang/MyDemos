//
//  LCCKContactManager.h
//  LeanCloudChatKit-iOS
//
//  v0.7.10 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/3/10.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCCKContactManager : NSObject
//联系人
+ (instancetype)defaultManager;

- (NSArray *)fetchContactPeerIds;
- (BOOL)existContactForPeerId:(NSString *)peerId;
- (BOOL)addContactForPeerId:(NSString *)peerId;
- (BOOL)removeContactForPeerId:(NSString *)peerId;

@end
