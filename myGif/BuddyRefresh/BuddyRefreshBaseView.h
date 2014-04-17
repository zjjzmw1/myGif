//
//  BuddyRefreshBaseView.h
//  shijiebang
//
//  Created by Buddy on 3/4/14.
//  Copyright (c) 2014 ShiJieBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuddyRefreshMacro.h"
///控件刷新的状态
typedef enum{
    BuddyRefreshStateNormal = 0,        ///正常状态
    BuddyRefreshStatePulling = 1,       ///松开就可以刷新的状态
    BuddyRefreshStateRefreshing = 2   ///正在刷新的状态
} BuddyRefreshState;
///控件类型
typedef enum{
    BuddyRefreshTypeHeader = -1,         ///头部控件
    BuddyRefreshTypeFooter = 1          ///尾部控件
} BuddyRefreshType;

@class BuddyRefreshBaseView;
///刷新的代理方法
@protocol BuddyRefreshBaseViewDelegate <NSObject>
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(BuddyRefreshBaseView *)refreshView;
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(BuddyRefreshBaseView *)refreshView;
// 刷新状态变更就会调用
- (void)refreshView:(BuddyRefreshBaseView *)refreshView stateChange:(BuddyRefreshState)state;
@end

/**
 回调的Block定义
 */
// 开始进入刷新状态就会调用
typedef void (^BeginRefreshingBlock)(BuddyRefreshBaseView *refreshView);
// 刷新完毕就会调用
typedef void (^EndRefreshingBlock)(BuddyRefreshBaseView *refreshView);
// 刷新状态变更就会调用
typedef void (^RefreshStateChangeBlock)(BuddyRefreshBaseView *refreshView, BuddyRefreshState state);


@interface BuddyRefreshBaseView : UIView
{
    BOOL _hasInitInset;
    UIEdgeInsets _scrollViewInitInset;
    UIScrollView *_scrollView;
    ///子控件
    UILabel *_lastUpdateTimeLabel;
    UILabel *_statusLabel;
    UIImageView *_arrowImage;
    UIActivityIndicatorView *_activityView;
    ///状态
    BuddyRefreshState _state;
    ///是否正在刷新
    BOOL refreshing;
    int _lastRefreshCount;
}
// 设置要显示的父控件
@property (nonatomic, strong) UIScrollView *scrollView;
// 最后的更新时间
@property (nonatomic, strong) NSDate *lastUpdateTime;
// 刷新类型
@property (nonatomic, assign)BuddyRefreshType viewType;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

///代理
@property (nonatomic, weak)id<BuddyRefreshBaseViewDelegate>delegate;
// Block回调
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, copy) RefreshStateChangeBlock refreshStateChangeBlock;
@property (nonatomic, copy) EndRefreshingBlock endStateChangeBlock;

// 合理的Y值
- (CGFloat)validY;
// 开始刷新
- (void)beginRefreshing;
// 结束刷新
- (void)endRefreshing;
@end
