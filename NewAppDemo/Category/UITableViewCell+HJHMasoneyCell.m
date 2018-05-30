//
//  UITableViewCell+HJHMasoneyCell.m
//  XNManager
//
//  Created by Allen on 2017/5/19.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import "UITableViewCell+HJHMasoneyCell.h"
#import <objc/runtime.h>
#import "UITableView+HJHMasonryAutoCell.h"
const void *s_hjh_bottomOffsetToCellKey = @"_hjh_bottomOffsetToCellKey";
const void *s_hjh_lastViewInCellKey = @"_hjh_lastViewCellKey";

NSString *const kHJHCacheUniqueKey = @"kHJHCacheUniqueKey";
NSString *const kHJHCacheStateKey = @"kHJHCacheStateKey";
NSString *const kHJHRecalculateForStateKey = @"kHJHRecalculateForStateKey";
NSString *const kHJHCacheForTableViewKey = @"kHJHCacheForTableViewKey";

@implementation UITableViewCell (HJHMasoneyCell)

+ (CGFloat)hjh_tableView:(UITableView *)tableView config:(configBlock)config{
    
    UITableViewCell *cell = [tableView.hjh_reuseCells objectForKey:[[self class] description]];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [tableView.hjh_reuseCells setObject:cell forKey:[[self class] description]];
    }
    if (config) {
        config(cell);
    }
    return [cell private_hjh_heightForTableView:tableView];
}

+ (CGFloat)hjh_heightForTableView:(UITableView *)tableView
                           config:(configBlock)config
                            cache:(HJHCacheHeight)cache{
    if (cache) {
        NSDictionary *cacheKeys = cache();
        NSString *key = cacheKeys[kHJHCacheUniqueKey];
        NSString *stateKey = cacheKeys[kHJHCacheStateKey];
        NSString *shouldUpdate = cacheKeys[kHJHRecalculateForStateKey];
        
        NSMutableDictionary *stateDict = tableView.hjh_cacheCellHeightDict[key];
        NSString *cacheHeight = stateDict[stateKey];
        
        if (tableView == nil
            || tableView.hjh_cacheCellHeightDict.count == 0
            || shouldUpdate.boolValue
            || cacheHeight == nil) {
            CGFloat height = [self hjh_tableView:tableView config:config];
            
            if (stateDict == nil) {
                stateDict = [[NSMutableDictionary alloc] init];
                tableView.hjh_cacheCellHeightDict[key] = stateDict;
            }
            
            [stateDict setObject:[NSString stringWithFormat:@"%lf", height] forKey:stateKey];
            
            return height;
        } else if (tableView.hjh_cacheCellHeightDict.count != 0
                   && cacheHeight != nil
                   && cacheHeight.integerValue != 0) {
            return cacheHeight.floatValue;
        }
    }
    
    return [self hjh_tableView:tableView config:config];
}

- (CGFloat)private_hjh_heightForTableView:(UITableView *)tableView{
    NSAssert(self.hjh_lastViewInCell != nil, @"您未指定cell排列中最后一个视图对象，无法计算cell的高度");

    [self layoutIfNeeded];
    CGFloat height = self.hjh_lastViewInCell.frame.size.height + self.hjh_lastViewInCell.frame.origin.y;
    height += self.hjh_bottomOffsetToCell;
    return height;
}


#pragma setting AND getting

- (void)setHjh_bottomOffsetToCell:(CGFloat)hjh_bottomOffsetToCell{
    objc_setAssociatedObject(self,
                             s_hjh_bottomOffsetToCellKey,
                             @(hjh_bottomOffsetToCell),
                             OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)hjh_bottomOffsetToCell{
    NSNumber *objValue = objc_getAssociatedObject(self, s_hjh_bottomOffsetToCellKey);
    
    if ([objValue respondsToSelector:@selector(floatValue)]) {
        return objValue.floatValue;
    }
    return 0.0;
}

- (void)setHjh_lastViewInCell:(UIView *)hjh_lastViewInCell{
    objc_setAssociatedObject(self,
                             s_hjh_lastViewInCellKey,
                             hjh_lastViewInCell,
                             OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)hjh_lastViewInCell{
    return objc_getAssociatedObject(self, s_hjh_lastViewInCellKey);
}

@end
