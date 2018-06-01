//
//  CVScrollPageViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/4/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCPageContentView.h"
#import "CVPageControlView.h"

#define CVSCROLLPAGE_INDICTOR_WIDTH  150
#define CVSCROLLPAGE_INDICTOR_HEIGHT 18

@protocol CVScrollPageViewDeleage

- (NSUInteger)numberOfPagesInScrollPageView;
- (WCPageContentView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index;
- (void)didScrollToPageAtIndex:(NSUInteger)index;
- (void)selectPageAtIndex:(NSInteger)index;
- (void)scrollViewDrag:(UIScrollView *)sender;
- (void)pageControllerBeginDrag;
- (void)pageControllerEndDrag;
@end

enum pageIndicatorStyle {
	CVScrollPageIndicatorStyleLight,
	CVScrollPageIndicatorStyleHigh
};

@interface CVScrollPageViewController : UIViewController <UIScrollViewDelegate> {
	id<CVScrollPageViewDeleage> pageViewDelegate;
	NSUInteger pageCount;
	UIScrollView *scrollView;
	NSUInteger indicatorStyle;
    UIPageControl *pageControl;
	//CVPageControlView *pageControl;
    UIImageView *imgGuideBG;
    BOOL isGuide;
@private
	CGRect _frame;
	CGRect _pageControlFrame;
	
    NSMutableArray *viewControllers;
	NSMutableArray *arrayViewCache;
	
	// FIXME, cacheIndex should moved;
	NSUInteger cacheSize;
	NSUInteger cacheIndex;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic) BOOL isGuide;
@property (nonatomic) CGRect frame;
@property (nonatomic) CGRect pageControlFrame;
@property (nonatomic) NSUInteger pageCount;
@property (nonatomic) NSUInteger indicatorStyle;
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIPageControl *pageControl;

- (void)reloadData;
- (void)setDelegate:(id)delegate;
- (void)enqueueReusablePage:(WCPageContentView *)pageView atIndex:(NSUInteger)index;
- (WCPageContentView *)dequeueReusablePage:(NSUInteger)index;
- (void)clearReusablePage;

- (void)changePage:(id)sender;
- (void)showGuideImg;
- (void)loadScrollViewWithPage:(NSUInteger)index;

@end
