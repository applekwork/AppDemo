//
//  BaseUIViewController.h
//  KankeTV
//
//  Created by zhaoxl on 13-3-29.
//  Copyright (c) 2013年 zhaoxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindDialogView.h"
#import "SDCommonHeader.h"b

@interface BaseUIViewController : UIViewController

@property (nonatomic,readonly,strong)RemindDialogView *commonRemindDialogView;

@property (nonatomic, strong) XNDefectView* defectView;

@property (nonatomic, strong) UIButton *navLeftBtn;
@property (nonatomic, strong) UIButton *navRightBtn;

@property (nonatomic, strong) UIImageView*loadingImg;
@property (nonatomic, strong) UILabel *tipsLab;
@property (nonatomic, assign) BOOL show_flag;
- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock;
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock;


 //显示加载转圈
-(void)showLoad;
//取消显示加载转圈
-(void)cancelLoad;

-(void)showLoadWithTip:(NSString *)str;
-(void)cancelLoadWithTip;

-(void)back;

@end
