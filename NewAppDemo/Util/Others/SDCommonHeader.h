//
//  SDCommonHeader.h
//  XNManager
//
//  Created by Carlson Lee on 2017/4/27.
//  Copyright © 2017年 Carlson Lee. All rights reserved.
//

#ifndef SDCommonHeader_h
#define SDCommonHeader_h
#import "SDCommon.h"
#import "XNDefectView.h"
#import "XNSocialManager.h"
#import "VCManager.h"

#define BOUNDS_WIDTH self.bounds.size.width
#define BOUNDS_HEIGHT self.bounds.size.height
#define STATUS_BAR_HEIGHT CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define NAV_HEIGHT CGRectGetHeight(self.navigationController.navigationBar.frame)
#define TAB_HEIGHT CGRectGetHeight(self.tabBarController.tabBar.frame)
#define XN_IMG(_name_) [UIImage imageNamed:_name_]
#define IPHONE_VERSION(x) ([[UIDevice currentDevice] systemVersion].floatValue >= x)

#define PICKVIEW_HEIGHT 180

#define WEAK_SELF __weak typeof(self) weakSelf = self;

#define DEFAULT_ALL @"600"//默认以上全部
#define DEFAULT_SORT @"700"//默认排序

#if 1
//返回一个对象
#define XN_NEW_OBJECT(_object_name_,_class_name_,_superView_)\
if(!_object_name_){\
_object_name_ = [[_class_name_ alloc]init];\
if(_superView_)[_superView_ addSubview:_object_name_];\
}\
return _object_name_;\

//返回一个配置的label
#define XN_NEW_LABEL(_object_name_,_bg_color_,_text_color_,_font_,_type_,_lines_,_superView_)\
if(!_object_name_){\
_object_name_ = [UILabel new];\
[_object_name_ setBackgroundColor:_bg_color_?_bg_color_:[UIColor clearColor]];\
[_object_name_ setTextColor:_text_color_];\
[_object_name_ setFont:_font_];\
[_object_name_ setTextAlignment:_type_];\
[_object_name_ setNumberOfLines:_lines_];\
if(_superView_)[_superView_ addSubview:_object_name_];\
}\
return _object_name_;\


#define XNLabel(_object_name_,_bg_color_,_text_color_,_font_,_type_,_lines_,_superView_)\
if(!_object_name_){\
_object_name_ = [XNLabel new];\
[_object_name_ setBackgroundColor:_bg_color_?_bg_color_:[UIColor clearColor]];\
[_object_name_ setTextColor:_text_color_];\
[_object_name_ setFont:_font_];\
[_object_name_ setTextAlignment:_type_];\
[_object_name_ setNumberOfLines:_lines_];\
if(_superView_)[_superView_ addSubview:_object_name_];\
}\
return _object_name_;\

#endif

#define KAPPLICATIONSTATE   @"k_application_state"
#define KPREFECTUREINDENTIFY    @"k_community_prefecture_indentify"//专区
#define KAPPLOGINSTATE  @"k_app_login_state"
#define KPRODUCTSTATE   @"k_product_state"
#define K_CREDIT_GET_DATA @"k_credit_get_data"//获取信用报告

#endif /* SDCommonHeader_h */
