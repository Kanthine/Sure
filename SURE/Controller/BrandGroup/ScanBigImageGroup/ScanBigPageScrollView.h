//
//  ScanBigPageScrollView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ScanBigPageScrollViewDelegate;

@interface ScanBigPageScrollView : UIScrollView


@property (weak, nonatomic)  id<ScanBigPageScrollViewDelegate>pagingViewDelegate;
@property (readonly) UIView *visiblePageView;
@property (assign) BOOL suspendTiling;

- (void)displayPagingViewAtIndex:(NSUInteger)index;
- (void)resetDisplay;

@end


@protocol ScanBigPageScrollViewDelegate <NSObject>

@required

- (Class)pagingScrollView:(ScanBigPageScrollView *)pagingScrollView classForIndex:(NSUInteger)index;
- (NSUInteger)pagingScrollViewPagingViewCount:(ScanBigPageScrollView *)pagingScrollView;
- (UIView *)pagingScrollView:(ScanBigPageScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index;
- (void)pagingScrollView:(ScanBigPageScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index;

@end
