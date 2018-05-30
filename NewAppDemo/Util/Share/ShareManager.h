//
//  ShareManager.h
//  MasterDuoBao
//
//  Created by 汤丹峰 on 16/4/8.
//  Copyright © 2016年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ShareManager : NSObject

+ (ShareManager *)defaultShareManager;
//显示分享view
- (void)showShare;

@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *shareUrl;
//分享类型 1-微信好友 2-微信朋友圈 3-qq好友 4-qq空间 5-新浪微博
@property (nonatomic , copy)NSString *types;

@end
