//
//  XNTextField.h
//  XNManager
//
//  Created by glj on 2017/6/2.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNTextField;

@protocol XNTextFieldDelegate <NSObject>
@optional
- (void)xnTextFieldDeleteBackward:(XNTextField *)textField;
@end

@interface XNTextField : UITextField
@property (nonatomic, assign) id <XNTextFieldDelegate> xn_delegate;
@end
