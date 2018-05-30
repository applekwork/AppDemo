//
//  PublicMethod.m
//  XNSudai
//
//  Created by lxr on 2017/3/28.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import "PublicMethod.h"
#import "UIImageView+WebCache.h"
#import "HttpTool.h"
#import "NSObject+Check.h"


@implementation PublicMethod

+ (NSMutableDictionary *)buildHTTPDataDicWithkeyArray:(NSArray *)keyArray ValueArray:(NSArray *)valueArray 
{
    if (valueArray.count == keyArray.count) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < valueArray.count; i++) {
            [dic setValue:valueArray[i] forKey:keyArray[i]];
        }
        
        return dic;
        
    }else{
        return nil;
    }
}

// 时间戳转时间的方法
+ (NSString *)timeWithTimeIntervalString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat
{
    dateString = [PublicMethod builtDataString:dateString];
//    dateString = @"1492407680937";
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (dateFormat == nil) {
        [formatter setDateFormat:@"yyyy年MM月dd日"];
    }else{
        [formatter setDateFormat:dateFormat];
        
    }
    
    //毫秒转
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000];
//    秒转
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)timeAfterDays:(NSString *)addDay
{
    int addDays = [addDay intValue];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *myDate = [NSDate date];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * addDays];
    return [dateFormatter stringFromDate:newDate];
}

//后四位银行卡号码
+ (NSString *)getLastNumber:(NSString *)bankID withLastNum:(NSInteger)num
{
    NSString *numStr = [PublicMethod builtDataString:bankID];
    numStr = [numStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (numStr.length > num) {
        numStr = [numStr substringFromIndex:numStr.length-num];
    }
    
    return numStr;
}

+ (void)setChangeColors:(UIView *)myView  andStartColor:(UIColor *)inputColor0  andEndColor:(UIColor *)inputColor1
{
        CAGradientLayer *redLayer = [CAGradientLayer layer];
        redLayer.colors = @[(id)inputColor0.CGColor, (id)inputColor1.CGColor];
        redLayer.startPoint = CGPointMake(0, .5);
        redLayer.endPoint = CGPointMake(1.0, .5);
        redLayer.frame = myView.bounds;
//        redLayer.cornerRadius = 2;
//        [myView.layer addSublayer:redLayer];
    [myView.layer insertSublayer:redLayer atIndex:0];
//        redLayer.shadowOffset = CGSizeMake(1, 1.5);
//        redLayer.shadowOpacity = 0.35;
//        redLayer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    
}

#pragma mark --------
+ (id)builtDataString:(id)dataStr
{
    if ([dataStr isKindOfClass:[NSString class]]) {
        if ([dataStr isEqualToString:@"<null>"] || [dataStr isEqualToString:@"(null)"] || [dataStr isEqualToString:@"null"]) {
            return @"";
        }else{
            return  dataStr;
        }
    }else if ([dataStr isKindOfClass:[NSNull class]]){
        return @"";
    }else if (dataStr == nil){
        return @"";
    }else if ([dataStr isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@",dataStr];;
    }
    else{

        return dataStr;
    }
}

+ (void)setImageForImageView:(UIImageView *)imgView withUrlStr:(NSString *)ImgUrl withIsIcon:(BOOL)isIcon withPlaceholderImageName:(NSString *)imgStr
{
    if (isIcon) {
        if ([ImgUrl isKindOfClass:[NSNull class]]) {
            ImgUrl = @"";
        }
        [imgView sd_setImageWithURL:[NSURL URLWithString:ImgUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    }else{
        if (imgStr.length > 0) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:ImgUrl] placeholderImage:[UIImage imageNamed:imgStr]];
        }else{
            [imgView sd_setImageWithURL:[NSURL URLWithString:ImgUrl]];
        }
        
    }
    
}

#pragma mark --------封装控件

+ (UILabel *)setupLabel:(CGRect)frame withText:(NSString *)text withFontSizde:(CGFloat)fontSize withTextColor:(UIColor *)color
{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.numberOfLines = 0;
    lab.textColor = color;
    lab.font = [PublicMethod regularFontWithSize:fontSize];
    lab.text = text;
    return lab;
}
+ (void)setupLinePaceWithLabel:(UILabel *)label withLineSpace:(float)lineSpace
{
    if (label.text.length > 0) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:label.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:lineSpace];
        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeStr.length)];
        label.attributedText = attributeStr;
        //    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    }
    
}

