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
//  CheckinBoard.h
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface CheckinBoard : BaseBoard{
    NSMutableArray *arrayStudent;
    BeeUIButton *btnDone;
    NSMutableDictionary *dictSel;
}
@property (nonatomic, strong) NSMutableDictionary *dictCourse;
AS_SIGNAL(DONE)
AS_SIGNAL(CHECK_IN)
@end
