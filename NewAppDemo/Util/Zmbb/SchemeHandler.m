//
//  SchemeHandler.m
//  MasterDuoBao
//
//  Created by 汤丹峰 on 16/3/23.
//  Copyright © 2016年 wenzhan. All rights reserved.
//

#import "SchemeHandler.h"
#import "SchemeDefine.h"
#import "VCManager.h"
#import "MDUrl.h"
#import "XNWebVC.h"
#import "AppDelegate.h"
#import "MyUITabBarController.h"

@interface SchemeHandler ()

@property(nonatomic, strong) UIViewController *topWebController;

@end

@implementation SchemeHandler

static SchemeHandler *m_handler;
+ (id)defaultHandler
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        m_handler = [[SchemeHandler alloc] init];
    });
    return m_handler;
}

- (void)handleUrl:(NSString*)urlStr animated:(BOOL)animated
{
    [self handleUrl:urlStr animated:animated config:@""];
}

- (void)handleUrl:(NSString*)urlStr animated:(BOOL)animated config:(NSString *)config
{
    //先判断是否是以我们定义的scheme开始
    if (![SchemeHandler isLocalScheme:[NSURL URLWithString:urlStr]])
    {
        //直接跳转h5
        if([urlStr hasPrefix:@"http"]){
            [self handleOpenWeb:urlStr animated:animated config:@"h5"];
        }
        return;
    }
    //根据url,获取path类型:处理web和native
    NSURL *url = [NSURL URLWithString:urlStr];
//    NSString *value = [url getValueInQueryForKey:URL_QUERY_KEY_NAME isCaseSensitive:NO];
    
    NSString *needlogin = [url getValueInQueryForKey:URL_QUERY_KEY_NEED_LOGIN isCaseSensitive:NO];
    
    //需要先登入的情况，进入登入界面，登入成功后回调回来
//    if ([needlogin isEqualToString:@"1"]) {
//        if (!_CustomerInfo.token || [_CustomerInfo.token isEqualToString:@""]) {
//            [JumpTool loginAction];
//            return;
//        }
//    }
    //先判断域名是否是我们定义的域名
    if ([url.host isEqualToString:URL_HOST]) {
        NSString *path = url.path;
        
        //再判断路径
        if ([path isEqualToString:URL_PATH_WEB])
        {
            // /jump
            [self handleOpenWeb:urlStr animated:animated config:config];
        }
        else if ([path isEqualToString:URL_PATH_NATIVE])
        {
            // /native
            [self handleOpenNative:urlStr animated:animated config:config];
        }
        else if ([path isEqualToString:URL_PATH_SHARE])
        {
            // /share
            [self handleOpenShare:urlStr animated:animated config:config];
        }
        else if ([path isEqualToString:URL_PATH_CLOSR])
        {
            // /close
            [self handleOpenClose:urlStr animated:animated config:config];
        }
        else if ([path isEqualToString:URL_PATH_NATIVENEW])
        {
            // /native_new
            [self handleOpenNativeNew:urlStr animated:animated config:config];
        }
    }
}

