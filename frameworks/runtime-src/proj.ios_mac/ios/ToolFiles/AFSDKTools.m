//
//  AFSDKTools.m
//  MichaelTool
//
//  Created by lianshen on 2023/8/19.
//  Copyright © 2023 zhuhuo. All rights reserved.
//

#import "AFSDKTools.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <UserNotifications/UserNotifications.h>

@interface AFSDKTools()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) NSString *afadkey;
@property (nonatomic, strong) NSString *appleid;
@property (nonatomic, strong) NSString *afad;
@end

@implementation AFSDKTools

static AFSDKTools *_shareTools = nil;

#pragma mark 获取工具集的单例
+(AFSDKTools *)getShared{
    
    @synchronized(self)
    {
        if (_shareTools == nil) {
            _shareTools = [[AFSDKTools alloc] init];
        }
        return _shareTools;
    }
}
-(void)getDic:(NSDictionary *)dic{
    if ([dic count]) {
        self.afadkey = [dic objectForKey:@"afadkey"];
        self.appleid = [dic objectForKey:@"appleid"];
        self.afad = [dic objectForKey:@"afad"];
    } else {
        self.afadkey = @"iLZuxyXFie7G2iWZvuxUxY";
        self.appleid = @"133790126";
        self.afad = @"AF";
    }
}

- (void)refreshSDKWith:(NSDictionary *_Nullable)dic{
    [self getDic:dic];
    if ([self.afad isEqualToString:@"AF"]) {
        /** APPSFLYER INIT **/
        [[AppsFlyerLib shared] setAppsFlyerDevKey:self.afadkey];
        [[AppsFlyerLib shared] setAppleAppID:self.appleid];
        
        /* Uncomment the following line to see AppsFlyer debug logs */
        [AppsFlyerLib shared].isDebug = YES;
        
        [self sendLaunch:nil];
    }
    
}
- (void)startSDKWith:(NSDictionary *)dic andApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self getDic:dic];
    
    if ([self.afad isEqualToString:@"AF"]) {
        /** APPSFLYER INIT **/
        [[AppsFlyerLib shared] setAppsFlyerDevKey:self.afadkey];
        [[AppsFlyerLib shared] setAppleAppID:self.appleid];
        
        /* Uncomment the following line to see AppsFlyer debug logs */
        [AppsFlyerLib shared].isDebug = YES;
        
        // SceneDelegate support
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLaunch:) name:UIApplicationDidBecomeActiveNotification object:nil];

         UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
         center.delegate = self;
         [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // 处理授权请求结果
             if (granted) {
                 NSLog(@"通知授权成功");
             } else {
                 NSLog(@"通知授权被拒绝");
             }
         }];

         [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
}
#pragma mark - AppsFlyer初始化回调
- (void)sendLaunch:(UIApplication *)application {
    [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *,id> *dictionary, NSError *error) {
        if (error) {
            NSLog(@"error************%@", error);
            return;
        }
        if (dictionary) {
            NSLog(@"dictionary############%@", dictionary);
            return;
        }
    }];
}
#pragma mark - AppsFlyer事件上报
- (void)sendLogEvent:(NSString *)name withValues:(NSDictionary * _Nullable)message{
    //上报首充，充值，提现
    if ([name isEqualToString:@"firstrecharge"] || [name isEqualToString:@"recharge"] || [name isEqualToString:@"withdrawOrderSuccess"] || [name isEqualToString:@"purchase"]) {
        id ci = message[@"amount"];
        id jian = message[@"currency"];
        if (ci && jian) {
            double tai = [ci doubleValue];
            [[AppsFlyerLib shared] logEvent:name withValues:@{AFEventParamPrice: [name isEqualToString:@"withdrawOrderSuccess"] ? @(-tai): @(tai), AFEventParamCurrency: jian}];
        }
    }else {//其他事件
        [[AppsFlyerLib shared] logEvent:name withValues:message];
    }
}


@end
