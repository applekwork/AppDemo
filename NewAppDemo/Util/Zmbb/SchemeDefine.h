//
//  SchemeDefine.h
//  MasterDuoBao
//
//  Created by 汤丹峰 on 16/3/23.
//  Copyright © 2016年 wenzhan. All rights reserved.
//

#ifndef SchemeDefine_h
#define SchemeDefine_h

//自定义协议头
#define URL_SCHEME          @"xulugj"
//自定义域名
#define URL_HOST            @"www.xulu.com"


//协议中的path标记
#define URL_PATH_WEB        @"/jump"        //跳H5
#define URL_PATH_NATIVE     @"/native"      //跳本地controller
#define URL_PATH_SHARE      @"/share"       //H5发出的分享
#define URL_PATH_CLOSR      @"/close"       //关闭当前控制器
#define URL_PATH_NATIVENEW  @"/native_new"  //跳本地二级或更深级controller


//协议中query的参数KEY
#define URL_QUERY_KEY_NAME              @"name"
#define URL_QUERY_KEY_INAME             @"i_name"
#define URL_QUERY_KEY_NEED_LOGIN         @"need_login"
#define URL_QUERY_KEY_TITLE             @"title"
#define URL_QUERY_KEY_TYPE             @"type"
#define URL_QUERY_KEY_INDEX             @"index"        //name=home时参数 第几个tab页面



#define URL_QUERY_KEY_URL               @"url"          //网页时传输下面四个参数
#define URL_QUERY_KEY_NAV               @"nav"
#define URL_QUERY_KEY_RIGHTBTNTITLE     @"right_btn_title"  //网页右上角按钮，可放刷新、分享、跳转等按钮
#define URL_QUERY_KEY_DISPLAY           @"display"


#define URL_QUERY_KEY_IMG               @"img"//分享的图片
#define URL_QUERY_KEY_CONTENT           @"content"//分享的内容
#define URL_QUERY_KEY_SHAREURL          @"share_url"//分享的url
#define URL_QUERY_KEY_INVITECODE        @"inviteCode"//分享邀请码
#define URL_QUERY_KEY_PARAM             @"param"//分享预留参数
#define URL_QUERY_KEY_TYPES             @"types"//分享类型

#define URL_QUERY_KEY_PRODUCTID         @"product_id"//产品详情id
#define URL_QUERY_KEY_ARTICLEID         @"article_id"//文章id
#define URL_QUERY_KEY_TOPIC             @"topic_id"//帖子id
#define URL_QUERY_KEY_ACTIVITYID        @"activityId"//活动id

//约定好的native界面名称参数值
#define VC_LOGIN            @"login"                //登录界面
#define VC_REGIST           @"regist"               //注册界面
#define VC_HOME             @"home"                 //主界面
#define VC_PRODUCTDETAIL    @"product_detail"       //产品详情界面
#define VC_ARTICLEDETAIL    @"article_detail"       //文章详情
#define VC_TOPICDETAIL      @"topic_detail"         //帖子详情
//#define VC_PERSONMESSAGE    @"person_message"       //个人资料
#define VC_PERSONINFO       @"persion_info"       //个人资料
#define VC_UDESK_CALL       @"udeskcall"      //在线客服




#endif /* SchemeDefine_h */
