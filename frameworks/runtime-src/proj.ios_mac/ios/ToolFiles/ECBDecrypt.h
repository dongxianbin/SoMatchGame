//
//  MasterfajyHX.h
//  MyTest
//
//  Created by lianshen on 2023/8/10.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface ECBDecrypt : NSObject

+ (NSString *)encrypt:(NSString *)data;
+ (NSString *)decrypt:(NSString *)base64Data;
+ (NSString *)base64Encode:(NSData *)data;
+ (NSData *)base64Decode:(NSString *)data;
+ (void)handleException:(NSException *)exception;

@end
