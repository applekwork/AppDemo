//
//  UITableView+HJHMasonryAutoCell.h
//  XNManager
//
//  Created by Allen on 2017/5/19.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HJHMasonryAutoCell)

/**
 *  用于获取Cell的行高
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *hjh_reuseCells;

/**
 *	用于缓存cell的行高
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *hjh_cacheCellHeightDict;

@end
