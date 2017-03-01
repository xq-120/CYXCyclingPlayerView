//
//  XQCyclingPlayerPicureView.m
//  DayDayUpApp
//
//  Created by xuequan on 16/10/14.
//  Copyright © 2016年 xq. All rights reserved.
//

#import "CYXCyclingPlayerView.h"

#define kScaleFactor 500

@interface CYXCyclingPlayerView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) NSInteger configedTotalItems; //为了无限循环而精心配制的item数量
@property (nonatomic, assign) NSInteger cyclingCnt; //实际items数量

@property (nonatomic, strong) NSIndexPath *configIndexPath;

@end

@implementation CYXCyclingPlayerView

#pragma mark- lifeCycling

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initiate];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initiate];
    }
    
    return self;
}

- (void)initiate
{
    _itemsPerPage = 1;
    _autoScroll = YES;
    _autoScrollTimeInterval = 2.0;
    _scrollForSinglePage = NO;
    _infiniteLoop = YES;
    _showPageControl = YES;
    _hiddenPageControlForSinglePage = YES;
    _pageControlPosition = CYXPageControlPositionMiddleBottom;
    _pageControlEdgeGap = 12;
    _pagingEnabled = YES;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = _pagingEnabled;
    collectionView.bounces = NO;
    _collectionView = collectionView;
    [self addSubview:collectionView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _pageControl.pageIndicatorTintColor = [UIColor brownColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


#pragma mark- getter/setterMethod

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    self.pageControl.hidden = !showPageControl;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    _pagingEnabled = pagingEnabled;
    
    self.collectionView.pagingEnabled = _pagingEnabled;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setupTimer
{
    if (![self canInfiniteLoop]) return; //不自动滚动情况
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll
{
    if (![self canInfiniteLoop]) return; //不自动滚动情况
    
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    if (targetIndex >= self.configedTotalItems) {
        targetIndex = self.configedTotalItems - 1;
    }
    
    UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionNone;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        scrollPosition = UICollectionViewScrollPositionLeft;
    } else {
        scrollPosition = UICollectionViewScrollPositionTop;
    }
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:scrollPosition animated:YES];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}


- (void)setPageControlPosition:(CYXPageControlPosition)pageControlPosition
{
    _pageControlPosition = pageControlPosition;
    [self setNeedsLayout];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    [self reloadData];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}


#pragma mark- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger cyclingCnt = [self.delegate numberOfItemsInCyclingView:self];
    self.cyclingCnt = cyclingCnt;
    self.pageControl.numberOfPages = cyclingCnt;
    
    if (cyclingCnt == 1 && self.hiddenPageControlForSinglePage) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = !self.showPageControl;
    }
    
    if (![self canInfiniteLoop]) { //不循环滚动
        self.configedTotalItems = cyclingCnt;
    } else {
        self.configedTotalItems = kScaleFactor * cyclingCnt + 2*cyclingCnt;
    }
    
    return self.configedTotalItems;
}

- (BOOL)canInfiniteLoop
{
    if (self.cyclingCnt < self.itemsPerPage || (self.cyclingCnt == self.itemsPerPage && self.scrollForSinglePage == NO) || self.infiniteLoop == NO){
        return NO;
    }
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.configIndexPath = indexPath;
    
    if (![self canInfiniteLoop]) { //不循环滚动
        UICollectionViewCell *cell = [self.delegate cyclingView:self cellForItemAtIndexPath:indexPath];
        [cell setNeedsLayout];
        return cell;
    }
    
    NSInteger cyclingRow = indexPath.row%self.cyclingCnt;
    NSIndexPath *cyclingIndexPath = [NSIndexPath indexPathForRow:cyclingRow inSection:indexPath.section];
    
    UICollectionViewCell *cell = [self.delegate cyclingView:self cellForItemAtIndexPath:cyclingIndexPath];
    [cell setNeedsLayout];
    
    return cell;
}


#pragma mark- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(collectionView.frame.size.width/self.itemsPerPage, collectionView.frame.size.height);

    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cyclingView:didSelectItemAtIndexPath:)]) {
        
        NSInteger index = indexPath.row%self.cyclingCnt;
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:indexPath.section];
        [self.delegate cyclingView:self didSelectItemAtIndexPath:path];
    }
}


#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger currentIndex = [self currentIndex]; //当前页
    if (currentIndex >= self.configedTotalItems - self.itemsPerPage) { //超过最后一页
        if ([self canInfiniteLoop]) {
            NSInteger targetIndex = currentIndex - kScaleFactor * self.cyclingCnt; //(一屏有多item)
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }

    [self setupPageControl];
}

