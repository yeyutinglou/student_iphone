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
//  PublicCreateSuccessBoard.m
//  ClassRoom
//
//  Created by he chao on 14-7-3.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "PublicCreateSuccessBoard.h"

#pragma mark -

@interface PublicCreateSuccessBoard()
{
	//<#@private var#>
}
@end

@implementation PublicCreateSuccessBoard

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
    self.title = @"申请公众号";
    BeeUIImageView *success = [BeeUIImageView spawn];
    success.frame = CGRectMake(42, 30, 236, 100);
    success.image = IMAGESTRING(@"success");
    [self.view addSubview:success];
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
