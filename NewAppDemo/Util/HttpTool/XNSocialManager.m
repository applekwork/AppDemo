//
//  XNSocialManager.m
//  XNManager
//
//  Created by Carlson Lee on 2017/7/5.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import "XNSocialManager.h"
#import "sys/utsname.h"

@implementation XNSocialManager

//当前版本
+ (NSString* )appVersion
{
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    return version;
}

//系统版本
+ (NSString* )systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//页面type
+ (NSString* )pageType:(SOCIAL_TYPE)type
{
    switch (type) {
        case SOCIAL_TYPE_PAGE:{
            UITabBarController* tab = [BGViewController shareInstance].tabVc;
            if(tab.selectedIndex == 0){
                return @"xulu://index.guanjia.com";
            }else if (tab.selectedIndex == 1){
                return @"xulu://banka.guanjia.com";
            }else if (tab.selectedIndex == 2){
                return @"xulu://shequ.guanjia.com";
            }else if (tab.selectedIndex == 3){
                return @"xulu://my.guanjia.com";
            }
        }
            break;
        case SOCIAL_TYPE_ACTIVE:{
            return @"xulu://active.guanjia.com";
        }
            break;
        case SOCIAL_TYPE_HOT:{
            return @"xulu://hot.guanjia.com";
        }
            break;
        case SOCIAL_TYPE_MORE:{
            return @"xulu://more.guanjia.com";
        }
            break;
        case SOCIAL_TYPE_OTHER:{
            return nil;
        }
            break;
        default:
            break;
    }
    return nil;
}

//设备型号
+ (NSString*)deviceType {
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

+ (NSDictionary* )handleParameters:(NSString* )param
{
    NSArray* params = [param componentsSeparatedByString:@"&&"];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeOfString:@"="];
        NSRange kRange = NSMakeRange(0, range.location);
        NSRange vRange = NSMakeRange(range.location+1, [obj length]-range.location-1);
        [dic setObject:[obj substringWithRange:vRange] forKey:[obj substringWithRange:kRange]];
    }];
    return [dic copy];
}

+ (void)clickEvent:(NSString* )event withType:(SOCIAL_TYPE)type block:(void(^)(BOOL isSucceed))block
{
    NSString* appVer = [self appVersion];
    NSString* sysVer = [self systemVersion];
    NSString* pageTypeCode = [self pageType:type];
    NSString* devicetype = [self deviceType];
    
    NSDictionary* params = [self handleParameters:event];
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithDictionary:params];
    [info setValue:appVer forKey:@"appVersion"];
    [info setValue:sysVer forKey:@"deviceSysVersion"];
    [info setValue:pageTypeCode forKey:@"pageTypeCode"];
    [info setValue:devicetype forKey:@"devicetype"];
    [info setValue:@"IOS" forKey:@"plt"];
//    [info setValue:_CustomerInfo.phoneNum forKey:@"uid"];
    [info setValue:[MyTool idfa] forKey:@"guid"];
    [info setValue:@"1" forKey:@"channelId"];
    
    [HttpTool noDesrequestWithBaseUrl:BASE_URL_API urlStr:@"gjapiCenter/account/tracker/saveStatTrackerInfo" method:POSTSTR parameters:info success:^(NSObject *resultObj) {
        if(block)block(YES);
    } fail:^(NSString *errorStr) {
        if(block)block(NO);
    }];
}

+ (void)clickEvent:(NSString* )event
{
    [self clickEvent:event withType:SOCIAL_TYPE_PAGE block:nil];
}

+ (void)clickMoreEvent:(NSString* )event
{
    [self clickEvent:event withType:SOCIAL_TYPE_MORE block:nil];
}

+ (void)activeEventWithBlcok:(void(^)(BOOL isSucceed))block
{
    [self clickEvent:@"url=xulu://active.guanjia.com" withType:SOCIAL_TYPE_ACTIVE block:block];
}

//统计日活is_social_hot
+ (void)hotKey:(NSString* )key withEvent:(void(^)())block
{
    NSString* day = [MyTool readValueForKey:key];
    NSString* today = [self todayStr];
    if(![day isEqualToString:today]){
        if(block)block();
        [MyTool writeValue:today forKey:key];
    }
}

+ (NSString* )todayStr
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    return [formate stringFromDate:date];
}

@end
