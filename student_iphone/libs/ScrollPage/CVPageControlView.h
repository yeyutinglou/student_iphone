//
//  CVPageControlView.h
//  CapitalValDemo
//
//  Created by leon on 10-8-23.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVPageControlView : UIPageControl {
	// pageControlStyle defines the color of indicator
	// 0 means light, usually is utilised by view with high-colored background
	// 1 means high, usually is utilised by view with light-colored background
	NSUInteger pageControlStyle;
}

@property (nonatomic, assign) NSUInteger pageControlStyle;

@end
