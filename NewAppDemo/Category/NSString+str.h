//
//  NSString+str.h
//  XNManager
//
//  Created by glj on 2017/5/2.
//  Copyright © 2017年 xulu. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (str)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)timeWithTimeSimplyString:(NSString *)timeString;

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

+ (NSString *)timeWithTimeStr:(NSString* )str formate:(NSString* )formate;

+ (NSString *)stringFromEmoji:(NSString* )emoji;
+ (NSString* )emojiFromStr:(NSString* )str;

+(NSString *)getZZwithString:(NSString *)string;
+ (NSString* )handleTagPWithString:(NSString *)string;

//汉字转拼音
+ (NSString *)transformPinYinWithString:(NSString *)chinese;

@end
