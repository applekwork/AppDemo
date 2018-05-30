//
//  RemindDialogView.m
//  PgyVisitor
//
//  Created by glj on 16/8/16.
//  Copyright © 2016年 xulu. All rights reserved.
//

#import "RemindDialogView.h"
#import "NSObject+Check.h"
@interface RemindDialogView ()
@property (nonatomic,assign)BOOL isRemindDialogShowFlag;        //警告窗是否正在显示标志
@property (nonatomic, strong) UILabel *label;
@end

@implementation RemindDialogView
- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc]init];
    }
    return _label;
}
- (instancetype)initWithSuperView:(UIView *)superView
{
    if(self = [self initWithFrame:CGRectZero]){
        if(superView != nil){
            [superView addSubview:self];
        }
    }
    return self;
}

//代码创建
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self uiSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self uiSetting];
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - 初始化方法
//页面初始化设置
- (void)uiSetting {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    self.layer.cornerRadius = 6.0;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = NO;
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.bounds = CGRectMake(0, 0, 260, 50);
    self.numberOfLines = 2;
    [self hideRemindDialog];
}

#pragma mark - 外部方法
//显示内容(延迟消失)
- (void)displayWithContentString:(NSString *)contentString {
    if((self.superview == nil)
       ||(contentString == nil)
       ||[contentString isEqualToString:NO_NET]
       ||([contentString isEqualToStringCheck:@""])){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //取消延时隐藏
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideRemindDialog) object:nil];
        self.hidden = NO;
        self.text = contentString;
        NSDictionary *attrs = @{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
        CGSize size=[self.text sizeWithAttributes:attrs];
        [self setFrame:CGRectMake(0, 0, size.width, 50)];
        self.center = CGPointMake(self.superview.bounds.size.width/2.0,
                                  self.superview.bounds.size.height/2.0 - 50*ScaleX);
        [self.superview bringSubviewToFront:self];
        //延时隐藏(2s后消失)
        [self performSelector:@selector(hideRemindDialog) withObject:nil afterDelay:1.0];
    });
}
- (void)displayWithContentStr:(NSString *)contentString {
    if((self.superview == nil)
       ||(contentString == nil)
       ||[contentString isEqualToString:NO_NET]
       ||([contentString isEqualToStringCheck:@""])){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //取消延时隐藏
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideRemindDialog) object:nil];
        self.hidden = NO;
        self.text = contentString;
        NSDictionary *attrs = @{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
        CGSize size=[self.text sizeWithAttributes:attrs];
        [self setFrame:CGRectMake(0, 0, size.width, 50)];
        self.center = CGPointMake(self.superview.bounds.size.width/2.0,
                                  self.superview.bounds.size.height/2.0 - 50*ScaleX - 146 *ScaleX);
        [self.superview bringSubviewToFront:self];
        //延时隐藏(2s后消失)
        [self performSelector:@selector(hideRemindDialog) withObject:nil afterDelay:1.0];
    });
}
//隐藏提示消息视图
-(void)hideRemindDialog
{
    self.text = @"";
    self.hidden = YES;
    if((self.hidden == YES)
       &&(self.superview != nil)){
        [self.superview sendSubviewToBack:self];
    }
}

#pragma mark - 重写UILabel的方法
//重写父类方法，修改文字显示范围
//- (void)drawTextInRect:(CGRect)rect
//{
//    //两边留出空白部分
//    [self drawTextInRect:CGRectMake(5, 0, rect.size.width - 10, rect.size.height)];
//}

@end

