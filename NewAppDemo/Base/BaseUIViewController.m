//
//  BaseUIViewController.m
//  KankeTV
//
//  Created by zhaoxl on 13-3-29.
//  Copyright (c) 2013年 zhaoxl. All rights reserved.
//

#import "BaseUIViewController.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

static char *btnClickAction;
@interface BaseUIViewController ()
@property (nonatomic,strong)RemindDialogView *commonRemindDialogView;           //通用错误提示窗(重写为读写属性)
@end

@implementation BaseUIViewController

- (XNDefectView *)defectView
{
    if(!_defectView){
        _defectView = [[XNDefectView alloc]init];
        [_defectView setHidden:YES];
    }
    return _defectView;
}
- (RemindDialogView *)commonRemindDialogView
{
    if(_commonRemindDialogView == nil){
        _commonRemindDialogView = [[RemindDialogView alloc] initWithSuperView:self.view];
    }
    return _commonRemindDialogView;
}
- (UILabel *)tipsLab {
    if (_tipsLab == nil ) {
        _tipsLab = [[UILabel alloc]init];
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        [_tipsLab setFont:[UIFont systemFontOfSize:14]]
        ;
        _tipsLab.textColor = [UIColor blackColor];
    }
    return _tipsLab;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (instancetype)init {
    if ([super init]) {
        //
    }
    return self;
}
- (void)dealloc{
    DLog(@"dealloc %@",self.class);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
/**
 *
 *  本方法用于 响应返回按钮
 *
 */
-(void)back{
	[self.navigationController popViewControllerAnimated:YES];
	
}

/**
 *
 *  本方法用于 响应加载失败
 *
 */
-(void)error{
	[self cancelLoad];
	
}
/**
 *
 *  显示加载转圈
 *
 */
-(void)showLoad{
	self.view.userInteractionEnabled = NO;
    self.loadingImg.hidden = NO;
    [self.view bringSubviewToFront:_loadingImg];
}
/**
 *
 *  取消显示加载转圈
 *
 */
-(void)cancelLoad{
    if ([_loadingImg isAnimating]) {
        [_loadingImg stopAnimating];
        _loadingImg.hidden = YES;
    }
    self.view.userInteractionEnabled = YES;
}

- (UIImageView *)loadingImg
{
    if(!_loadingImg){
        _loadingImg = [[UIImageView alloc]init];
        [self.view addSubview:_loadingImg];
        _loadingImg.frame = CGRectMake(0, 0, 200, 120);
        _loadingImg.center = CGPointMake(mainWidth/2, mainHeight/2);
        
        [MyTool arrayImageWithName:@"loading" block:^(NSArray *images) {
            _loadingImg.animationImages = images;
            _loadingImg.animationDuration = 1.0;
            _loadingImg.animationRepeatCount = MAXFLOAT;
            [_loadingImg startAnimating];
        }];
    }
    return _loadingImg;
}
#pragma mark 下方有title
/**
 *
 *  显示加载转圈
 *
 */
-(void)showLoadWithTip:(NSString *)str{
    self.view.userInteractionEnabled = NO;
    self.loadingImg.frame = CGRectMake(0, 0, 200, 100);
    self.loadingImg.center = CGPointMake(self.view.width*0.5, self.view.height*0.5-5);
    [self.loadingImg startAnimating];
    self.loadingImg.hidden = NO;
    [self.view bringSubviewToFront:_loadingImg];
    [self.view addSubview:self.tipsLab];
    _tipsLab.text = str;
    _tipsLab.frame = CGRectMake(0, 0, mainWidth, 20);
    _tipsLab.center = CGPointMake(self.view.width*0.5, self.view.height*0.5-5 + 70 );
    _tipsLab.hidden = NO;
    [self.view bringSubviewToFront:self.tipsLab];
}
/**
 *
 *  取消显示加载转圈
 *
 */
-(void)cancelLoadWithTip{
    if (_loadingImg) {
        [_loadingImg stopAnimating];
        _loadingImg.hidden = YES;
        _tipsLab.hidden = YES;
        _tipsLab.textColor = [UIColor clearColor];
    }
    self.view.userInteractionEnabled = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -actionCustomLeftBtnWithNrlImage
- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock {
    self.navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftBtn setBackgroundColor:[UIColor clearColor]];
    objc_setAssociatedObject(self.navLeftBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navLeftBtn nrlImage:nrlImage htlImage:hltImage title:title];
    [self.navLeftBtn setTitleColor:FONT_THEME_COLOR forState:UIControlStateNormal];
    if (nrlImage) {
        [self.navLeftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftBtn];
    if ([nrlImage isEqualToString:@"titlebar_icon_goback_white_rest"]) {
        self.navLeftBtn.alpha = 0.6;
    }
}

#pragma mark -actionCustomRightBtnWithNrlImage
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock {
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(self.navRightBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navRightBtn nrlImage:nrlImage htlImage:hltImage title:title];
    [self.navRightBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    self.navRightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    // 圈子右上角的“清空”按钮
    self.navRightBtn.titleLabel.font = XNFont(14, FONT_TYPE_MEDIUM);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
}
#pragma mark -actionCustomNavBtn
- (void)actionCustomNavBtn:(UIButton *)btn nrlImage:(NSString *)nrlImage
                  htlImage:(NSString *)hltImage
                     title:(NSString *)title {
    
    [btn setImage:[[UIImage imageNamed:nrlImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (hltImage) {
        [btn setImage:[[UIImage imageNamed:hltImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[[UIImage imageNamed:nrlImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    if (title) {
        btn.titleLabel.font = XNFont(14, FONT_TYPE_MEDIUM);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -actionBtnClick
- (void)actionBtnClick:(UIButton *)btn {
    void (^btnClickBlock) (void) = objc_getAssociatedObject(btn, &btnClickAction);
    btnClickBlock();
}

@end
