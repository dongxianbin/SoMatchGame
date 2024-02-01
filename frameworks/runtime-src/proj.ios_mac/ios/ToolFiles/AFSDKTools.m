//
//  AFSDKTools.m
//  MichaelTool
//
//  Created by lianshen on 2023/8/19.
//  Copyright © 2023 zhuhuo. All rights reserved.
//

#import "AFSDKTools.h"
#import "MichaelStart.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "Adjust.h"
#import <UserNotifications/UserNotifications.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface AFSDKTools()<UNUserNotificationCenterDelegate, AdjustDelegate>
@property (nonatomic, strong) NSString *afadkey;
@property (nonatomic, strong) NSString *appleid;
@property (nonatomic, strong) NSString *afad;
@property (nonatomic, strong) NSDictionary *afadclick;
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
        self.afadclick = [dic objectForKey:@"afadclick"];
    } else {
        self.afadkey = @"iLZuxyXFie7G2iWZvuxUxY";
        self.appleid = @"133790126";
        self.afad = @"AF";
    }
}

- (void)refreshSDKWith:(NSDictionary *_Nullable)dic{
    [self getDic:dic];
    if ([self.afad isEqualToString:@"AF"] || [self.afad isEqualToString:@"af"]) {
        /** APPSFLYER INIT **/
        [[AppsFlyerLib shared] setAppsFlyerDevKey:self.afadkey];
        [[AppsFlyerLib shared] setAppleAppID:self.appleid];
        
        /* Uncomment the following line to see AppsFlyer debug logs */
        [AppsFlyerLib shared].isDebug = YES;
        
        [self sendLaunch:nil];
        
    } else if([self.afad isEqualToString:@"AD"] || [self.afad isEqualToString:@"ad"]){
        
        /** APPSFLYER INIT **/
        NSString *yourAppToken = self.afadkey;
        NSString *environment = ADJEnvironmentSandbox;
        ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken
                                          environment:environment];
        [adjustConfig setLogLevel:ADJLogLevelVerbose];
        
        [adjustConfig setDelegate:self];

        [Adjust appDidLaunch:adjustConfig];

//        ADJAttribution *attribution = [Adjust attribution];
//        NSLog(@"**********%@",attribution);

    }
    
}
- (void)startSDKWith:(NSDictionary *)dic andApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self getDic:dic];
    
    if ([self.afad isEqualToString:@"AF"] || [self.afad isEqualToString:@"af"]) {
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
    } else if([self.afad isEqualToString:@"AD"] || [self.afad isEqualToString:@"ad"]){
        
        /** APPSFLYER INIT **/
        NSString *yourAppToken = self.afadkey;
        NSString *environment = ADJEnvironmentSandbox;
        ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken
                                          environment:environment];
        [adjustConfig setLogLevel:ADJLogLevelVerbose];
        
        [adjustConfig setDelegate:self];

        [Adjust appDidLaunch:adjustConfig];

//        ADJAttribution *attribution = [Adjust attribution];
//        NSLog(@"**********%@",attribution);

    }
}

- (void) startApplicationDidBecomeActive{
    [self getAppTracking];
    if ([self.afad isEqualToString:@"AF"] || [self.afad isEqualToString:@"af"]) {
        [[AppsFlyerLib shared] start];
    } else if([self.afad isEqualToString:@"AD"] || [self.afad isEqualToString:@"ad"]){
//        [Adjust trackSubsessionStart];
    }
}

#pragma mark 获取设备追踪权限
- (void) getAppTracking {
    if (@available(iOS 14.0, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusAuthorized:
                {
                    //用户允许IDFA"
                    NSString *uuid = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                    [MichaelStart getUUID:uuid];
                }
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
                {
                    //用户拒绝IDFA
                    NSString *uuid = [self getUUIDString];
                    [MichaelStart getUUID:uuid];
                }
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                {
                    //用户受限制IDFA
                    NSString *uuid = [self getUUIDString];
                    [MichaelStart getUUID:uuid];
                }
                    break;

                case ATTrackingManagerAuthorizationStatusNotDetermined:
                {
                    //在模拟器或者iOS15以上运行才会出现的状态
                    //用户未做选择或未弹窗IDFA
                    NSString *uuid = [self getUUIDString];
                    [MichaelStart getUUID:uuid];
                }
                    break;
                default:
                    break;
            }
        }];
    }else{
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *uuid = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            [MichaelStart getUUID:uuid];
        }
    }
}
- (NSString *)getUUIDString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
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

- (int) afLogEvent:(NSDictionary *_Nonnull)dic {
    NSString *dataStr = [dic objectForKey:@"data"];
    NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dataDic=%@", dataDic);
    NSString *name = [dataDic objectForKey:@"name"];
    NSDictionary *message = [dataDic objectForKey:@""];
    if (name && message) {
        [self sendLogEvent:name withValues:message];
        return 1;
    }
    return 0;
}

#pragma mark - AdJust初始化回调
- (void)adjustAttributionChanged:(ADJAttribution *)attribution {
    NSLog(@"**********%@",attribution);
}

#pragma mark - AppsFlyer事件上报
- (void)sendLogEvent:(NSString *)name withValues:(NSDictionary * _Nullable)message{
    if ([self.afad isEqualToString:@"AF"] || [self.afad isEqualToString:@"af"]) {
//        [self.afadclick enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
//            if ([obj isEqualToString:name]) {
//                *stop = YES;
//                if ([key isEqualToString:@""]) {
//
//                } else {
//
//                }
//            }
//        }];
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
    } else if([self.afad isEqualToString:@"AD"] || [self.afad isEqualToString:@"ad"]){
        [self.afadclick enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:name]) {
                *stop = YES;
                if ([key isEqualToString:@""]) {
                    ADJEvent *event = [ADJEvent eventWithEventToken:name];
                    double price = [message[@"price"] doubleValue];
                    id bizhong = message[@"currency"];
                    [event setRevenue:price currency:bizhong];
                    [Adjust trackEvent:event];
                } else {
                    ADJEvent *event = [ADJEvent eventWithEventToken:name];
                    [Adjust trackEvent:event];
                }
            }
        }];
    }
}




@end
