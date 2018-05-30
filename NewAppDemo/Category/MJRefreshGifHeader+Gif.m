//
//  MJRefreshGifHeader+Gif.m
//  XNManager
//
//  Created by Carlson Lee on 2017/11/9.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import "MJRefreshGifHeader+Gif.h"

@implementation MJRefreshGifHeader (Gif)

- (void)defaultImageAnimation
{
    [MyTool arrayImageWithName:@"sd_loading_1" block:^(NSArray *images) {
       [self setImages:images forState:MJRefreshStateIdle];
    }];
    [MyTool arrayImageWithName:@"sd_loading_2" block:^(NSArray *images) {
        [self setImages:images forState:MJRefreshStatePulling];
    }];
    [MyTool arrayImageWithName:@"sd_loading_3" block:^(NSArray *images) {
       	[self setImages:images forState:MJRefreshStateRefreshing];
    }];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

@end
