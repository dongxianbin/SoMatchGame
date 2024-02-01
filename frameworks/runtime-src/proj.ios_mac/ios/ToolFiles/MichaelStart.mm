//
//  MichaelStart.m
//  MichaelTool
//
//  Created by lianshen on 2023/08/19.
//  Copyright © 2023 lianshen. All rights reserved.
//

#import "MichaelStart.h"
#import "CFTDataManage.h"
#import "ECBDecrypt.h"
#import "AFSDKTools.h"

#import "cocos2d.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
using namespace cocos2d;


@implementation MichaelStart
static MichaelStart *static_MichaelStart = NULL;

+(MichaelStart *)getShared{
    if(!static_MichaelStart)
    {
        static_MichaelStart = [[MichaelStart alloc] init];
    }
    return static_MichaelStart;
}

-(void)scriptHandlerCall:(NSString*)data
{
    if([MichaelStart getShared].scriptHandler)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            const char *dataStr = [data UTF8String];
            LuaBridge::pushLuaFunctionById([MichaelStart getShared].scriptHandler);//压入需要调用的方法id
            LuaStack *stack = LuaBridge::getStack();//获取lua栈
            stack->pushString(dataStr); //将需要传递给lua层的参数通过栈传递
            stack->executeFunction(1);//共有1个参数 (“oc传递给lua的参数”)，这里传参数 1
            //NSLog(@"开始推送%s",dataStr);
            //LuaBridge::releaseLuaFunctionById([DeviceInfo shared].scriptHandler); //最后记得释放
        });
    }
}

+ (NSString *_Nullable)getDataInfo:(NSDictionary *_Nullable)dic{
    NSString *result = [dic objectForKey:@"data"];
    
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *rdic = [self getDicWith:resultDictionary];
    NSString* returnStr = [[NSString alloc] init];
    if ([rdic count]) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:rdic options:0 error:nil];
        returnStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CFTDataManage sharedDataManage] setDataDic:rdic];
            
            [[AFSDKTools getShared] refreshSDKWith:rdic];
        });
//        return returnStr;
    }
    return returnStr;
}

+ (NSString *_Nullable) getECBDecrypt:(NSDictionary *_Nullable)dic{
    NSString *req = [dic objectForKey:@"reqStr"];
    NSString *url = [ECBDecrypt decrypt:req];
    return url;
}

+ (void) getUUID:(NSString *_Nullable)udid {
    [[MichaelStart getShared] scriptHandlerCall:udid];
    [[CFTDataManage sharedDataManage] setUuid:udid];
}

+ (NSString *_Nullable) getIMEI:(NSDictionary *_Nullable)dic{
    int scriptHandler = [[dic objectForKey:@"callback"] intValue];
    [[MichaelStart getShared] setScriptHandler:scriptHandler];
    NSString *uuid = [CFTDataManage sharedDataManage].uuid;
    return uuid;
}

+ (int) logEvent:(NSDictionary *_Nullable)dic {
    return [[AFSDKTools getShared] afLogEvent:dic];
}


#pragma mark 初始化方法
+ (void)smApplication:(UIApplication *_Nullable)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dataDic = [[CFTDataManage sharedDataManage] dataDic];
        NSLog(@"dataDic:%@", dataDic);
        [[AFSDKTools getShared] startSDKWith:dataDic andApplication:application didFinishLaunchingWithOptions:launchOptions];

    });
}
+ (void)smApplicationDidBecomeActive{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AFSDKTools getShared] startApplicationDidBecomeActive];
    });
}

+ (NSDictionary *)getDicWith:(NSDictionary *)dic{
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    NSDictionary *dicData = dic[@"data"][@"gdsfbn"];

    NSString *url = [ECBDecrypt decrypt:[dicData objectForKey:@"ndfgrd"]];
    [returnDic setObject:url forKey:@"url"];
    
    NSString *ip = [ECBDecrypt decrypt:[dicData objectForKey:@"nydfhj"]];
    [returnDic setObject:ip forKey:@"ip"];
    
    NSString *afad = [dicData objectForKey:@"afad"];
    [returnDic setObject:afad forKey:@"afad"];
    
    NSString *afjsname = [dicData objectForKey:@"afjsname"];
    [returnDic setObject:afjsname forKey:@"afjsname"];
    
    if ([afad isEqualToString:@"AF"] || [afad isEqualToString:@"af"]){
        NSString *afadkey = [dicData objectForKey:@"afadkey"];
        NSArray *array = [afadkey componentsSeparatedByString:@","];
        
        [returnDic setObject:[array firstObject] forKey:@"afadkey"];
        [returnDic setObject:[array lastObject] forKey:@"appleid"];
    } else {
        NSString *afadkey = [dicData objectForKey:@"afadkey"];
        [returnDic setObject:afadkey forKey:@"afadkey"];
    }
    
    
    NSArray *afadclickArr = [dicData objectForKey:@"afadclick"];
    NSMutableDictionary *afadclickDic = [[NSMutableDictionary alloc] init];
    for (int i=0; i< [afadclickArr count]; i++) {
        [afadclickDic addEntriesFromDictionary:afadclickArr[i]];
    }
    [returnDic setObject:afadclickDic forKey:@"afadclick"];
    
    return returnDic;
}




@end
