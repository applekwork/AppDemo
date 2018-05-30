//
//  UIView+DropShadow.h
//  FlashLoan
//
//  Created by taoyongjiu on 2017/6/9.
//  Copyright © 2017年 上海翡鹿信息技术服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DropShadow)

/**
 默认视图的下方添加阴影

 @param offset 偏移量
 @param radius 圆角
 @param color 颜色
 @param opacity 透明度
 */
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;


/**
 视图添加阴影

 @param frame frame
 @param offset 偏移量
 @param radius 圆角
 @param color 颜色
 @param opacity 透明度
 */
- (void)dropShadowWithFrame:(CGRect)frame offset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;



@end
