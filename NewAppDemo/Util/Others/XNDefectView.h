//
//  XNDefectView.h
//  XNManager
//
//  Created by Carlson Lee on 2017/5/22.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DEFECT_TYPE){
    DEFECT_TYPE_DEFAULT,//默认空页面
    DEFECT_TYPE_NET_ERROE,//网络错误
    DEFECT_TYPE_LOAD_ERROR,//加载失败
    DEFECT_TYPE_NO_VALUE, //无数据
    DEFECT_TYPE_NO_ATTENTION, //无关注
    DEFECT_TYPE_NO_FANS,  //无粉丝
    DEFECT_TYPE_NO_MESSAGE, //无消息
};

@interface XNDefectView : UIView

@property(nonatomic, assign)DEFECT_TYPE type;

@property(nonatomic, copy)void(^ _Nullable block)();

@property(nonatomic, strong, nullable)NSString* dImgStr;
@property(nonatomic, strong, nullable)NSString* dLabStr;
@property(nonatomic, strong, nullable)NSString* dBtnStr;

- (nullable instancetype)initWithType:(DEFECT_TYPE )type;

- (nullable instancetype)initWithDefectImgStr:(nullable NSString* )imgStr tStr:(nullable NSString* )tStr btnStr:(nullable NSString* )bStr;

- (void)showDefect:(BOOL)isShow block:(void(^_Nullable)())block;

@end
