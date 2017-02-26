//
//  XQCyclingPlayerPicureView.h
//  DayDayUpApp
//
//  Created by xuequan on 16/10/14.
//  Copyright © 2016年 xq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYXCyclingPlayerView;
@protocol CYXCyclingPlayerViewDelegate <NSObject>

- (UICollectionViewCell *)cyclingView:(CYXCyclingPlayerView *)cyclingView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfItemsInCyclingView:(CYXCyclingPlayerView *)cyclingView;

@optional

/** 图片滚动回调 */
- (void)cyclingView:(CYXCyclingPlayerView *)cyclingView didScrollToIndex:(NSInteger)index;

- (void)cyclingView:(CYXCyclingPlayerView *)cyclingView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef NS_ENUM(NSInteger, CYXPageControlPosition) {
    CYXPageControlPositionMiddleBottom, //默认底部居中
    CYXPageControlPositionMiddleTop,
    CYXPageControlPositionLeftTop,
    CYXPageControlPositionLeftBottom,
    CYXPageControlPositionRightTop,
    CYXPageControlPositionRightBottom,
};

@interface CYXCyclingPlayerView : UIView

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes*/
@property (nonatomic, assign) BOOL infiniteLoop;

//每页的item数量,默认1个
@property (nonatomic, assign) NSUInteger itemsPerPage;

/** 是否自动滚动,默认Yes 
 以下情况不会自动滚动:
 1.没有开启无限循环
 2.item总数量<itemsPerPage
 */
@property (nonatomic, assign) BOOL autoScroll;

//是否单页滚动,默认NO
@property(nonatomic, assign) BOOL scrollForSinglePage;

//是否按页滚动,默认YES
@property (nonatomic, assign) BOOL pagingEnabled;

/**
 如果不想使用系统的PageControl,可以将showPageControl置为NO,然后自己addSubView一个自定义页数控制器.
 */
//默认YES
@property (nonatomic, assign) BOOL showPageControl;
//默认底部居中
@property (nonatomic, assign) CYXPageControlPosition pageControlPosition;
@property(nonatomic, assign) CGFloat pageControlEdgeGap;
//默认YES
@property(nonatomic, assign) BOOL hiddenPageControlForSinglePage;
@property(nonatomic, strong) UIColor *pageIndicatorTintColor;
@property(nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;


@property (nonatomic, weak) id<CYXCyclingPlayerViewDelegate>delegate;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;

@end
