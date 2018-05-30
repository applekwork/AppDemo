//
//  MyUITabBarController.m
//  MasterDuoBao
//
//  Created by zxl on 16/6/21.
//  Copyright © 2016年 zxl. All rights reserved.
//

#import "MyUITabBarController.h"
#import "AppDelegate.h"
#import "BaseUINavigationController.h"
#import "FirstVC.h"
#import "BaseUINavigationController.h"
@interface MyUITabBarController ()<UITabBarControllerDelegate>
{
    UILabel *line;
    UITabBar * tabbar;
}
@end

@implementation MyUITabBarController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UITabBarItem *tabbarItem = self.tabBarItem;

    tabbarItem.titlePositionAdjustment = UIOffsetMake(0, 10);
//    [tabbar bringSubviewToFront:line];
    
}

- (void)setObj:(id)obj
{
    _obj = obj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tabBar.backgroundColor = [UIColor clearColor];
    [self.tabBar setShadowImage:[UIImage new]];
    [self dropShadowWithOffset:CGSizeMake(0, -2)
                        radius:5
                         color:UIColorFromRGB(0x34bbe2)
                       opacity:0.2];
    
    [self addChildViewControllers];
    
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
{
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}

- (void)addChildViewControllers
{
//    BaseUINavigationController* f_nav = [self getTabVc:@"FirstVC" title:@"首页" normalImg:@"home_btn_normal_0" selectImg:@"home_btn_select_0" withTag:0];
    BaseUINavigationController* f_nav_1 = [self getTabVc:@"FirstVC" title:@"首页" normalImg:@"home_btn_normal_0" selectImg:@"home_btn_select_0" withTag:0];
    
    BaseUINavigationController* s_nav = [self getTabVc:@"FirstVC" title:@"社区" normalImg:@"home_btn_normal_2" selectImg:@"home_btn_select_2" withTag:1];
    
    BaseUINavigationController* t_nav = [self getTabVc:@"FirstVC" title:@"征信" normalImg:@"home_btn_normal_4" selectImg:@"home_btn_select_4" withTag:3];
    
    BaseUINavigationController* ft_nav = [self getTabVc:@"FirstVC" title:@"我的" normalImg:@"home_btn_normal_3" selectImg:@"home_btn_select_3" withTag:4];
    

    NSArray* tabs = @[f_nav_1, s_nav, t_nav, ft_nav];
	
    self.viewControllers = tabs;
}

- (id )getTabVc:(NSString* )vc title:(NSString* )title normalImg:(NSString* )normal_img selectImg:(NSString* )select_img withTag:(NSInteger)tag
{
    Class cla = NSClassFromString(vc);
    BaseUINavigationController* navc = [[BaseUINavigationController alloc]initWithRootViewController:[cla new]];
    navc.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[XN_IMG(normal_img) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[XN_IMG(select_img) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2*ScaleX)];
    navc.tabBarItem.tag = tag;
    return navc;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    if (item.tag == 3) {
//        if (!_CustomerInfo.isLogin) {
//            [[SchemeHandler defaultHandler] handleUrl:@"xulugj://www.xulu.com/native?name=login" animated:YES];
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
}


@end
