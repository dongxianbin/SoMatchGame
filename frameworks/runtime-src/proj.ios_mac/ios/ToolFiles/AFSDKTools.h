//
//  AFSDKTools.h
//  MichaelTool
//
//  Created by lianshen on 2023/8/19.
//  Copyright © 2023 zhuhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFSDKTools : NSObject
+(AFSDKTools *_Nullable)getShared;
- (void) startSDKWith:(NSDictionary *_Nullable)dic andApplication:(UIApplication *_Nullable)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions;
- (void) startApplicationDidBecomeActive;
- (void) sendLogEvent:(NSString *_Nullable)name withValues:(NSDictionary *_Nullable)message;

- (void) refreshSDKWith:(NSDictionary *_Nullable)dic;

- (int) afLogEvent:(NSDictionary *_Nonnull)dic;
@end

