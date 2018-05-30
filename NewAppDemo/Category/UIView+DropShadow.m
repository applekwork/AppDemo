//
//  UIView+DropShadow.m
//  FlashLoan
//
//  Created by taoyongjiu on 2017/6/9.
//  Copyright © 2017年 上海翡鹿信息技术服务有限公司. All rights reserved.
//

#import "UIView+DropShadow.h"

@implementation UIView (DropShadow)
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    [self dropShadowWithFrame:self.bounds
                       offset:offset
                       radius:radius
                        color:color
                      opacity:opacity];
}

- (void)dropShadowWithFrame:(CGRect)frame
                     offset:(CGSize)offset
                     radius:(CGFloat)radius
                      color:(UIColor *)color
                    opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.clipsToBounds = NO;

}

@end
