//
//  WCPageContentView.m
//  WoChe
//
//  Created by He leon on 11-10-27.
//  Copyright (c) 2011年 JuChe. All rights reserved.
//

#import "WCPageContentView.h"
//#import "WCDefine.h"

@implementation WCPageContentView
@synthesize imgView;
@synthesize indexPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [activityView startAnimating];
        activityView.hidesWhenStopped = YES;
        //[self addSubview:activityView];
    }
    return self;
}

- (void)createImageView:(CGRect)frame{
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    view.userInteractionEnabled = YES;
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [self addSubview:view];
    self.imgView = view;
}

- (void)setDelegate:(id)delegate{
    m_delegate = delegate;
}

- (void)clickButton{
    [m_delegate clickPage:indexPage];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"dddddddddddddddd");
}

/*
- (void)loadTopNewsImage:(NSString *)strUrl{
    NSString *imgstr = [NSString stringWithFormat:@"%@TopNewsImage/%@",WOCHE_BASE_URL,strUrl];
    NSURL *imgurl = [[NSURL alloc] initWithString:imgstr];
    NSData *imgdata = [[NSData alloc] initWithContentsOfURL:imgurl];
    UIImage *img = [UIImage imageWithData:imgdata];
    imgView.image = img;
    [activityView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
}

- (void)loadShopImage:(NSString *)strUrl{
    NSString *imgstr = [NSString stringWithFormat:@"%@ShopImage/%@",WOCHE_BASE_URL,strUrl];
    NSURL *imgurl = [[NSURL alloc] initWithString:imgstr];
    NSData *imgdata = [[NSData alloc] initWithContentsOfURL:imgurl];
    UIImage *img = [UIImage imageWithData:imgdata];
    imgView.image = img;
    [activityView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
}

- (void)showPageTitle:(NSString *)strTitle{
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.imgView.frame.size.width, 25)];
    [imgView addSubview:labelTitle];
    [labelTitle setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
    labelTitle.text = [NSString stringWithFormat:@"     %@",strTitle];
    labelTitle.textColor = [UIColor whiteColor];
}

 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
