//
//  Created by zzgo on 16/8/22.
// 	Contact by zzgoCC@gmail.com
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "HZRespCacheController.h"
#import <YYCache/YYCache.h>
//YYCache
NSString *const HZHttpCache = @"HZHttpCache";

@interface HZRespCacheController ()

@end

@implementation HZRespCacheController

#pragma mark - Intial Methods

#pragma mark - Override/Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - private
- (void)requsetCacheSetting
{
    //处理中文和空格问题
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //拼接
    NSString *cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:parameters];

    MCLog(@"\n\n 网址 \n\n      %@    \n\n 网址 \n\n", cacheUrl);
    //设置YYCache属性
    YYCache *cache = [[YYCache alloc] initWithName:SPHttpCache];

    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;

    id cacheData;
    if (isCache) { //有cache，先使用cache

        //根据网址从Cache中取数据
        cacheData = [cache objectForKey:cacheKey];

        if (cacheData != 0) {
            //将数据统一处理
            [self returnDataWithRequestData:cacheData Success:^(NSDictionary *requestDic, NSString *msg) {
              MCLog(@"缓存数据\n\n    %@    \n\n", requestDic);
              success(requestDic, msg);
            }
                failure:^(NSString *errorInfo) {
                  failure(errorInfo);
                }];
        }
    }

    //进行网络检查
    if (![self requestBeforeJudgeConnect]) {
        failure(@"没有网络");
        MCLog(@"\n\n----%@------\n\n", @"没有网络");
        return;
    }
}

#pragma mark 统一处理请求到的数据
- (void)dealWithResponseObject:(NSData *)responseData cacheUrl:(NSString *)cacheUrl cacheData:(id)cacheData isCache:(BOOL)isCache cache:(YYCache *)cache cacheKey:(NSString *)cacheKey success:(SuccessBlock)success failure:(FailureBlock)failure
{

    dispatch_async(dispatch_get_main_queue(), ^{
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // 关闭网络指示器
    });

    NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    dataString = [self deleteSpecialCodeWithStr:dataString];
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];

    if (isCache) {
        //
        [cache setObject:requestData forKey:cacheKey];
    }
    //如果不缓存 或者 数据不相同 从网络请求
    if (!isCache || ![cacheData isEqual:requestData]) {

        [self returnDataWithRequestData:requestData Success:^(NSDictionary *requestDic, NSString *msg) {
          MCLog(@"网络数据\n\n   %@   \n\n", requestDic);
        }
            failure:^(NSString *errorInfo) {
              failure(errorInfo);
            }];
    }
}
#pragma mark--根据返回的数据进行统一的格式处理  ----requestData 网络或者是缓存的数据----
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    id myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];

    //判断是否为字典
    if ([myResult isKindOfClass:[NSDictionary class]]) {
        NSDictionary *requestDic = (NSDictionary *)myResult;

        //根据返回的接口内容来变
        NSString *succ = requestDic[@"status"];
        if ([succ isEqualToString:@"success"]) {
            success(requestDic[@"result"], requestDic[@"msg"]);
        }
        else {
            failure(requestDic[@"msg"]);
        }
    }
}

#pragma mark 网络判断
- (BOOL)requestBeforeJudgeConnect
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
        SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
        SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable = (isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIApplication sharedApplication].networkActivityIndicatorVisible = isNetworkEnable; /*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
    });
    return isNetworkEnable;
}

#pragma mark-- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str
{
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}

@end
