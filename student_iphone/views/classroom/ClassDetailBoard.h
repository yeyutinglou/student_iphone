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
//  ClassDetailBoard.h
//  ClassRoom
//
//  Created by he chao on 14-6-30.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "Bee.h"
#import "DownloadPopupView.h"
#import "FaceSelectView.h"
#import "StarView.h"
#import <QuickLook/QuickLook.h>

#pragma mark -

@interface ClassDetailBoard : BaseBoard<QLPreviewControllerDelegate>{
    BaseLabel *lbSelected;
    DownloadPopupView *downloadPopupView,*videoPopupView;
    BaseButton *btnOrder;
    BOOL isHot;
    
    NSMutableArray *arrayCourseCharacters,*arrayCourseNote;
    int selIndex;
    
    NSMutableDictionary *dictSelNote,*dictSelCourse;
    UIView *toolBar;
    
    BeeUITextView *field;
    
    FaceSelectView *faceChooseView;
    
    StarView *stars;
    BaseLabel *info;
    
    AvatarView *avatar;
}
@property (nonatomic, strong) NSString *strCurrent;
@property (nonatomic, strong) NSMutableDictionary *dictCourse;

- (void)showFullImage:(NSArray *)pics imgV:(BeeUIImageView *)imgV index:(int)index;

AS_SIGNAL(PRE)
AS_SIGNAL(CHOOSE)
AS_SIGNAL(NEXT)
AS_SIGNAL(CENTER)
AS_SIGNAL(CLOSE)
AS_SIGNAL(ORDER)
AS_SIGNAL(COMMENT)
AS_SIGNAL(SEND_COMMENT)
AS_SIGNAL(COMMENT_ALL)
AS_SIGNAL(DEL_ALERT)
AS_SIGNAL(DEL)
AS_SIGNAL(LIKE)
AS_SIGNAL(PLAY_VIDEO)
AS_SIGNAL(FACE)
AS_SIGNAL(HIDE)
AS_SIGNAL(STAR)
AS_SIGNAL(EVALUATE)
AS_SIGNAL(OPEN_FILE)
AS_SIGNAL(RELOAD_COUNT)
@end
