//
//  BuddyRefreshBaseView.m
//  shijiebang
//
//  Created by Buddy on 3/4/14.
//  Copyright (c) 2014 ShiJieBang. All rights reserved.
//

#import "BuddyRefreshBaseView.h"

@implementation BuddyRefreshBaseView

#pragma mark 创建一个UILabel
-(UILabel *)labelWithFontSize:(CGFloat)size{
    UILabel *label = [[UILabel alloc]init];
    label.autoresizingMask =UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:size];
    label.textColor = kBuddyRefreshLabelTextColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark 布局发生变化的时候添加监听。
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_hasInitInset) {
        _scrollViewInitInset = _scrollView.contentInset;
        [self observeValueForKeyPath:kBuddyRefreshContentSize ofObject:nil change:nil context:nil];
        _hasInitInset = YES;
    }
}

#pragma mark 构造方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        ///时间标签
        _lastUpdateTimeLabel = [self labelWithFontSize:12];
        [self addSubview:_lastUpdateTimeLabel];
        ///状态标签
        _statusLabel = [self labelWithFontSize:13];
        [self addSubview:_statusLabel];
        ///箭头图片
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        _arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage];
        ///指示器
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.bounds = _arrowImage.bounds;
        _activityView.autoresizingMask = _arrowImage.autoresizingMask;
        [self addSubview:_activityView];
        ///设置状态
        [self setState:BuddyRefreshStateNormal];
        if (self.viewType == BuddyRefreshTypeFooter) {
            // 移除刷新时间
            [_lastUpdateTimeLabel removeFromSuperview];
            _lastUpdateTimeLabel = nil;
        }
    }
    return self;
}

#pragma mark 设置frame
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    if (w == 0 || _arrowImage.center.y == h*0.5f) {
        return;
    }
    CGFloat statusX = 0;
    CGFloat statusY = 5;
    CGFloat statusHeight = 20;
    CGFloat statusWidth = w;
    ///状态标签。
    _statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    ///时间标签
    CGFloat lastUpdateY = statusY + statusHeight +5;
    _lastUpdateTimeLabel.frame = CGRectMake(statusX, lastUpdateY, statusWidth, statusHeight);
    ///箭头
    CGFloat arrowX = w*0.5f - 100;
    _arrowImage.center = CGPointMake(arrowX, h*0.5f);
    ///指示器
    _activityView.center = _arrowImage.center;
    
    if (self.viewType == BuddyRefreshTypeFooter) {
        CGFloat h = frame.size.height;
        if (_statusLabel.center.y != h * 0.5) {
            CGFloat w = frame.size.width;
            _statusLabel.center = CGPointMake(w * 0.5f, h * 0.5f);
        }
    }
}
#pragma mark 设置最后的更新时间
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    // 1.归档
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateTime forKey:kBuddyRefreshHeaderTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 2.更新时间
    [self updateTimeLabel];
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel
{
    if (!_lastUpdateTime) return;
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:_lastUpdateTime];
    // 3.显示日期
    _lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}

#pragma mark 设置UIScrollView
-(void)setScrollView:(UIScrollView *)scrollView{
    // 4.重新调整frame
    [self adjustFrame];
    if (self.viewType == BuddyRefreshTypeFooter) {
        // 1.移除以前的监听器
        [_scrollView removeObserver:self forKeyPath:kBuddyRefreshContentSize context:nil];
        // 2.监听contentSize
        [scrollView addObserver:self forKeyPath:kBuddyRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        ///移除之前的监听
        [_scrollView removeObserver:self forKeyPath:kBuddyRefreshContentOffSet context:nil];
        ///监听contentOffset
        [scrollView addObserver:self forKeyPath:kBuddyRefreshContentOffSet options:NSKeyValueObservingOptionNew context:nil];
        ///设置scrollView
        _scrollView = scrollView;
        [_scrollView addSubview:self];
    }else{
        ///移除之前的监听
        [_scrollView removeObserver:self forKeyPath:kBuddyRefreshContentOffSet context:nil];
        ///监听contentOffset
        [scrollView addObserver:self forKeyPath:kBuddyRefreshContentOffSet options:NSKeyValueObservingOptionNew context:nil];
        ///设置scrollView
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        // 1.设置边框
        self.frame = CGRectMake(0, - kBuddyRefreshViewHeight, scrollView.frame.size.width, kBuddyRefreshViewHeight);
        // 2.加载时间
        self.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kBuddyRefreshHeaderTimeKey];
        
        
    }
}

