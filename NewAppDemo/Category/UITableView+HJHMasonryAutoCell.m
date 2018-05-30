//
//  UITableView+HJHMasonryAutoCell.m
//  XNManager
//
//  Created by Allen on 2017/5/19.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import "UITableView+HJHMasonryAutoCell.h"
#import <objc/runtime.h>

const void *__hjh_tableView_reuseCell = @"__hjh_tableView_reuseCellKey";
static const void *__hjh_tableview_cacheCellHeightKey = "__hjh_tableview_cacheCellHeightKey";

@implementation UITableView (HJHMasonryAutoCell)

- (NSMutableDictionary *)hjh_reuseCells{
    
    NSMutableDictionary *cells = objc_getAssociatedObject(self, __hjh_tableView_reuseCell);
    if (cells == nil) {
        cells = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self,
                                 __hjh_tableView_reuseCell,
                                 cells,
                                 OBJC_ASSOCIATION_RETAIN);
    }
    return cells;
}

- (NSMutableDictionary *)hjh_cacheCellHeightDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, __hjh_tableview_cacheCellHeightKey);
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        
        objc_setAssociatedObject(self,
                                 __hjh_tableview_cacheCellHeightKey,
                                 dict,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dict;
}

@end
