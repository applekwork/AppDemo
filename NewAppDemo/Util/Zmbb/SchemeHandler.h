//
//  SchemeHandler.h
//
//
//  Created by zxl on 16/3/23.
//  Copyright © 2016年 xulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchemeDefine.h"

@interface SchemeHandler : NSObject

/**
 *  单例
 *
 *  @return SchemeHandler
 */
+ (id)defaultHandler;

/**
 *  判断当前链接是否是自定义url
 *
 *  @param urlStr NSURL
 *
 *  @return YES,是自定义url;NO,不是
 */
+ (BOOL)isLocalScheme:(NSURL*)urlStr;

/**
 *  对链接进行处理
 *
 *  @param urlStr   NSString
 *  @param animated BOOL
 */
- (void)handleUrl:(NSString*)urlStr animated:(BOOL)animated;


@end