#pragma mark 监听UIScrollView的contentOffset属性
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![kBuddyRefreshContentOffSet isEqualToString:keyPath]) {
        return;
    }if (!self.userInteractionEnabled ||self.alpha<=0.01 || self.hidden ||_state == BuddyRefreshStateRefreshing) {
        return;
    }
    // scrollView所滚动的Y值 * 控件的类型（头部控件是-1，尾部控件是1）
    if (_scrollView.contentOffset.y<0) {
        self.viewType = BuddyRefreshTypeHeader;
    }else{
        self.viewType = BuddyRefreshTypeFooter;
    }
    [self adjustFrame];
    
    CGFloat offsetY = _scrollView.contentOffset.y * self.viewType;
    CGFloat validY = self.validY;
    if (offsetY <= validY) return;
    
    if (_scrollView.isDragging) {
        CGFloat validOffsetY = validY + kBuddyRefreshViewHeight;
        if (_state == BuddyRefreshStatePulling && offsetY <= validOffsetY) {
            // 转为普通状态
            [self setState:BuddyRefreshStateNormal];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:BuddyRefreshStateNormal];
            }
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, BuddyRefreshStateNormal);
            }
        } else if (_state == BuddyRefreshStateNormal && offsetY > validOffsetY) {
            // 转为即将刷新状态
            [self setState:BuddyRefreshStatePulling];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:BuddyRefreshStatePulling];
            }
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, BuddyRefreshStatePulling);
            }
        }
    } else { // 即将刷新 && 手松开
        if (_state == BuddyRefreshStatePulling) {
            // 开始刷新
            [self setState:BuddyRefreshStateRefreshing];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:BuddyRefreshStateRefreshing];
            }
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, BuddyRefreshStateRefreshing);
            }
        }
    }
}

#pragma mark 设置状态
- (void)setState:(BuddyRefreshState)state
{
    // 1.一样的就直接返回
    if (_state == state) return;
    // 2.保存旧状态
    BuddyRefreshState oldState = _state;
    if (_state != BuddyRefreshStateRefreshing) {
        // 存储当前的contentInset
        _scrollViewInitInset = _scrollView.contentInset;
    }
    // scrollView所滚动的Y值 * 控件的类型（头部控件是-1，尾部控件是1）
    if (_scrollView.contentOffset.y<0) {
        self.viewType = BuddyRefreshTypeHeader;
    }else{
        self.viewType = BuddyRefreshTypeFooter;
    }
    [self adjustFrame];
    
    _state = state;///这句是关键，每次进入都先赋值然后才能判断。。。。
    
    // 2.根据状态执行不同的操作
    switch (state) {
		case BuddyRefreshStateNormal: // 普通状态
        {
            // 显示箭头
            _arrowImage.hidden = NO;
            // 停止转圈圈
			[_activityView stopAnimating];
            // 设置文字
            if (self.viewType == BuddyRefreshTypeFooter) {
                _statusLabel.text = kBuddyRefreshFooterPullToRefresh;
                // 刚刷新完毕
                CGFloat animDuration = kBuddyRefreshAnimationDuration;
                CGFloat deltaH = [self contentBreakView];
                CGPoint tempOffset = _scrollView.contentOffset;
                int currentCount = [self totalDataCountInScrollView];
                if (BuddyRefreshStateRefreshing == oldState && deltaH > 0 && currentCount != _lastRefreshCount) {
                    animDuration = 0;
                }
                [UIView animateWithDuration:animDuration animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation((float)M_PI);
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.bottom = _scrollViewInitInset.bottom;
                    _scrollView.contentInset = inset;
                }];
                if (animDuration == 0) {
                    _scrollView.contentOffset = tempOffset;
                }
                
            }else{
                _statusLabel.text = kBuddyRefreshHeaderPullToRefresh;
                // 执行动画
                [UIView animateWithDuration:kBuddyRefreshAnimationDuration animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.top = _scrollViewInitInset.top;
                    _scrollView.contentInset = inset;
                }];
            }
            // 刷新完毕
            if (BuddyRefreshStateRefreshing == oldState) {
                // 保存刷新时间
                self.lastUpdateTime = [NSDate date];
            }
            // 说明是刚刷新完毕 回到 普通状态的
            if (BuddyRefreshStateNormal == _state) {
                // 保存刷新时间
                self.lastUpdateTime = [NSDate date];
                // 通知代理
                if ([_delegate respondsToSelector:@selector(refreshViewEndRefreshing:)]) {
                    [_delegate refreshViewEndRefreshing:self];
                }
                // 回调
                if (_endStateChangeBlock) {
                    _endStateChangeBlock(self);
                }
            }
        }
			break;
            
        case BuddyRefreshStatePulling:
        {
            if (self.viewType != BuddyRefreshTypeFooter) {
                // 设置文字
                _statusLabel.text = kBuddyRefreshHeaderReleaseToRefresh;
                // 执行动画
                [UIView animateWithDuration:kBuddyRefreshAnimationDuration animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation((float)M_PI);
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.top = _scrollViewInitInset.top;
                    _scrollView.contentInset = inset;
                }];
                
            }else{
                // 设置文字
                _statusLabel.text = kBuddyRefreshFooterReleaseToRefresh;
                // 执行动画
                [UIView animateWithDuration:kBuddyRefreshAnimationDuration animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation((float)M_PI);
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.bottom = _scrollViewInitInset.bottom;
                    _scrollView.contentInset = inset;
                    
                }];
            }
        }
            break;
            
        case BuddyRefreshStateRefreshing: // 正在刷新中
        {
            // 开始转圈圈
			[_activityView startAnimating];
            // 隐藏箭头
			_arrowImage.hidden = YES;
            _arrowImage.transform = CGAffineTransformIdentity;
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshViewBeginRefreshing:)]) {
                [_delegate refreshViewBeginRefreshing:self];
            }
            // 回调
            if (_beginRefreshingBlock) {
                _beginRefreshingBlock(self);
            }
            if (self.viewType != BuddyRefreshTypeFooter) {
                // 设置文字
                _statusLabel.text = kBuddyRefreshHeaderRefreshing;
                // 执行动画
                [UIView animateWithDuration:kBuddyRefreshAnimationDuration animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                    // 1.增加64的滚动区域
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.top = _scrollViewInitInset.top + kBuddyRefreshViewHeight;
                    _scrollView.contentInset = inset;
                    // 2.设置滚动位置
                    _scrollView.contentOffset = CGPointMake(0, - _scrollViewInitInset.top - kBuddyRefreshViewHeight);
                }];
            }else{
                [self adjustFrame];
                // 记录刷新前的数量
                _lastRefreshCount = [self totalDataCountInScrollView];
                // 设置文字
                _statusLabel.text = kBuddyRefreshFooterRefreshing;
                _arrowImage.transform = CGAffineTransformMakeRotation((float)M_PI);
                [UIView animateWithDuration:kBuddyRefreshAnimationDuration animations:^{
                    UIEdgeInsets inset = _scrollView.contentInset;
                    CGFloat bottom = kBuddyRefreshViewHeight + _scrollViewInitInset.bottom;
                    CGFloat deltaH = [self contentBreakView];
                    if (deltaH < 0) { // 如果内容高度小于view的高度
                        bottom -= deltaH;
                    }
                    inset.bottom = bottom;
                    _scrollView.contentInset = inset;
                }];
            }
        }
			break;
        default:
            break;
	}
    // 3.存储状态必须要。
    _state = state;
}

