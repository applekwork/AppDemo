//
//  HttpTool.m
//  XNSudai
//
//  Created by zxl on 2017/3/24.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import "HttpTool.h"
#import "NSString+MD5.h"
#import "JKEncrypt.h"
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"

@interface HttpTool ()

@end

#define APP_NUM @"1"
@implementation HttpTool

+(BOOL)checkNetWork{
    BOOL isExistenceNetWork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable://无网络
            isExistenceNetWork = FALSE;
            break;
        case ReachableViaWWAN://使用3G或RPRS
            isExistenceNetWork = TRUE;
            break;
        case ReachableViaWiFi://使用WiFi
            isExistenceNetWork = TRUE;
            break;
    }
    return isExistenceNetWork;
}

+ (void)prepareManager:(AFURLSessionManager *)manager{
    // 1.初始化单例类
    // 2.设置证书模式
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];;
    // 客户端是否信任非法证书
    policy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    [policy setValidatesDomainName:NO];
    manager.securityPolicy = policy;
}

+ (NSURLSessionDataTask *)myOriRequestWithBaseUrl:(NSString *)baseUrl
                                          urlStr:(NSString *)urlStr
                                          method:(NSString *)methodStr
                                      parameters:(NSDictionary *)parameters
                               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    [HttpTool prepareManager:manager];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    if (parameters) {
        [tempDic setValuesForKeysWithDictionary:parameters];
    }
    NSTimeInterval time = [[NSDate new] timeIntervalSince1970];
    [tempDic setObject:[NSString stringWithFormat:@"%f",time] forKey:@"timestamp"];
    NSString *sign = [HttpTool getSign:tempDic];
    NSDictionary *newParamDic = @{@"data":tempDic,@"sign":sign?:@""};
    //参数加密
    NSString *dicSTr = [self dictionaryEncryptStr:newParamDic andIs3DES:YES];
    //    [AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:methodStr URLString:[NSString stringWithFormat:@"%@%@",baseUrl,urlStr] parameters:dicSTr error:nil];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 15;
//    [request setValue:[[UserAgent ShardInstnce] getUserAgent] forHTTPHeaderField:@"User-Agent"];
//    [request setValue:APP_NUM forHTTPHeaderField:@"App"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil  completionHandler:completionHandler];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionDataTask *)myRequestWithBaseUrl:(NSString *)baseUrl
                                        urlStr:(NSString *)urlStr
                                       method:(NSString *)methodStr
                                   parameters:(NSDictionary *)parameters
                                      success:(void (^)(NSObject *resultObj))success
                                         fail:(void (^)(NSString *errorStr))fail{
    if (![HttpTool checkNetWork]) {
        fail(NO_NET);
        return nil;
    }
    return [HttpTool myOriRequestWithBaseUrl:baseUrl urlStr:urlStr method:methodStr parameters:parameters completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (error.code==-1001) {
                if(fail)fail(@"请求超时");
                return;
            }
            DLog(@"urlStr error:%@",error.description);
            if(fail)fail(@"网络异常");//网络链接问题或者请求地址有误
        } else {
            NSDictionary *dic = responseObject;
            
            if (dic&&[dic isKindOfClass:[NSDictionary class]]) {
                NSObject *codeStr = dic[@"returnCode"];
                if ([codeStr isKindOfClass:[NSNull class]]) {
                    if(fail)fail(@"请求失败");
                    return;
                }
                NSString *dataStr = dic[@"data"];
                if ([dic[@"returnCode"] intValue]==500) {
                    if (dic[@"errorMsg"]) {
                        if(fail)fail(dic[@"errorMsg"]);
                        return ;
                    }
                }
                if ([dic[@"returnCode"] intValue]==200&&dataStr) {
                    //参数解密
                    id resultData = [self dictionaryDecEncryptStr:dataStr andIs3DES:YES];
                    if (resultData == nil ) {
                        DLog(@"%@--responseObject:%@", urlStr, dic);
                    }else{
                        DLog(@"%@--resultData:%@", urlStr, resultData);
                    }
                    
                    if(success)success(resultData);
                    return;
                }
            }else{
                if(fail)fail(@"请求失败");//返回数据格式错误
            }
        }
        
    }];
}


//+ (NSString *)picSign:(NSDictionary *) paramaters{
//
//}

+ (NSURLSessionUploadTask *)myRequestMultiUploadWithBaseUrl:(NSString *)baseUrl urlStr:(NSString *)urlStr parameters:(NSDictionary *)paramaters project:(NSDictionary *)projects success:(void (^)(NSObject *resultObj))success fail:(void (^)(NSString *errorStr))fail
{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", baseUrl, urlStr] parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (id key in [projects allKeys]) {
            //代表的文件对应的参数
            NSString *name = key;
            DLog(@"----+++++-----%@", name);
            //文件的名字
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", name];
            NSData *data;
            id proData = [projects objectForKey:key];
            if ([proData isKindOfClass:[NSString class]]) {
                NSURL *fileUrl = [NSURL fileURLWithPath:proData];
                NSString *extension = fileUrl.pathExtension;
                NSString* mineType = @"";
                fileName = [fileUrl lastPathComponent];
                if([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"png"]){
                    mineType = [NSString stringWithFormat:@"image/%@", extension];
                }else if ([extension isEqualToString:@"mp4"]){
                    mineType = [NSString stringWithFormat:@"video/%@", extension];
                }else{
                    
                }
                [formData appendPartWithFileURL:fileUrl name:name fileName:fileName mimeType:mineType error:nil];
            } else if ([proData isKindOfClass:[UIImage class]]) {
                
                data = [PublicMethod depressImageData:proData];
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
            }else if ([proData isKindOfClass:[NSData class]]){
                
                data = proData;
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
            } else{
                data = [NSData dataWithContentsOfURL:proData];
                while (data == nil) {
                    data = [NSData dataWithContentsOfURL:proData];
                }
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
            }
            
        }
        
    } error:nil];
    request.timeoutInterval = 60;
