//
//  BGViewController.m
//  XNManager
//
//  Created by Carlson Lee on 2017/11/20.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import "BGViewController.h"
//#import "NetViewController.h"
//#import "PhoneNumVC.h"

@interface BGViewController ()

@property (nonatomic, weak) BaseUINavigationController *navVc;

@end

@implementation BGViewController

+ (instancetype)shareInstance
{
    static BGViewController* bgvc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bgvc = [[BGViewController alloc]init];
    });
    return bgvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyUITabBarController* tabVc = [[MyUITabBarController alloc] init];
    [self.view addSubview:tabVc.view];
    [self addChildViewController:tabVc];
    self.tabVc = tabVc;
    
//    if(!_CustomerInfo.isLogin){
//        self.isForce = YES;
//        BaseUINavigationController *navVc = [[BaseUINavigationController alloc]initWithRootViewController:[[PhoneNumVC alloc]init]];
//        [self.view addSubview:navVc.view];
//        [self addChildViewController:navVc];
//        self.navVc = navVc;
//    }
}

- (void)transitonVc:(void(^)())block
{
    CGPoint pt = self.navVc.view.center;
    [UIView animateWithDuration:.25 animations:^{
		self.navVc.view.center = CGPointMake(pt.x, pt.y+mainHeight);
    } completion:^(BOOL finished) {
        if(finished){
            [self.navVc willMoveToParentViewController:nil];
            [self.navVc removeFromParentViewController];
        }
        self.isForce = NO;
        if(block)block();
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
