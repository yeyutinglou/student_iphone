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
//  CurriculumBoard.h
//  ClassRoom
//
//  Created by he chao on 6/27/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"
#import <QuickLook/QuickLook.h>
#import "DownloadPopupView.h"
#pragma mark -

@interface CurriculumBoard : BaseBoard<QLPreviewControllerDelegate>{
    int selIndex;
    int pageOffset;
    NSMutableArray *arrayCurriculum;
    NSMutableDictionary *dictSelCurriculm;
    BaseButton *btnReject,*btnAccept,*btnRequest,*btnMessage;
    DownloadPopupView *downloadPopupView,*videoPopupView;
}
@property (nonatomic, strong) NSMutableDictionary *dictUser;
@property (nonatomic, assign) int type; //1friend2request3add

AS_SIGNAL(NAVI_BACK)
AS_SIGNAL(REJECT)
AS_SIGNAL(ACCEPT)
AS_SIGNAL(MESSAGE)
AS_SIGNAL(REQUEST)
AS_SIGNAL(PLAY)
AS_SIGNAL(DOWNLOAD)
AS_SIGNAL(PLAY_VIDEO)
AS_SIGNAL(OPEN_FILE)
AS_SIGNAL(CLOSE)
@end
