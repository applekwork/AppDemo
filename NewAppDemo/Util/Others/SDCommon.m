//
//  SDCommon.m
//  XNSudai
//
//  Created by Carlson Lee on 2017/4/1.
//  Copyright © 2017年 Carlson Lee. All rights reserved.
// 通用类

#import "SDCommon.h"

@implementation SDCommon

+ (NSArray* )feedBackCondition
{
    return @[@"额度小", @"流程复杂", @"利率太高", @"审核被拒"];
}

+ (NSArray* )loadTimes
{
    return @[@{@"labelCode":@"1", @"labelName":@"15天以内", @"subStr":@"天以内"},
             @{@"labelCode":@"2", @"labelName":@"15~30天", @"subStr":@"天"},
             @{@"labelCode":@"3", @"labelName":@"1~3个月", @"subStr":@"个月"},
             @{@"labelCode":@"4", @"labelName":@"3个月以上", @"subStr":@"个月以上"}];
}

//专区类型
+ (NSString* )transType:(SA_TYPE )type
{
    switch (type) {
        case SA_TYPE_ALL:{
            return DEFAULT_ALL;
        }
            break;
        case SA_TYPE_TOP_EASY:{
            return @"1";
        }
            break;
        case SA_TYPE_TOP_FAST:{
            return @"2";
        }
            break;
        case SA_TYPE_TOP_LOW:{
            return @"3";
        }
            break;
        case SA_TYPE_CATE_STU:{
            return @"4";
        }
            break;
        case SA_TYPE_CATE_FACE:{
            return @"5";
        }
            break;
        case SA_TYPE_CATE_NEW:{
            return @"6";
        }
            break;
        default:
            return DEFAULT_ALL;
            break;
    }
}
//去后面逗号
NSString* stringDisposePoint(NSString* dp){
    NSInteger len = dp.length;
    for(NSInteger i=len-1; i>=0; i++){
        if([dp hasSuffix:@","]){
            dp = [dp substringToIndex:[dp length]-1];
        }else{
            break;
        }
    }
    return dp;
}

//去除浮点数后面的0
NSString* stringDispose(float floatValue)
{
    NSString *str = [NSString stringWithFormat:@"%.3f",floatValue];
    long len = str.length;
    for (int i = 0; i < len; i++){
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."]){//避免像2.0000这样的被解析成2.
        //s.substring(0, len - i - 1);
        return [str substringToIndex:[str length]-1];
    }else{
        return str;
    }
}

//金额转换
NSString* stringTransFloor(NSString* fr){
    if([fr floatValue]>=10000){
        fr = [[fr componentsSeparatedByString:@"."] firstObject];
        CGFloat ft = [fr integerValue]/10000.0;
        return stringDispose(ft);
    }
    return fr;
}
NSString* stringTransInt(NSString* fr){
    if([fr floatValue]>10000){
        CGFloat ft = [fr integerValue]/10000.0;
        NSString *str = [NSString stringWithFormat:@"%f",ft];
       return  [NSString stringWithFormat:@"%@万",[str substringWithRange:NSMakeRange(0, 3)]];
    } else {
        return fr;
    }
}

/**
 *
 */
NSString* fontName(FONT_TYPE tp){
    switch (tp) {
        case FONT_TYPE_REGULAR:{
            return @"PingFangSC-Regular";
        }
            break;
        case FONT_TYPE_MEDIUM:{
            return @"PingFangSC-Medium";
        }
            break;
        case FONT_TYPE_LIGHT:{
            return @"PingFangSC-Light";
        }
            break;
        case FONT_TYPE_DISPLAY:{
            return @".SFNSDisplay";
        }
            break;
        default:
            break;
    }
}


/**
 *
 */
UIFont* XNFont(CGFloat size, FONT_TYPE tp){
    UIFont* font = [UIFont fontWithName:fontName(tp) size:size*ScaleX];
    if(!font){
        font = [UIFont systemFontOfSize:size*ScaleX];
    }
    return font;
}

/**
 *  初始化对象
 */
id XN_BNEW_OBJECT(Class _class_name_, id _superView_){
    id _object_name_ = [_class_name_ new];
    if(_superView_)[_superView_ addSubview:_object_name_];
    return _object_name_;
}

/**
 *  初始化label
 */
id XN_BNEW_LABEL(UIColor* _bg_color_, UIColor* _text_color_, UIFont* _font_, NSTextAlignment _type_, NSInteger _lines_, id _superView_){
    UILabel* _object_name_ = [[UILabel alloc]init];
    [_object_name_ setBackgroundColor:_bg_color_?_bg_color_:[UIColor clearColor]];
    [_object_name_ setTextColor:_text_color_];
    [_object_name_ setFont:_font_];
    [_object_name_ setTextAlignment:_type_];
    [_object_name_ setNumberOfLines:_lines_];
    [_object_name_ setAdjustsFontSizeToFitWidth:YES];
    if(_superView_)[_superView_ addSubview:_object_name_];
    return _object_name_;
}

/**
 *单个字体的大小
 */
CGSize XNFS(CGFloat size, FONT_TYPE tp)
{
    return [@"管" sizeWithAttributes:@{NSFontAttributeName:XNFont(size, tp)}];
}

/**
 *文字+英文/数字混合计算会有误差
 */
CGSize XNSize(NSString* str, UIFont* font, CGSize size){
    if(!str || !str.length)return CGSizeZero;
    if(!size.width || !size.height){
        return [str sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

/** 首行缩进
 *文字+英文/数字混合计算会有误差
 */
CGSize XNParaSzie(NSString* str, UIFont* font, CGFloat lineIndex, CGSize size){
    if(!str || !str.length)return CGSizeZero;
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    style.headIndent = 0.0f;
    style.firstLineHeadIndent = lineIndex;
    if(!size.width || !size.height){
        return [str sizeWithAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    }
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style} context:nil].size;
}

NSInteger loadTypeTrans(MY_LOAD tp){
    switch (tp) {
        case MY_LOAD_DONE:{
            return 1;
        }
            break;
        case MY_LOAD_NO_SCAN:{
            return 0;
        }
            break;
        case MY_LOAD_UP:{
            return 2;
        }
            break;
        default:
            return 0;
            break;
    }
}

/**
 *16字符串转颜色
 */
UIColor* colorWithHexRGBStr(NSString* colorStr){
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != colorStr)
    {
        colorStr = [colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
        NSScanner *scanner = [NSScanner scannerWithString:colorStr];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

/**
 app版本更新

 @param localVer 本地版本
 @param appVer 服务器版本
 @return appVer>localVer?Yes:No
 */
+ (BOOL)compareVerLocal:(NSString* )localVer app:(NSString* )appVer
{
    NSString* local = [localVer stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString* app = [appVer stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger num = abs(local.length-app.length);
    for(NSInteger i=0; i<num; i++){
        if(local.length>app.length){
            app = [app stringByAppendingString:@"0"];
        }else{
            local = [local stringByAppendingString:@"0"];
        }
    }
    return [app integerValue]>[local integerValue]?YES:NO;
}



+ (NSString* )pathWithDocument:(NSString* )doc
{
    //NSTemporaryDirectory()
    NSString* file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if(doc && doc.length>0){
        file = [file stringByAppendingPathComponent:doc];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]){
        [[NSFileManager defaultManager]createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return file;
    
}

+ (NSString* )pathWithName:(NSString* )name
{
    return [[SDCommon pathWithDocument:@""] stringByAppendingPathComponent:name];
}



@end
