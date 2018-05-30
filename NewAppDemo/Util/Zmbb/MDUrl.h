//
//  MDUrl.h
//  MoviData
//
//  Created by SuperD on 15/11/2.
//  Copyright (c) 2015 SuperD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDUrl : NSObject

@property (nonatomic,strong) NSString* scheme;
@property (nonatomic,strong) NSString* user;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* host;
@property (nonatomic,strong) NSString* path;
@property (nonatomic,strong) NSString* port;
@property (nonatomic,strong) NSString* fragment;
@property (nonatomic,strong) NSString* parameterString;

/**
 *	根据一个NSUrl对象新建一个MDUrl
 */
+ (id)urlWithNSURL:(NSURL*)url;

/**
 *	urlStr : 初始化的url字符串
 *	返回一个新的对象
 */
+ (id)urlWithString:(NSString*)urlStr;

/**
 *	返回一个新的MDUrl对象 并设定scheme host path
 */
+ (id)urlWithScheme:(NSString*)scheme host:(NSString *)host path:(NSString *)path;

/**
 *	添加一个query参数 已经存在相同的则替换
 */
- (void)setQuery:(NSString*)value forKey:(NSString*)key;

/**
 *	添加一段query字符串
 */
- (void)setQueryString:(NSString*)query;

/**
 *	将dic中的key value添加到query中，已经存在相同的则替换
 */
- (void)setQueryFromDic:(NSDictionary*)dic;

/**
 *获取整个query string
 *如果没有query则返回nil
 */
- (NSString*)getQueryString;

/**
 *	移除一个query参数,默认严格区分大小写
 */
- (void)removeQueryForKey:(NSString*)key;

/**
 *	移除一个query参数,指定是否大小写敏感
 */
- (void)removeQueryForKey:(NSString *)key isCaseSensitive:(BOOL)sensitive;

/**
 *	检测query是否存在
 */
- (BOOL)queryExist:(NSString*)key isCaseSensitive:(BOOL)yesOrNo;

/**
 *  获取指定query
 */
- (NSString*)queryForKey:(NSString*)key isCaseSensitive:(BOOL)yesOrNo;

- (NSDictionary *)getQueryDic;

/**
 *	生成新的NSUrl对象
 */
- (NSURL*)buildUrl;

@end





/****
 *	为了兼容原有的NSURL+Ordertrack类以及一些特殊场景下的简单使用
 *	提供一些简易的url拼接，和属性获取方法
 *	复杂的应用方式，比如需要对URL进行多次修改和查询等操作简易使用MDUrl类
 ****/
@interface NSURL (MDUrl)

/**
 *	检测url中是否存在对应的query
 */
- (BOOL)checkExistInQuery:(NSString*)key isCaseSensitive:(BOOL)yesOrNo;

- (NSDictionary *)getQueryDic;
/**
 *	获取url中对应的query
 */
- (NSString*)getValueInQueryForKey:(NSString*)key isCaseSensitive:(BOOL)yesOrNo;

/**
 *	通过指定一个url和需要更新的query参数(query只接受标准格式key=value)，生成一个新的url
 */
+ (NSURL*)URLWithString:(NSString*)originalString addQuerys:(NSArray*)toAdd delQuerys:(NSArray*)toDel isCaseSensitive:(BOOL)yesOrNo;

@end
