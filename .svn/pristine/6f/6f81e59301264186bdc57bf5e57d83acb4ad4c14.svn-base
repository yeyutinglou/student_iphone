//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  NotesDetailBoard.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "NotesDetailBoard.h"

#pragma mark -

@interface NotesDetailBoard()
{
	//<#@private var#>
}
@end

@implementation NotesDetailBoard

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = @"详情";
    
    BeeUIWebView *myWebView = [BeeUIWebView spawn];
    myWebView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44));
    myWebView.url = [NSString stringWithFormat:@"%@%@?id=%@",kSchoolUrl,@"app/article/get_article_detail.action",self.strId];
    [self.view addSubview:myWebView];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

@end
