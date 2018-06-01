//
//  WCPageContentView.h
//  WoChe
//
//  Created by He leon on 11-10-27.
//  Copyright (c) 2011年 JuChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageDelegate

- (void)clickPage:(NSInteger)index;

@end

@interface WCPageContentView : UIView{
    id <PageDelegate> m_delegate;
    UIImageView *imgView;
    NSInteger indexPage;
    UIActivityIndicatorView *activityView;
}
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic) NSInteger indexPage;

//- (void)createImageView:(CGRect)frame;
//- (void)loadTopNewsImage:(NSString *)strUrl;
//- (void)loadShopImage:(NSString *)strUrl;
- (void)setDelegate:(id)delegate;
//- (void)showPageTitle:(NSString *)strTitle;

@end
