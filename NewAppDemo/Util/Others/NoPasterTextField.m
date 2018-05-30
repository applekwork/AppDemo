//
//  NoPasterTextField.m
//  XNManager
//
//  Created by Carlson Lee on 2017/8/2.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import "NoPasterTextField.h"

@implementation NoPasterTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController* menu = [UIMenuController sharedMenuController];
    if(menu){
        [UIMenuController sharedMenuController].menuVisible = NO;
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
