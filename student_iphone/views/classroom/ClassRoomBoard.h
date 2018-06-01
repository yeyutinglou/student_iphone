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
//  ClassRoomBoard.h
//  ClassRoom
//
//  Created by he chao on 6/17/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"
#import "CVScrollPageViewController.h"
#import "ScheduleView.h"

#pragma mark -

@interface ClassRoomBoard : BaseBoard<CVScrollPageViewDeleage>{
    CVScrollPageViewController *pageCtrl;
    BaseLabel *lbWeek[5],*lbDate[5];
    BeeUIButton *btn[5];
    UIView *line[5];
    NSMutableArray *arrayCourse;
    NSArray *weeks;
    NSDate *dateIndex0,*dateSel;
    int weekdayIndex0;
    ScheduleView *schedule;
}
AS_SIGNAL(WEEK)
AS_SIGNAL(PRE)
AS_SIGNAL(NEXT)
@end
