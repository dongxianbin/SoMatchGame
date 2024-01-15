//
//  MichaelStart.h
//  MichaelTool
//
//  Created by lianshen on 2023/08/19.
//  Copyright © 2023 lianshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MichaelStart : NSObject

@property (nonatomic, assign) int scriptHandler;

-(void)scriptHandlerCall:(NSString*_Nullable)data;

+(MichaelStart *_Nullable)getShared;

+ (void)initStartWithApplication:(UIApplication *_Nullable)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions;

+ (NSString *_Nullable)getDataInfo:(NSDictionary *_Nullable)dic;

+ (NSString *_Nullable)getECBDecrypt:(NSDictionary *_Nullable)dic;

//+ (void)getUUID:(NSString *_Nullable)udid;
//
//+ (NSString *_Nullable)getIMEI:(NSDictionary *_Nullable)dic;

@end


