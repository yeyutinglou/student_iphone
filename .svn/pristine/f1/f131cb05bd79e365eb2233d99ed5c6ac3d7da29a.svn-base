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
//  CourseNoteBoard.h
//  ClassRoom
//
//  Created by he chao on 8/4/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface CourseNoteBoard : BaseBoard{
    int pageOffset;
    NSMutableArray *arrayNotes;
    NSMutableDictionary *dictSelNote;
}
@property (nonatomic, strong) NSMutableDictionary *dictCourseNote;
@property (nonatomic, assign) BOOL isUserHomePageEnter;

AS_SIGNAL(DEL_NOTE)
AS_SIGNAL(LIKE_NOTE)
AS_SIGNAL(PLAY_VOICE)
AS_SIGNAL(COMMENT)

- (void)showFullImage:(NSArray *)pics imgV:(BeeUIImageView *)imgV index:(int)index;
@end
