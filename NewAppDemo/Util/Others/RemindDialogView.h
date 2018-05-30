//
//  RemindDialogView.h
//  PgyVisitor
//
//  Created by Oray on 16/8/16.
//  Copyright © 2016年 glj. All rights reserved.
//

#import <UIKit/UIKit.h>


/*---------------通用 提示对话框视图---------------*/
@interface RemindDialogView : UILabel

//实例化
- (instancetype)initWithSuperView:(UIView *)superView;
//显示内容(延迟消失)
- (void)displayWithContentString:(NSString *)contentString;
- (void)displayWithContentStr:(NSString *)contentString;
@end
