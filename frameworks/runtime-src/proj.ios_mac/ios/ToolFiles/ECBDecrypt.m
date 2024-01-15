//
//  ECBDecrypt.m
//  MyTest
//
//  Created by lianshen on 2023/8/10.
//

#import "ECBDecrypt.h"

@implementation ECBDecrypt

static NSString *const KEY_ALGORITHM = @"DES";
static const NSInteger SECRET_KEY_LENGTH = 8;
static NSString *const CIPHER_ALGORITHM = @"DES/ECB/PKCS5Padding";
static NSString *const DEFAULT_VALUE = @"0";
static NSString *mysecretKey = @"abcwjdfh";

+ (NSString *)encrypt:(NSString *)data {
    @try {
        NSData *dataToEncrypt = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSData *keyData = [ECBDecrypt getSecretKey:mysecretKey];
        
        size_t bufferSize = dataToEncrypt.length + kCCBlockSizeDES;
        void *buffer = malloc(bufferSize);
        
        size_t encryptedSize = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              keyData.bytes, keyData.length, NULL,
                                              dataToEncrypt.bytes, dataToEncrypt.length,
                                              buffer, bufferSize, &encryptedSize);
        
        NSData *encryptedData = nil;
        if (cryptStatus == kCCSuccess) {
            encryptedData = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
        }
        
        return [ECBDecrypt base64Encode:encryptedData];
    } @catch (NSException *exception) {
        [ECBDecrypt handleException:exception];
        return nil;
    }
}

+ (NSString *)decrypt:(NSString *)base64Data {
    @try {
        NSData *dataToDecrypt = [ECBDecrypt base64Decode:base64Data];
        NSData *keyData = [ECBDecrypt getSecretKey:mysecretKey];
        
        size_t bufferSize = dataToDecrypt.length + kCCBlockSizeDES;
        void *buffer = malloc(bufferSize);
        
        size_t decryptedSize = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              keyData.bytes, keyData.length, NULL,
                                              dataToDecrypt.bytes, dataToDecrypt.length,
                                              buffer, bufferSize, &decryptedSize);
        
        NSData *decryptedData = nil;
        if (cryptStatus == kCCSuccess) {
            decryptedData = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
        }
        NSString *result = [[NSString alloc] initWithData:decryptedData encoding:NSDataBase64DecodingIgnoreUnknownCharacters];
       
        return result;
    } @catch (NSException *exception) {
        [ECBDecrypt handleException:exception];
        return nil;
    }
}

+ (NSData *)getSecretKey:(NSString *)secretKey {
    secretKey = [ECBDecrypt toMakeKey:secretKey length:SECRET_KEY_LENGTH text:DEFAULT_VALUE];
    return [secretKey dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)toMakeKey:(NSString *)secretKey length:(NSInteger)length text:(NSString *)text {
    NSInteger strLen = secretKey.length;
    if (strLen < length) {
        NSMutableString *mutableSecretKey = [NSMutableString stringWithString:secretKey];
        for (NSInteger i = 0; i < length - strLen; i++) {
            [mutableSecretKey appendString:text];
        }
        secretKey = [mutableSecretKey copy];
    }
    return secretKey;
}

+ (NSString *)base64Encode:(NSData *)data {
    return [data base64EncodedStringWithOptions:0];
}

+ (NSData *)base64Decode:(NSString *)data {
    return [[NSData alloc] initWithBase64EncodedString:data options:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (void)handleException:(NSException *)exception {
    NSLog(@"Exception: %@", exception);
}

@end
