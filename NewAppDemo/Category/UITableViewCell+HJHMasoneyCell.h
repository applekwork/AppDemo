//
//  UITableViewCell+HJHMasoneyCell.h
//  XNManager
//
//  Created by Allen on 2017/5/19.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 获取高度前会回调，需要在此BLOCK中配置数据，才能正确地获取高度
 */
typedef void (^configBlock)(UITableViewCell *sourceCell);

typedef NSDictionary *(^HJHCacheHeight)();

/**
 *	唯一键，通常是数据模型的id，保证唯一
 */
FOUNDATION_EXTERN NSString *const kHJHCacheUniqueKey;

/**
 *	对于同一个model，如果有不同状态，而且不同状态下高度不一样，那么也需要指定
 */
FOUNDATION_EXTERN NSString *const kHJHCacheStateKey;

/**
 *	用于指定更新某种状态的缓存，比如当评论时，增加了一条评论，此时该状态的高度若已经缓存过，则需要指定来更新缓存
 */
FOUNDATION_EXTERN NSString *const kHJHRecalculateForStateKey;

/**
 *  基于Masonry自动布局实现的自动计算cell的行高扩展
 */

@interface UITableViewCell (HJHMasoneyCell)

/**
 *  cell里面的最后一个View
 */
@property (nonatomic, strong) UIView *hjh_lastViewInCell;
/**
 *  距离Cell底部的偏移量
 */
@property (nonatomic, assign) CGFloat hjh_bottomOffsetToCell;
/**
 *  计算Cell的高度
 */
+(CGFloat)hjh_tableView:(UITableView *)tableView config:(configBlock)config;

/**
 *	此API会缓存行高
 *
 *	@param tableView 必传，为哪个tableView缓存行高
 *	@param config 必须要实现，且需要调用配置数据的API
 *	@param cache  返回相关key
 *
 *	@return 行高
 */
+ (CGFloat)hjh_heightForTableView:(UITableView *)tableView
                           config:(configBlock)config
                            cache:(HJHCacheHeight)cache;

@end
