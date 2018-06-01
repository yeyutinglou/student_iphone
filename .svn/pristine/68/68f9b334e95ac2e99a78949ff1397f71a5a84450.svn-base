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
//  MapBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/17.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "MapBoard.h"
#import <MapKit/MapKit.h>

#pragma mark -

@interface MapBoard()
{
	//<#@private var#>
}
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@end

@implementation MapBoard

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
    self.title = @"地图";
    [self loadContent];
    [self showBackBtn];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
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
    [self.navigationController popViewControllerAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

- (void)loadContent{
}
@end