- (void)setupPageControl
{
    NSInteger index = [self currentIndex];
    NSInteger currentPage = [self pageControlIndexWithCurrentCellIndex:index];
    self.pageControl.currentPage = currentPage; //设置分页符
    
    if ([self.delegate respondsToSelector:@selector(cyclingView:didScrollToIndex:)]) {
        [self.delegate cyclingView:self didScrollToIndex:currentPage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setupPageControl];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollBoundary];
    [self setupPageControl];
    [self setAutoScroll:self.autoScroll];
}

- (void)handleScrollBoundary
{
    if (![self canInfiniteLoop]) return; //不自动滚动情况
    
    NSInteger index = [self currentIndex];
    if (index >= self.configedTotalItems - self.itemsPerPage) {
        index -= kScaleFactor*self.cyclingCnt;
    } else if (index <= 0) {
        index = self.cyclingCnt;
    }
    
    UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionNone;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        scrollPosition = UICollectionViewScrollPositionLeft;
    } else {
        scrollPosition = UICollectionViewScrollPositionTop;
    }
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:scrollPosition animated:NO];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat itemW = self.collectionView.frame.size.width/self.itemsPerPage;
    NSInteger index = 0;
    NSInteger tempIndex = (NSInteger)(offset.x/itemW);
    NSInteger more = offset.x - tempIndex*itemW >= itemW * 0.5?1:0;
    index = tempIndex+more;
    CGFloat targetX = itemW * index;
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self handleScrollBoundary];
        [self setupPageControl];
        [self setAutoScroll:self.autoScroll];
    }
}


#pragma mark- publicMethod

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:self.configIndexPath];
    return cell;
}

- (void)reloadData
{
    [self invalidateTimer];
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setAutoScroll:self.autoScroll];
    });
}


#pragma mark- privateMethod

- (NSInteger)currentIndex
{
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) {
        return 0;
    }
    
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat itemW = self.collectionView.frame.size.width/self.itemsPerPage;
        NSInteger tempIndex = (NSInteger)(self.collectionView.contentOffset.x/itemW);
        NSInteger more = self.collectionView.contentOffset.x - tempIndex*itemW >= itemW * 0.5?1:0;
        index = tempIndex+more;
    } else if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //垂直方向
        CGFloat itemH = self.collectionView.frame.size.height/self.itemsPerPage;
        NSInteger tempIndex = (NSInteger)(self.collectionView.contentOffset.y/itemH);
        NSInteger more = self.collectionView.contentOffset.y - tempIndex*itemH >= itemH * 0.5?1:0;
        index = tempIndex+more;
    }
    
    return index;
}

- (NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    if (self.cyclingCnt == 0) {
        return 0; //防崩溃
    }
    NSInteger cyclingIndex = index%self.cyclingCnt;
    return cyclingIndex;
}


#pragma mark- layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];

    _collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _collectionView.contentInset = UIEdgeInsetsZero;
    
    if (!_pageControl.hidden) {
        NSInteger cyclingCnt = [self.delegate numberOfItemsInCyclingView:self];
        CGFloat pageControlW = cyclingCnt * 15;
        CGRect pageControlF = CGRectZero;
        switch (_pageControlPosition) {
            case CYXPageControlPositionMiddleBottom:
                pageControlF = CGRectMake(self.frame.size.width/2.0f - pageControlW/2.0f, self.frame.size.height - 20, pageControlW, 20);
                break;
            case CYXPageControlPositionMiddleTop:
                pageControlF = CGRectMake(self.frame.size.width/2.0f - pageControlW/2.0f, 0, pageControlW, 20);
                break;
            case CYXPageControlPositionRightTop:
                pageControlF = CGRectMake(self.frame.size.width - pageControlW - _pageControlEdgeGap, 0, pageControlW, 20);
                break;
            case CYXPageControlPositionRightBottom:
                pageControlF = CGRectMake(self.frame.size.width - pageControlW - _pageControlEdgeGap, self.frame.size.height - 20, pageControlW, 20);
                break;
            case CYXPageControlPositionLeftTop:
                pageControlF = CGRectMake(_pageControlEdgeGap, 0, pageControlW, 20);
                break;
            case CYXPageControlPositionLeftBottom:
                pageControlF = CGRectMake(_pageControlEdgeGap, self.frame.size.height - 20, pageControlW, 20);
                break;
            default:
                break;
        }
        _pageControl.frame = pageControlF;
    }
    
    NSInteger configedTotalItems = [_collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    if (_collectionView.contentOffset.x == 0 && configedTotalItems > 0) {
        NSInteger targetIndex = 0;
        if (_configedTotalItems == _cyclingCnt * kScaleFactor + 2*_cyclingCnt) {
            targetIndex = _cyclingCnt; //初始位置在第一个周期
        }
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        [self setAutoScroll:_autoScroll];
    }
}

@end
