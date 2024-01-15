//
//  CFTDataManage.h
//  CandleFireTool
//
//  Created by zhuhuo on 2019/10/12.
//  Copyright © 2019年 zhuhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CFTDataManage : NSObject

+ (CFTDataManage *) sharedDataManage;

@property(nonatomic, strong)NSString *uuid;    //uuid
@property(nonatomic, strong)NSDictionary *dataDic;    //数据

@end