//设置不同字体颜色
+(void)setTextColor:(UILabel *)label andFontNumber:(UIFont *)font andRangeStr:(NSString *)rangeStr andColor:(UIColor *)vaColor
{
    if (label.text.length > 0 && rangeStr.length > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
        NSRange range = [label.text rangeOfString:rangeStr];
        //设置字号
        [str addAttribute:NSFontAttributeName value:font range:range];
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
        label.attributedText = str;
    }
    
}
+(void)setButtonTextColor:(UIButton *)button andFontNumber:(UIFont *)font andRange:(NSRange)range andColor:(UIColor *)color{
    if (button.titleLabel.text.length > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:button.titleLabel.text];
        //设置字号
        [str addAttribute:NSFontAttributeName value:font range:range];
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:color range:range];
        [button setAttributedTitle:str forState:UIControlStateNormal];
    }
}
//动态返回系统默认样式label的高度
+ (CGFloat)getLabelHeight:(CGFloat)labelWith withText:(NSString *)str withFont:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWith, 0)];
    label.numberOfLines = 0;
    label.font = font;
    label.text = str;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    CGRect rect = [label.text boundingRectWithSize:label.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.height;
    
}

+ (UIButton *)setupButton:(CGRect)frame withFontSize:(CGFloat)fontSize withBGColor:(UIColor *)bgColor withTitle:(NSString *)str withTitleColor:(UIColor *)color withImage:(UIImage *)image withLayerRound:(CGFloat)round
{
    UIButton *setupBtn = [[UIButton alloc] initWithFrame:frame];
    if (str != nil) {
        [setupBtn setTitle:str forState:UIControlStateNormal];
    }
    if (color != nil) {
        [setupBtn setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (image != nil) {
        //        [setupBtn setImage:image forState:UIControlStateNormal];
        [setupBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (bgColor != nil) {
        setupBtn.backgroundColor = bgColor;
    }
    
    setupBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    setupBtn.layer.cornerRadius = round;
    setupBtn.layer.masksToBounds = YES;
    return setupBtn;
}
+ (UITextField *)setupTextField:(CGRect)frame withFontSize:(CGFloat)fontSize withPlaceholdText:(NSString *)placeholdText withborderStyle:(UITextBorderStyle)style
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    if (placeholdText != nil) {
        textField.placeholder = placeholdText;
    }
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.borderStyle = style;
    if (placeholdText.length > 0) {
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:placeholdText];
            [placeholder addAttribute:NSForegroundColorAttributeName
                               value:UIColorFromRGB(0xC2BAD0)
                               range:NSMakeRange(0, placeholdText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:16*ScaleFont]
                            range:NSMakeRange(0, placeholdText.length)];
        textField.attributedPlaceholder = placeholder;
    }
    
    return textField;
}
//手机号码验证
+(BOOL)isValidateMobile:(NSString *)mobile
{
    if (mobile.length == 11) {
        NSInteger one = [[mobile substringToIndexCheck:1] integerValue];
        if (one == 1) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
//身份证号验证
+(BOOL)isValidateIdCard:(NSString *)idCardStr
{
    if ((idCardStr.length == 15)|| (idCardStr.length == 18)) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)verifyIDCardNumber:(NSString *)IDCardNumber
{
    IDCardNumber = [IDCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    /*
    if (([IDCardNumber length] < 14)) {
        return NO;
    } else if ([IDCardNumber length] == 15) {
        return NO;
    } else if ([IDCardNumber length] == 16) {
        return NO;
    } else if ([IDCardNumber length] == 17) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:IDCardNumber])
    {
        return NO;
    }
    int summary = ([IDCardNumber substringWithRange:NSMakeRange(0,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([IDCardNumber substringWithRange:NSMakeRange(1,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([IDCardNumber substringWithRange:NSMakeRange(2,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([IDCardNumber substringWithRange:NSMakeRange(3,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([IDCardNumber substringWithRange:NSMakeRange(4,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([IDCardNumber substringWithRange:NSMakeRange(5,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([IDCardNumber substringWithRange:NSMakeRange(6,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [IDCardNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [IDCardNumber substringWithRange:NSMakeRange(8,1)].intValue *6
    + [IDCardNumber substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[IDCardNumber substringWithRange:NSMakeRange(17,1)] uppercaseString]];
     */
    //以下正则没有判断校验位
    NSString* regex = @"(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if([pred evaluateWithObject:IDCardNumber]){
        return YES;
    }
    return NO;
}
+ (BOOL)verifyCardNameIsCN:(NSString *)cardStr {
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:cardStr options:0 range:NSMakeRange(0, cardStr.length) withTemplate:@""];
    if (![noEmojiStr isEqualToString:cardStr]) {
        return NO;
    } else {
        NSString *regex = @"[\u4e00-\u9fa5]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:cardStr]) {
            return YES;
        }
        return NO;
    }
}
+ (BOOL)isAreaCode:(NSString* )tel
{
    NSString *regex = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:tel];
}

+ (NSString *)getShowStr:(NSString *)mobile {
    NSString *errorStr;
    if (mobile.length == 11) {
        NSInteger one = [[mobile substringToIndexCheck:1] integerValue];
        if (one == 1) {
            errorStr = @"";
        }else{
            errorStr = @"手机号格式不正确";
        }
    }else if (mobile.length < 11 && (mobile.length > 0)) {
        NSInteger one = [[mobile substringToIndexCheck:1] integerValue];
        if (one != 1) {
            errorStr = @"手机号格式不正确";
        } else {
            errorStr = @"请输入完整手机号";
        }
    } else if (mobile.length == 0) {
        errorStr = @"手机号不能为空";
    }
    return errorStr;
}
+(BOOL)isValidatePassword:(NSString *)pw
{
    if (pw.length >= 6 && pw.length <= 12) {
        NSString *regex = @"^[A-Za-z0-9]+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL num = [predicate evaluateWithObject:pw];
        return num;
    }else{
        return NO;
    }
}
//验证码验证
+(BOOL)isValidateVerifyCode:(NSString *)code {
    if (code.length == 4) {
        return YES;
    }else{
        return NO;
    }
}
//登录密码验证
+(BOOL)isValidateLogonPassword:(NSString *)code {
    if ((6<= code.length) && (code.length <= 12)) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isEmpty:(NSString *)str{
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (!str) {
        return YES;
    } else {
        if ((id)str == (id)[NSNull null]) {
            return YES;
        }
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

//等比例缩放图片的大小
+ (UIImage *)scaleToSize:(UIImage *)img toScale:(float)scaleSize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width*scaleSize, img.size.height*scaleSize));
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, img.size.width*scaleSize, img.size.height*scaleSize)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

//Imagedata压缩
+ (NSData *)depressImageData:(UIImage *)image
{
    NSData *data;
    image = [PublicMethod scaleToSize:image toScale:0.5];
    data = UIImageJPEGRepresentation(image, 1.0);
    NSUInteger leng = data.length;
    while (leng > 512*1024) {
        image = [PublicMethod scaleToSize:image toScale:0.9];
        data = UIImageJPEGRepresentation(image, 0.5);
        leng = data.length;
    }
    return data;
}

//判断屏幕  1，iphone6plus；2, iphone6, 3, iphone5, 0，iphone4，4s，touch
+ (NSInteger)boundSizeType
{
    if (mainHeight > 667)
    {
        return 1;
    }else if (mainHeight > 568){
        return 2;
    }else if (mainHeight > 480){
        return 3;
    }else{
        return 0;
    }
}

+ (UIFont *)regularFontWithSize:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

@end
