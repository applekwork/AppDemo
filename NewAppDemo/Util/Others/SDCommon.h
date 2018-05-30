//
//  SDCommon.h
//  XNSudai
//
//  Created by Carlson Lee on 2017/4/1.
//  Copyright © 2017年 Carlson Lee. All rights reserved.
//  通用类

#import <Foundation/Foundation.h>

//枚举类型
typedef NS_ENUM(NSInteger, SA_TYPE){//专区
    SA_TYPE_ALL = 0,//所有产品
    SA_TYPE_TOP_EASY = 1<<0,//易通过
    SA_TYPE_TOP_FAST = 1<<1,//放款快
    SA_TYPE_TOP_LOW = 1<<2,//低利率
    SA_TYPE_TOP = SA_TYPE_TOP_EASY|SA_TYPE_TOP_FAST|SA_TYPE_TOP_LOW,//top
    
    SA_TYPE_CATE_STU = 1<<3,//学生可贷
    SA_TYPE_CATE_FACE = 1<<4,//刷脸
    SA_TYPE_CATE_NEW = 1<<5,//新品
    SA_TYPE_CATE = SA_TYPE_CATE_STU|SA_TYPE_CATE_FACE|SA_TYPE_CATE_NEW,//类型
    
    SA_TYPE_TOOL_CALC = 1<<6,//计算
    SA_TYPE_TOOL = SA_TYPE_TOOL_CALC//工具
};

typedef NS_ENUM(NSInteger, MP_MODULE){
    MP_MODULE_LIST = 1,//首页推荐列表
    MP_MODULE_BANNER,//薅羊毛
    MP_MODULE_ARTICLE,//达人攻略
    MP_MODULE_CANLOAD,//看看我能贷
    MP_MODULE_CARD//卡片
};

typedef NS_ENUM(NSInteger, FONT_TYPE){
    FONT_TYPE_REGULAR, //常规
    FONT_TYPE_MEDIUM,//粗体
    FONT_TYPE_LIGHT, //细体
    FONT_TYPE_DISPLAY
};

typedef NS_ENUM(NSInteger, QUERY_TYPE){
    QUERY_TYPE_1 = 1,//需求筛选
    QUERY_TYPE_2,//身份筛选
    QUERY_TYPE_3,//筛选
    QUERY_TYPE_S//搜索
};

typedef NS_ENUM(NSInteger, MY_LOAD){
    MY_LOAD_DEFAULT = 1,
    MY_LOAD_DONE = 1<<1,//已申请
    MY_LOAD_NO_SCAN = 1<<2|MY_LOAD_DEFAULT,//未浏览
    MY_LOAD_UP = 1<<3|MY_LOAD_DEFAULT,//不想申请
    MY_LOAD_CARD = 1<<4|MY_LOAD_DEFAULT,//卡片
    MY_LOAD_First = 1 <<5 //首页
};

extern CGSize XNFS(CGFloat size, FONT_TYPE tp);
//字体大小
extern UIFont* XNFont(CGFloat size, FONT_TYPE tp);
//字体size
extern CGSize XNSize(NSString* str, UIFont* font, CGSize size);
//字体缩进，居左
CGSize XNParaSzie(NSString* str, UIFont* font, CGFloat lineIndex, CGSize size);

extern NSInteger loadTypeTrans(MY_LOAD tp);

id XN_BNEW_OBJECT(Class _class_name_, id _superView_);
id XN_BNEW_LABEL(UIColor* _bg_color_, UIColor* _text_color_, UIFont* _font_, NSTextAlignment _type_, NSInteger _lines_, id _superView_);
//颜色
UIColor* colorWithHexRGBStr(NSString* colorStr);
NSString* stringDisposePoint(NSString* dp);
//去除浮点数后面的0
NSString* stringDispose(float floatValue);
NSString* stringTransFloor(NSString* fr);
NSString* stringTransInt(NSString *fr);
@interface SDCommon : NSObject

+ (NSString* )transType:(SA_TYPE )type;

//版本
+ (BOOL)compareVerLocal:(NSString* )localVer app:(NSString* )appVer;

+ (NSString* )pathWithName:(NSString* )name;

//贷款时间
+ (NSArray* )loadTimes;

//反馈屏蔽
+ (NSArray* )feedBackCondition;

@end
