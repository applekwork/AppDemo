//
//  UserAgent.m
//  MasterDuoBao
//
//  Created by 汤丹峰 on 16/3/25.
//  Copyright © 2016年 wenzhan. All rights reserved.
//

#import "UserAgent.h"
#import "sys/utsname.h"

@implementation UserAgent
static UserAgent *userAgent = nil;
+ (UserAgent *)ShardInstnce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userAgent = [[UserAgent alloc] init];
    });
    return userAgent;
}

- (void)webSetUserAgent
{
    // 查看系统默认UserAgent
//    NSLog(@"%@", [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);

    NSString *customUserAgent = [self getUserAgent];
    
    //设置自定义User-Agent
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
}

- (NSString *)getUserAgent
{
    // 查看info.plist文件中对应得key值
    //    NSLog(@"%@", [[[NSBundle mainBundle] infoDictionary] allKeys]);
    
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    version = [version stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *platVersion = [[UIDevice currentDevice] systemVersion];//[[NSBundle mainBundle] infoDictionary][@"MinimumOSVersion"];
    NSString *uid = [MyTool readValueForKey:@"uid"] ? : @"0";
    NSString *uuid = [MyTool idfa];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *deviceToken = [MyTool readValueForKey:@"deviceToken"] ? : @"0";
    
    
    // User-Agent:dfduobao/1.0.0 (iOS;iOS8.0;zh_CN;ID:1-UID-UUID-AppStore)
    NSString *customUserAgent = [NSString stringWithFormat:@"xulugj://%@ (iOS;iOS%@;zh_CN;ID:1-%@-%@-AppStore-%@)", version, platVersion, uid, uuid, deviceToken];
//    DLog(@"customUserAgent-----%@", customUserAgent);
    
    return customUserAgent;
}
- (NSString*)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    return deviceString;
}
@end