//    [request setValue:[[UserAgent ShardInstnce] getUserAgent] forHTTPHeaderField:@"User-Agent"];
    [request setValue:APP_NUM forHTTPHeaderField:@"App"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [HttpTool prepareManager:manager];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [progressView setProgress:uploadProgress.fractionCompleted];
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (error.code==-1001) {
                fail(@"请求超时");
                return;
            }
            DLog(@"urlStr error:%@",error.description);
            fail(@"网络异常");//网络链接问题或者请求地址有误
        } else {
            NSDictionary *dic = responseObject;
            if (dic&&[dic isKindOfClass:[NSDictionary class]]) {
                NSObject *codeStr = dic[@"returnCode"];
                if ([codeStr isKindOfClass:[NSNull class]]) {
                    fail(@"请求失败");
                    return;
                }
                id resultData = dic[@"data"];
                if ([dic[@"returnCode"] intValue]==200) {
                    //参数解密
//                    id resultData = [self dictionaryDecEncryptStr:dataStr andIs3DES:YES];
                    DLog(@"--resultData:%@", resultData);
                    success(resultData);
                    return;
                }else{
                    NSString *msg = dic[@"errorMsg"];
                    if (msg&&[msg isKindOfClass:[NSString class]]) {
                        fail(msg);
                    }else{
                        fail(@"请求失败");//未返回错误信息
                    }
                }
            }else{
                fail(@"请求失败");//返回数据格式错误
            }
        }

    }];
    
    [uploadTask resume];
    
    return uploadTask;
}
+ (NSURLSessionDataTask* )noDesrequestWithBaseUrl:(NSString *)baseUrl
                                           urlStr:(NSString *)urlStr
                                           method:(NSString *)methodStr
                                       parameters:(NSDictionary *)parameters
                                          success:(void (^)(NSObject *resultObj))success
                                             fail:(void (^)(NSString *errorStr))fail
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    [HttpTool prepareManager:manager];
    
    AFHTTPResponseSerializer* response = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = response;
    
    AFJSONRequestSerializer* requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest* request = [requestSerializer requestWithMethod:methodStr URLString:[NSString stringWithFormat:@"%@%@",baseUrl,urlStr] parameters:parameters error:nil];
    request.timeoutInterval = 10;
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error){
            NSString *result1 = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *jsonData = [result1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
            success(result);
        }else{
            fail(@"");
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

+ (NSString *)getSign:(NSDictionary *)tempDic{
    NSArray *keys = [tempDic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2];
    }];
    NSString *str = @"";
    for (NSInteger i=0; i<sortedArray.count; i++) {
        NSString *key = sortedArray[i];
        str = [NSString stringWithFormat:@"%@%@%@=%@",str,i==0?@"":@"&",key,tempDic[key]];
    }
//    //进行base64编码
//    NSData *nsdata = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
//    
//    //base64解码
//    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:base64Encoded options:0];
//    NSString *base64Decoded = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
//    NSLog(@"Decoded: %@", base64Decoded);
    
    return [NSString stringToMD5:str];
}

//json字符串转json字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    
    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    
    return dic;
}
#pragma mark - 3des 加密

//字典（key-value）参数加密
+ (NSString *)dictionaryEncryptStr:(NSDictionary *)paramDic andIs3DES:(BOOL)is3DES
{
    NSString *dicSTr;
    if (paramDic == nil) {
        dicSTr = nil;
    }else{
        NSData *dicData = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:nil];
        dicSTr = [[NSString alloc] initWithData:dicData encoding:NSUTF8StringEncoding];
        DLog(@"请求的参数 ============%@============",dicSTr);
    }
    if (is3DES) {
        JKEncrypt * en;
        en = [[JKEncrypt alloc]init];
        dicSTr = [en doEncryptStr:dicSTr];
    }
    
    return dicSTr;
}
//数据解密
+ (id)dictionaryDecEncryptStr:(id)responseObject andIs3DES:(BOOL)is3DES
{
    if (is3DES && ![[PublicMethod builtDataString:responseObject] isEqualToString:@""]) {
        JKEncrypt * en;
        en = [[JKEncrypt alloc]init];
        responseObject = [en doDecEncryptStr:responseObject];
        if ([responseObject rangeOfString:@"{"].location != NSNotFound) {
            responseObject = [HttpTool dictionaryWithJsonString:responseObject];
        }
    }
    return responseObject;
}

@end
