//
//  XNWebVC.h
//  XNManager
//
//  Created by Carlson Lee on 2017/5/9.
//  Copyright © 2017年 Carlson Lee. All rights reserved.
//  此web为协议跳转h5

#import <UIKit/UIKit.h>

@interface XNWebVC : BaseUIViewController

@property(nonatomic, strong)NSString* urlStr;//跳转url
@property(nonatomic, strong)NSString* tStr;//标题
@property(nonatomic, strong)NSString *rightBtnTitle;//右键
@property(nonatomic, strong)NSString* activityId;

- (instancetype)initWithUrl:(NSString* )urlStr;
- (instancetype)initWithUrl:(NSString* )urlStr title:(NSString* )title;

- (void)injectionJS:(NSString* )js;

- (void)countTimeWithblock:(void(^)(NSTimeInterval t))block;

@end
