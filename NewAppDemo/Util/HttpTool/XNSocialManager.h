//
//  XNSocialManager.h
//  XNManager
//
//  Created by Carlson Lee on 2017/7/5.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SOCIAL_TYPE){
    SOCIAL_TYPE_PAGE,//页面操作
    SOCIAL_TYPE_ACTIVE,//激活
    SOCIAL_TYPE_HOT,//活跃
    SOCIAL_TYPE_MORE,//更多
    SOCIAL_TYPE_OTHER//其他
};

@interface XNSocialManager : NSObject

/* 所有参数采用key-value(参数用双&隔开)
 * 如果是h5直接传index=0&&url=
 * 如果是子页面index=0&&pageId=
 
 参数：
 * areaId ：1-专区 2-产品 3-帖子
 * pageId ：专区ID/ 产品ID
 * index  ：立即申请为1 否则为0
 */

//适用页面、激活、活跃
+ (void)clickEvent:(NSString* )event withType:(SOCIAL_TYPE)type block:(void(^)(BOOL isSucceed))block;

//页面统计
+ (void)clickEvent:(NSString* )event;

//更多页面
+ (void)clickMoreEvent:(NSString* )event;

//下载激活
+ (void)activeEventWithBlcok:(void(^)(BOOL isSucceed))block;

//活跃
+ (void)hotKey:(NSString* )key withEvent:(void(^)())block;

@end
