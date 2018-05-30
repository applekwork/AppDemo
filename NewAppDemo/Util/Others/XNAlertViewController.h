//
//  XNAlertViewController.h
//  XNManager
//
//  Created by Allen on 2017/6/28.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import "BaseUIViewController.h"

@interface XNAlertAction : NSObject

@property (nonatomic, readonly) NSString *title;

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(XNAlertAction *action))handler;

@end


@interface XNAlertViewController : UIViewController

@property (nonatomic, readonly) NSArray<XNAlertAction *> *actions;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
- (void)addAction:(XNAlertAction *)action;

@end