//判断当前链接是否是自定义url
+ (BOOL)isLocalScheme:(NSURL*)urlStr
{
    if ([(NSString *)[urlStr scheme] rangeOfString:URL_SCHEME].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

#pragma mark - 协议处理
//处理jump协议
- (void)handleOpenWeb:(NSString*)urlStr animated:(BOOL)animated config:(NSString *)config
{
    UIViewController *webVC = [self generateWebVC:urlStr config:config];
    webVC.hidesBottomBarWhenPushed = YES;
    self.topWebController = webVC;
    
    UIViewController *currentVC = [[VCManager shareVCManager] getTopViewController];
    if (currentVC.navigationController.navigationBarHidden) {
        currentVC.navigationController.navigationBarHidden = NO;
    }
    
    [currentVC.navigationController pushViewController:webVC animated:animated];
}

//处理native协议
- (void)handleOpenNative:(NSString *)urlStr animated:(BOOL)animated config:(NSString *)config
{
    UIViewController *nativeVC = [self generateNativeVC:urlStr config:config];
    if (nativeVC) {
        nativeVC.hidesBottomBarWhenPushed = YES;
        
        UIViewController *currentVC = [[VCManager shareVCManager] getTopViewController];
        
        [currentVC.navigationController pushViewController:nativeVC animated:animated];
    }
}

//处理close协议
- (void)handleOpenClose:(NSString *)urlStr animated:(BOOL)animated config:(NSString *)config
{
    //关闭当前webVC
    if (self.topWebController.presentingViewController) {
        [self.topWebController dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.topWebController.navigationController.viewControllers];
        for (NSInteger i=mArr.count-1; i>=0; i--) {
            UIViewController *vc = mArr[i];
            if ([vc isKindOfClass:[self.topWebController class]]) {
                [mArr removeObject:vc];
                break;
            }
        }
        self.topWebController.navigationController.viewControllers = mArr;
    }
}

//处理native_new协议
- (void)handleOpenNativeNew:(NSString *)urlStr animated:(BOOL)animated config:(NSString *)config
{
    UIViewController *nativeVC = [self generateNativeNewVC:urlStr config:config];
    if (nativeVC) {
        nativeVC.hidesBottomBarWhenPushed = YES;
        
        UIViewController *currentVC = [[VCManager shareVCManager] getTopViewController];
        
        [currentVC.navigationController pushViewController:nativeVC animated:animated];
    }
}

//处理share协议
- (void)handleOpenShare:(NSString *)urlStr animated:(BOOL)animated config:(NSString *)config
{
    ShareManager *shareManager = [ShareManager defaultShareManager];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString* inviteCode = [url getValueInQueryForKey:URL_QUERY_KEY_INVITECODE isCaseSensitive:NO];
    NSString* param = [url getValueInQueryForKey:URL_QUERY_KEY_PARAM isCaseSensitive:NO];
    shareManager.img = [url getValueInQueryForKey:URL_QUERY_KEY_IMG isCaseSensitive:NO];
    shareManager.content = [url getValueInQueryForKey:URL_QUERY_KEY_CONTENT isCaseSensitive:NO];
    shareManager.title = [url getValueInQueryForKey:URL_QUERY_KEY_TITLE isCaseSensitive:NO];
    NSString* sUrl = [url getValueInQueryForKey:URL_QUERY_KEY_SHAREURL isCaseSensitive:NO];
#ifndef __IPHONE_10_1
    if([sUrl containsString:@"xnsudai.com"] && [sUrl hasPrefix:@"https"]){
        sUrl = [sUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    }
#endif
    shareManager.shareUrl = sUrl;
    if(inviteCode){
        shareManager.shareUrl = [NSString stringWithFormat:@"%@?inviteCode=%@", shareManager.shareUrl, inviteCode];
        if(param){
            shareManager.shareUrl = [NSString stringWithFormat:@"%@&param=%@", shareManager.shareUrl, param];
        }
    }else{
        if(param){
            shareManager.shareUrl = [NSString stringWithFormat:@"%@?param=%@", shareManager.shareUrl, param];
        }
    }
    
    shareManager.types = [url getValueInQueryForKey:URL_QUERY_KEY_TYPES isCaseSensitive:NO];
    
    [shareManager showShare];
}

#pragma mark - 创建ViewController
//生成显示H5页面的ViewController
- (UIViewController *)generateWebVC:(NSString *)urlStr config:(NSString *)config
{
    XNWebVC *vc = nil;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    vc = [[XNWebVC alloc] init];
    if([config isEqualToString:@"h5"]){
        vc.urlStr = urlStr;//原生连接
    }else{
        if ([url.host isEqualToString:URL_HOST]) {
            NSString *value = [url getValueInQueryForKey:URL_QUERY_KEY_URL isCaseSensitive:NO];
            vc.urlStr = value;
            vc.activityId = [url getValueInQueryForKey:URL_QUERY_KEY_ACTIVITYID isCaseSensitive:NO];
            vc.tStr = [url getValueInQueryForKey:URL_QUERY_KEY_TITLE isCaseSensitive:NO];
            value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            value = [url getValueInQueryForKey:URL_QUERY_KEY_RIGHTBTNTITLE isCaseSensitive:NO];
            if (value&&![value isEqualToString:@""]) {
                vc.rightBtnTitle = value;
            }
        }
    }
    return vc;
}

#pragma mark - 创建ViewController

/**
 一、协议xulugj://www.xulu.com/协议名？参数a=x&参数b=y
 
 二、通用参数
 是否需要登录 need_login=1 (1需要登录，0不需要)
 
 三、各种协议名及对应专属参数
 1、jump协议，跳转到新的网页,如xulugj://www.xulu.com/jump?need_login=1&url=http%3a%2f%2fh5.518yin.com%2fh5%2fIntegral%2findex.html
    （1）url参数，表示需要跳转的网页地址（需要url编码）
 2、native协议,跳转到app客户端某个界面
    （1）name参数，跳转到的界面类型
        首页 name=home 参数index=1(底部4个tab对应1-4)，如跳转到主页“我的”页面,xulugj://www.xulu.com/native?name=home&index=4
        登录 name=login
 **/
- (UIViewController *)generateNativeVC:(NSString *)urlStr config:config
{
//    BaseUIViewController *vc = nil;
//
//    NSURL *url = [NSURL URLWithString:urlStr];
//    if ([url.host isEqualToString:URL_HOST]) {
//
//        NSString *value = [url getValueInQueryForKey:URL_QUERY_KEY_NAME isCaseSensitive:NO];
//        if ([value isEqualToString:VC_LOGIN]||[value isEqualToString:VC_REGIST]) {
//            [JumpTool loginAction];
//        } else if ([value isEqualToString:VC_HOME]) {
//            NSString *index = [url getValueInQueryForKey:URL_QUERY_KEY_INDEX isCaseSensitive:NO];
//            UIViewController *currentVC = [[VCManager shareVCManager] getTopViewController];
//            currentVC.tabBarController.selectedIndex = MAX(0, MIN([index intValue], 3));
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [currentVC.navigationController popToRootViewControllerAnimated:NO];
//            });
//
//        }else if ([value isEqualToString:VC_PRODUCTDETAIL]){
//            NSString *productId = [url getValueInQueryForKey:URL_QUERY_KEY_PRODUCTID isCaseSensitive:NO];
//            vc = [[MainParticularsVC alloc]init];
//            MainParticularsVC* lpvc = (MainParticularsVC*)vc;
//            lpvc.productID = productId;
//        }else if ([value isEqualToString:VC_TOPICDETAIL]){
//            vc = [[ParticularsVC alloc]init];
//            ParticularsVC* pvc = (ParticularsVC* )vc;
//            pvc.articleId = [url getValueInQueryForKey:URL_QUERY_KEY_TOPIC isCaseSensitive:NO];
//        }else if ([value isEqualToString:VC_PERSONINFO]){
//            vc = [[PersonMaterialVC alloc] init];
//        }else if ([value isEqualToString:VC_UDESK_CALL]){
//            NSString* param = [url getValueInQueryForKey:URL_QUERY_KEY_PARAM isCaseSensitive:NO];
//            if([param isEqualToString:@"udesk"]){
//                [SkipCustomerService skipCustomerService];
//            }else if ([param isEqualToString:@"call"]){
//                UIApplication* app = [UIApplication sharedApplication];
//                NSURL* url = [NSURL URLWithString:@"tel://400-858-6969"];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    if([app canOpenURL:url]){
//                        [app openURL:url];
//                    }
//                });
//            }
//        }
//    }
//    return vc;
}
//解析url，获取native界面控制器名称，通过反射生产controller
- (UIViewController *)generateNativeNewVC:(NSString *)urlStr config:config
{
    BaseUIViewController *vc = nil;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    //ios取的类名参数叫i_name
    NSString *tempClassName = [url getValueInQueryForKey:URL_QUERY_KEY_INAME isCaseSensitive:NO];
    Class tempClass = NSClassFromString(tempClassName);
    vc = [[tempClass alloc] init];
    
    return vc;
}
#pragma mark - 功能函数


@end
