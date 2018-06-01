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
//  PublicBoard.h
//  ClassRoom
//
//  Created by he chao on 6/17/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"
#import "PublicInfoView.h"
#import "SchoolPublicView.h"
#import "CreateAccountView.h"

#pragma mark -

@interface PublicBoard : BaseBoard{
    BeeUISegmentedControl *segment;
    PublicInfoView *viewPublicInfo;
    SchoolPublicView *viewSchoolPublic;
    CreateAccountView *viewCreate;
}

- (void)showFullImage:(NSArray *)pics imgV:(BeeUIImageView *)imgV index:(int)index;

AS_SIGNAL(INFO)
AS_SIGNAL(PUBLIC)
AS_SIGNAL(CREATE)
@end
