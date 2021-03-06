//
//  NSString+MD5.m
//  TZS
//
//  Created by yandi on 14/12/9.
//  Copyright (c) 2014年 NongFuSpring. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)

+ (NSString *)md5:(NSString *)originalStr {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [originalStr UTF8String], (CC_LONG)[originalStr length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

+(NSString *)stringToMD5:(NSString *)inputStr
{
         const char *cStr = [inputStr UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, strlen(cStr), result);
        NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                                                            result[0], result[1], result[2], result[3],
                                                            result[4], result[5], result[6], result[7],
                                                            result[8], result[9], result[10], result[11],
                                                            result[12], result[13], result[14], result[15]
                                                            ];
        return [resultStr lowercaseString];
}
@end
