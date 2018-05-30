//
//  ShareManager.m
//  MasterDuoBao
//
//  Created by 汤丹峰 on 16/4/8.
//  Copyright © 2016年 wenzhan. All rights reserved.
//

#import "ShareManager.h"
#import "UIImageView+WebCache.h"
#import "VCManager.h"
#import "MyUITabBarController.h"
#import "AppDelegate.h"
#import "NSString+str.h"

@interface ShareManager ()
{
    NSString* _methodstr;
}
@end

@implementation ShareManager

static ShareManager *shareManager = nil;
+ (ShareManager *)defaultShareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[ShareManager alloc] init];
    });
    return shareManager;
}

//分享面板
- (void)showShare
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType title:_title contentDes:[NSString handleTagPWithString:_content] URL:_shareUrl];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title contentDes:(NSString *)des  URL:(NSString *)url
{
    NSString *media;
    switch (platformType) {
        case UMSocialPlatformType_QQ:
            media = @"QQ";
            break;
        case UMSocialPlatformType_Qzone:
            media = @"QZONE";
            break;
        case UMSocialPlatformType_WechatSession:
            media = @"WEIXIN";
            break;
        case UMSocialPlatformType_WechatTimeLine:
            media = @"WEIXIN_CIRCLE";
            break;
        default:
            break;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UIImage *thumbImage = [UIImage imageNamed:@"gj_share"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:des thumImage:_img?_img:thumbImage];
    shareObject.webpageUrl = url;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[VCManager shareVCManager].getTopViewController completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
