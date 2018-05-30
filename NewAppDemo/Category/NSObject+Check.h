//
//  NSObject+objectAtIndex.h
//
//  Created by glj on 2017/5/2.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (objectAtIndexChect)
// 防止数组 objectAtIndex越界引信崩溃的保护方法
- (id)objectAtIndexCheck:(NSUInteger)index;
//防止调用者不是string
- (BOOL)isEqualToStringCheck:(NSString *)string;
// 防止截取字符串越界
- (id)substringToIndexCheck:(NSUInteger)index;
//处理时间字符串
- (NSString *)dealWithTimeStringWithString:(NSString *)timeString;
@end
