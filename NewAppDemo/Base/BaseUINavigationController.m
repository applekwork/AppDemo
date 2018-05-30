//
//  BaseUINavigationController.m
//  KankeTV
//
//  Created by zhaoxl on 13-3-29.
//  Copyright (c) 2013年 zhaoxl. All rights reserved.
//

#import "BaseUINavigationController.h"
#import "AppDelegate.h"
#import "UIImage+RenderedImage.h"

@interface BaseUINavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIPanGestureRecognizer* pan;

@end

@implementation BaseUINavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
//        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (UIPanGestureRecognizer *)pan
{
    if(!_pan){
        id target = self.interactivePopGestureRecognizer.delegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        _pan.maximumNumberOfTouches = 1;
        _pan.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return _pan;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageGradientRenderWithColors:@[(__bridge id)UIColorFromRGB(0x3863fe).CGColor, (__bridge id)UIColorFromRGB(0x00e7fa).CGColor] renderSize:CGSizeMake(mainWidth, 10.)] forBarMetrics:UIBarMetricsDefault];

    [self.navigationBar setTitleTextAttributes:@{
                                                 NSFontAttributeName:XNFont(16, FONT_TYPE_MEDIUM),
                                                 NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    [self dropShadowWithOffset:CGSizeMake(0, 1.5)
                        radius:3
                         color:UIColorFromRGB(0x00e7fa)
                       opacity:0.1];
    
    [self.view addGestureRecognizer:self.pan];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    // 侧滑手势触发位置
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet = [_pan translationInView:_pan.view];
    BOOL ret = (0 < offSet.x && location.x <= 40);
    return ret;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.navigationBar.bounds);
    self.navigationBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.navigationBar.layer.shadowColor = color.CGColor;
    self.navigationBar.layer.shadowOffset = offset;
    self.navigationBar.layer.shadowRadius = radius;
    self.navigationBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.navigationBar.clipsToBounds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleDefault;
//}

#pragma mark - 方法重写
//重写推出视图控制器方法-lxr
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ((self.viewControllers != nil) && ([self.viewControllers count] >= 1)) {
        //本次推出的不是rootViewController
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"user_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(dismissCurrentVC)];
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}
- (void)dismissCurrentVC {
    [self popViewControllerAnimated:YES];
}
@end
