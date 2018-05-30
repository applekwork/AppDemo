//
//  XNTextField.m
//  XNManager
//
//  Created by glj on 2017/6/2.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import "XNTextField.h"

@implementation XNTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)deleteBackward {
    [super deleteBackward];
    if ([self.xn_delegate respondsToSelector:@selector(xnTextFieldDeleteBackward:)]) {
        [self.xn_delegate xnTextFieldDeleteBackward:self];
    }
}
@end
