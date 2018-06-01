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
//  MainBoard.h
//  Walker
//
//  Created by he chao on 3/10/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "Bee.h"
#import "AppTabbar_iPhone.h"
//#import "SocketIOPacket.h"

#pragma mark -


@interface MainBoard : BaseBoard{
    //AppTabbar_iPhone *tabbar;
    CGFloat tabbarOriginY;
    AppTabbar_iPhone *tabbar;
    NSMutableArray *arraySignList;
    NSMutableDictionary *dictSel;
    
}
@property (nonatomic,assign) BOOL isFristEnter;
AS_SINGLETON(MainBoard)

AS_SIGNAL( TAB_0 )
AS_SIGNAL( TAB_1 )
AS_SIGNAL( TAB_2 )
AS_SIGNAL( TAB_3 )
AS_SIGNAL( TAB_4 )

- (void)selectIndexPage:(int)index;
- (void)getSignTime;
- (void)autoCheckin:(NSMutableDictionary *)dict;
@end
