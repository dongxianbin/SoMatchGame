//
//  CFTDataManage.m
//  CandleFireTool
//
//  Created by zhuhuo on 2019/10/12.
//  Copyright © 2019年 zhuhuo. All rights reserved.
//

#import "CFTDataManage.h"

#define MY_DataInfo_Model @"MyDataInfoModel"
#define MY_UUID @"MyUUID"

@implementation CFTDataManage

@synthesize uuid,dataDic;

static CFTDataManage *static_CFTDataManage = nil;

+ (CFTDataManage *) sharedDataManage{
    @synchronized(self){
        if ( nil == static_CFTDataManage ) {
            static_CFTDataManage = [[CFTDataManage alloc] init];
        }
    }
    return static_CFTDataManage;
}

#pragma mark - uuid
-(void)setUuid:(NSString *)_uuid{
    NSUserDefaults *userfault=[NSUserDefaults standardUserDefaults];
    [userfault setObject:_uuid forKey:MY_UUID];
}
-(NSString *)uuid{
    NSUserDefaults *userfault=[NSUserDefaults standardUserDefaults];
    uuid = [userfault objectForKey:MY_UUID];
    return uuid;
}
#pragma mark - dataDic
-(void)setDataDic:(NSDictionary *)_dataDic {
    NSUserDefaults *userfault=[NSUserDefaults standardUserDefaults];
    [userfault setObject:_dataDic forKey:MY_DataInfo_Model];
}

-(NSDictionary *)dataDic {
    NSUserDefaults *userfault=[NSUserDefaults standardUserDefaults];
    dataDic = [[NSDictionary alloc] initWithDictionary:[userfault objectForKey:MY_DataInfo_Model]];
    return dataDic;
}


@end
