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
//  CommentListBoard.h
//  ClassRoom
//
//  Created by he chao on 6/24/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"
#import "FaceSelectView.h"

#pragma mark -

@interface CommentListBoard : BaseBoard<UITextFieldDelegate>{
    NSMutableArray *arrayComments;
    NSMutableDictionary *dictSelComment;
    BaseLabel *lbCount;
    
    UIView *toolBar;
    
    BeeUITextView *field;
    
    FaceSelectView *faceChooseView;
}
@property (nonatomic, assign) int type;//int 1 note 2 public org
@property (nonatomic, strong) NSMutableDictionary *dictNote;
@property (nonatomic, strong) NSMutableDictionary *dictPublic;

AS_SIGNAL(ALERT)
AS_SIGNAL(DEL_COMMENT)
AS_SIGNAL(SEND_COMMENT)
AS_SIGNAL(FACE)
@end
