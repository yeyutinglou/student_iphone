//
//  ScheduleView.h
//  ClassRoom
//
//  Created by he chao on 7/4/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleView : UIView{
    BeeUIScrollView *myScrollView;
}
@property (nonatomic, strong) NSMutableArray *arrayCourse;
@property (nonatomic, strong) NSDate *selDate;
@property (nonatomic, strong) NSMutableArray *arrayAutho;
AS_SIGNAL(DETAIL)
AS_SIGNAL(WRITE)
AS_SIGNAL(CHECKIN)
AS_SIGNAL(SEARCH)
AS_SIGNAL(LOCATION)
AS_SIGNAL(SIGNIN)
- (void)loadContent;

@end
