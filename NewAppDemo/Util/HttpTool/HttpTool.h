//
//  HttpTool.h
//  XNSudai
//
//  Created by zxl on 2017/3/24.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#define POSTSTR @"POST"
#define GETSTR  @"GET"

/*测试环境*/
/*
 #define BASE_URL_USER       @"https://test01user.xnsudai.com/"
 #define BASE_URL            @"https://test01loan.xnsudai.com/"
 #define BASE_URL_CARD       @"https://test01credit.xnsudai.com/"
 #define BASE_URL_COMMUNITY  @"https://test01community.xnsudai.com/"
 #define BASE_HUODONG        @"https://test01huodong.xnsudai.com/"
 #define BASE_URL_API        @"https://test01api.xnsudai.com/"
 
 #define BASE_LINK           @"https://test01gjh5.xnsudai.com/html/page/article_content.html"
 #define BASE_ARTICLE_LINK   @"https://test01gjh5.xnsudai.com/html/page/article_detail.html"
 #define BASE_MESSAGE        @"https://test01gjh5.xnsudai.com/html/page/loan_match/match.html"
 #define BASE_IDENTITY       @"https://test01gjh5.xnsudai.com/html/page/loan_match/identity.html"
 #define BASE_FEEDBACK       @"https://test01gjh5.xnsudai.com/html/page/feedback.html"
 #define BASE_ABOUT          @"https://test01gjh5.xnsudai.com/html/page/aboutus.html"
 #define BASE_HELP           @"https://test01gjh5.xnsudai.com/html/page/help_center.html"
 #define BASE_AGREEMENT      @"https://test01gjh5.xnsudai.com/html/page/contract.html"
*/

/*开发环境*/
/*
#define BASE_URL_USER       @"https://testuser.xnsudai.com/"
#define BASE_URL            @"https://testloan.xnsudai.com/"
#define BASE_URL_CARD       @"https://testcredit.xnsudai.com/"
#define BASE_URL_COMMUNITY  @"https://testcommunity.xnsudai.com/"
#define BASE_HUODONG        @"https://testhuodong.xnsudai.com/"
#define BASE_URL_API        @"https://testapi.xnsudai.com/"

#define BASE_LINK           @"https://testwww.xnsudai.com/html/page/article_content.html"
#define BASE_ARTICLE_LINK   @"https://testwww.xnsudai.com/html/page/article_detail.html"
#define BASE_MESSAGE        @"https://testwww.xnsudai.com/html/page/loan_match/match.html"
#define BASE_IDENTITY       @"https://testwww.xnsudai.com/html/page/loan_match/identity.html"
#define BASE_FEEDBACK       @"https://testwww.xnsudai.com/html/page/feedback.html"
#define BASE_ABOUT          @"https://testwww.xnsudai.com/html/page/aboutus.html"
#define BASE_HELP           @"https://testwww.xnsudai.com/html/page/help_center.html"
#define BASE_AGREEMENT      @"https://testwww.xnsudai.com/html/page/contract.html"
*/

/*生产环境*/

 #define BASE_URL_USER       @"https://user.xnsudai.com/"
 #define BASE_URL            @"https://loan.xnsudai.com/"
 #define BASE_URL_CARD       @"https://credit.xnsudai.com/"
 #define BASE_URL_COMMUNITY  @"https://community.xnsudai.com/"
 #define BASE_HUODONG        @"https://huodong.xnsudai.com/"
 #define BASE_URL_API        @"https://api.xnsudai.com/"
 
 #define BASE_LINK           @"https://gjh5.xnsudai.com/html/page/article_content.html"
 #define BASE_ARTICLE_LINK   @"https://gjh5.xnsudai.com/html/page/article_detail.html"
 #define BASE_MESSAGE        @"https://gjh5.xnsudai.com/html/page/loan_match/match.html"
 #define BASE_IDENTITY       @"https://gjh5.xnsudai.com/html/page/loan_match/identity.html"
 #define BASE_FEEDBACK       @"https://gjh5.xnsudai.com/html/page/feedback.html"
 #define BASE_ABOUT          @"https://gjh5.xnsudai.com/html/page/aboutus.html"
 #define BASE_HELP           @"https://gjh5.xnsudai.com/html/page/help_center.html"
 #define BASE_AGREEMENT      @"https://gjh5.xnsudai.com/html/page/contract.html"


#define NO_NET @"NO_NET"

@interface HttpTool : NSObject

+(BOOL)checkNetWork;
//直接调本地接口
+ (NSURLSessionDataTask *)myOriRequestWithBaseUrl:(NSString *)baseUrl
                                           urlStr:(NSString *)urlStr
                                          method:(NSString *)methodStr
                                      parameters:(NSDictionary *)parameters
                               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

+ (NSURLSessionDataTask *)myRequestWithBaseUrl:(NSString *)baseUrl
                                        urlStr:(NSString *)urlStr
                                       method:(NSString *)methodStr
                                   parameters:(NSDictionary *)parameters
                                      success:(void (^)(NSObject *resultObj))success
                                         fail:(void (^)(NSString *errorStr))fail;


+ (NSURLSessionDataTask* )noDesrequestWithBaseUrl:(NSString *)baseUrl
                                      urlStr:(NSString *)urlStr
                                      method:(NSString *)methodStr
                                  parameters:(NSDictionary *)parameters
                                     success:(void (^)(NSObject *resultObj))success
                                        fail:(void (^)(NSString *errorStr))fail;

+ (NSURLSessionUploadTask *)myRequestMultiUploadWithBaseUrl:(NSString *)baseUrl urlStr:(NSString *)urlStr parameters:(NSDictionary *)paramaters project:(NSDictionary *)projects success:(void (^)(NSObject *resultObj))success fail:(void (^)(NSString *errorStr))fail;

@end