#pragma mark 合理的Y值(刚好看到上拉刷新控件时的contentOffset.y，取相反数)
- (CGFloat)validY
{
    if (self.viewType != BuddyRefreshTypeFooter) {
        return _scrollViewInitInset.top;
    }else{
        CGFloat deltaH = [self contentBreakView];
        if (deltaH > 0) {
            return deltaH -_scrollViewInitInset.top;
        } else {
            return -_scrollViewInitInset.top;
        }
    }
}
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)contentBreakView
{
    CGFloat h = _scrollView.frame.size.height - _scrollViewInitInset.bottom - _scrollViewInitInset.top;
    return _scrollView.contentSize.height - h;
}
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return BuddyRefreshStateRefreshing == _state;
}
#pragma mark 开始刷新
- (void)beginRefreshing
{
    _state = BuddyRefreshStateRefreshing;
}
#pragma mark 结束刷新
- (void)endRefreshing
{
    ///也可以让他延迟结束刷新。
    double delayInSeconds = self.viewType == BuddyRefreshTypeFooter ? 0.3 : 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setState:BuddyRefreshStateNormal];
    });
}

- (int)totalDataCountInScrollView
{
    int totalCount = 0;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (int section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        for (int section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}
#pragma mark 重写调整frame
- (void)adjustFrame
{
    if (self.viewType == BuddyRefreshTypeHeader) {
        self.frame = CGRectMake(0, -kBuddyRefreshViewHeight,SCREENBOUND.size.width, kBuddyRefreshViewHeight);
    }else{
        // 内容的高度
        CGFloat contentHeight = _scrollView.contentSize.height;
        // 表格的高度
        CGFloat scrollHeight = _scrollView.frame.size.height - _scrollViewInitInset.top - _scrollViewInitInset.bottom;
        CGFloat y = MAX(contentHeight, scrollHeight);
        // 设置边框
        self.frame = CGRectMake(0, y, _scrollView.frame.size.width, kBuddyRefreshViewHeight);
    }
}

@end
