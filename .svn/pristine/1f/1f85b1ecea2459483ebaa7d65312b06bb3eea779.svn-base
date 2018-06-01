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
//  PublicAccountInfoListBoard.h
//  ClassRoom
//
//  Created by he chao on 6/23/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"
#import "CVScrollPageViewController.h"
#import "FaceSelectView.h"

#pragma mark -

@interface PublicAccountInfoListBoard : BaseBoard<CVScrollPageViewDeleage>{
    NSMutableArray *arrayMsgList;
    int pageOffset;
    UIView *toolBar;
    BeeUITextView *field;
    CVScrollPageViewController *facePageCtrl;
    FaceSelectView *faceChooseView;
    NSMutableDictionary *dictSelPublicInfo;
}
@property (nonatomic, strong) NSMutableDictionary *dictInfo;

AS_SIGNAL(COMMENT_ALL)
AS_SIGNAL(COMMENT)
AS_SIGNAL(FACE)
AS_SIGNAL(SEND)

- (void)showFullImage:(NSArray *)pics imgV:(BeeUIImageView *)imgV index:(int)index;
@end
