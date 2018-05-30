//
//  MyTool.h
//  XNSudai
//
//  Created by zxl on 2017/3/24.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <Foundation/Foundation.h>

//第二帧启动图
#define ios_start_frame2_key        @"ios_start_frame2"
#define ios_start_frame2_url_key    @"ios_start_frame2_url"

#define DEVICE_TOKEN                @"device_token"
#define DEVICE_TOKEN_REGIST          @"device_token_regist"

@interface MyTool : NSObject

+ (void)removeValueforKey:(NSString *)str;
+ (void)writeValue:(id)value forKey:(NSString *)str;
+ (id)readValueForKey:(NSString *)str;
+ (NSString *)idfa;
/**1
 *
 *  此方法用于显示提示信息
 *  @param alertStr 提示信息
 *
 */
+ (void)showAlertView:(NSString*)alertStr;
+ (NSString *)getStringFromObj:(id)obj;

/**
 *
 *  此方法用于显示提示信息
 *  @param object 传入的json
 *  @return 转换后的字符串
 *
 */
+ (UIFont *)lightFontWithSize:(CGFloat)size;
+ (NSString *)jsonStrFromObj:(id)object;
// 平方 常规
+ (UIFont *)regularFontWithSize:(CGFloat)size;
//处理图片的方向信息
+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (void)arrayImageWithName:(NSString* )imageName block:(void(^)(NSArray* images))imgBlock;

    //获取认证信息状态
+ (id)getLocalInfoForKey:(NSString* )key;

    //获取产品额度列表
+ (id)getLocalQuotaProductList;

+ (id)phoneBlackList;

@end
