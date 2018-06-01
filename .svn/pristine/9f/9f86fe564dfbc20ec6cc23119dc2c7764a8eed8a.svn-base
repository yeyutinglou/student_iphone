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
//  StudentHomePageBoard.h
//  ClassRoom
//
//  Created by he chao on 14-7-29.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface StudentHomePageBoard : BaseBoard{
    int pageOffset;
    NSMutableArray *arrayNotes;
    BaseButton *btnReject,*btnAccept,*btnRequest,*btnMessage;
    NSMutableDictionary *dictSelNote;
}
@property (nonatomic, strong) NSMutableDictionary *dictUser;
@property (nonatomic, strong) NSMutableDictionary *dictMessage;
@property (nonatomic, assign) int type; //1friend2request3add
AS_SIGNAL(NAVI_BACK)
AS_SIGNAL(REJECT)
AS_SIGNAL(ACCEPT)
AS_SIGNAL(MESSAGE)
AS_SIGNAL(REQUEST)
AS_SIGNAL(DEL_NOTE)
AS_SIGNAL(DEL_CONFIRM)
AS_SIGNAL(LIKE_NOTE)
AS_SIGNAL(COMMENT)

- (void)showFullImage:(NSArray *)pics imgV:(BeeUIImageView *)imgV index:(int)index;
@end
