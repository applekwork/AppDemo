//
//  BGViewController.h
//  XNManager
//
//  Created by Carlson Lee on 2017/11/20.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUITabBarController.h"

@interface BGViewController : UIViewController

@property (nonatomic, assign) BOOL isForce;

@property (nonatomic, weak) MyUITabBarController* tabVc;

+ (instancetype)shareInstance;

- (void)transitonVc:(void(^)())block;

@end
