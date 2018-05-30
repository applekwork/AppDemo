//
//  PublicMethod.h
//  XNSudai
//
//  Created by lxr on 2017/3/28.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicMethod : NSObject
//网络请求参数
+ (NSMutableDictionary *)buildHTTPDataDicWithkeyArray:(NSArray *)keyArray ValueArray:(NSArray *)valueArray ;

// 时间戳转时间的方法
+ (NSString *)timeWithTimeIntervalString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat;

//几天以后的时间
+ (NSString *)timeAfterDays:(NSString *)addDay;

//后四位银行卡号码
+ (NSString *)getLastNumber:(NSString *)bankID withLastNum:(NSInteger)num;

//加载网络图片
+ (void)setImageForImageView:(UIImageView *)imgView withUrlStr:(NSString *)ImgUrl withIsIcon:(BOOL)isIcon withPlaceholderImageName:(NSString *)imgStr;

//处理数据，避免null
+ (id)builtDataString:(id)dataStr;

//渐变色设置
+ (void)setChangeColors:(UIView *)myView  andStartColor:(UIColor *)inputColor0  andEndColor:(UIColor *)inputColor1;

#pragma mark - <封装控件>

//----------- 控件 UILabel －－－－－－－－
+ (UILabel *)setupLabel:(CGRect)frame withText:(NSString *)text withFontSizde:(CGFloat)fontSize withTextColor:(UIColor *)color;

//设置label行间距
+ (void)setupLinePaceWithLabel:(UILabel *)label withLineSpace:(float)lineSpace;

//设置不同字体颜色
+(void)setTextColor:(UILabel *)label andFontNumber:(UIFont *)font andRangeStr:(NSString *)rangeStr andColor:(UIColor *)vaColor;
//设置Button不同字体颜色
+(void)setButtonTextColor:(UIButton *)button andFontNumber:(UIFont *)font andRange:(NSRange)range andColor:(UIColor *)color;
//获取label的高度
+ (CGFloat)getLabelHeight:(CGFloat)labelWith withText:(NSString *)str withFont:(UIFont *)font;

//----------- 控件 UIButton －－－－－－－－
+ (UIButton *)setupButton:(CGRect)frame withFontSize:(CGFloat)fontSize withBGColor:(UIColor *)bgColor withTitle:(NSString *)str withTitleColor:(UIColor *)color withImage:(UIImage *)image withLayerRound:(CGFloat)round;
//----------- 控件 UITextField UITextView －－－－－－－－
+ (UITextField *)setupTextField:(CGRect)frame withFontSize:(CGFloat)fontSize withPlaceholdText:(NSString *)placeholdText withborderStyle:(UITextBorderStyle)style;
//手机号验证
+(BOOL)isValidateMobile:(NSString *)mobile;
//身份证号验证
+(BOOL)isValidateIdCard:(NSString *)idCardStr;
+ (BOOL)verifyIDCardNumber:(NSString *)IDCardNumber;
+ (BOOL)verifyCardNameIsCN:(NSString *)cardStr;
+ (NSString *)getShowStr:(NSString *)mobile;
//手机密码验证
+(BOOL)isValidatePassword:(NSString *)pw;
//验证码验证
+(BOOL)isValidateVerifyCode:(NSString *)code;
//登录密码验证
+(BOOL)isValidateLogonPassword:(NSString *)code;
//判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)str;
//等比例缩放图片的大小
+ (UIImage *)scaleToSize:(UIImage *)img toScale:(float)scaleSize;
//Imagedata压缩
+ (NSData *)depressImageData:(UIImage *)image;
//判断屏幕  1，iphone6plus；2, iphone6, 3, iphone5, 0，iphone4，4s，touch
+ (NSInteger)boundSizeType;
//字体统一处理
+ (UIFont *)regularFontWithSize:(CGFloat)size;
@end
