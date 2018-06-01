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
//  ChatBoard.h
//  ClassRoom
//
//  Created by he chao on 14-6-24.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "Bee.h"
#import "CVScrollPageViewController.h"

#pragma mark -

@interface ChatBoard : BaseBoard<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CVScrollPageViewDeleage>{
    BeeUIImageView *imgToolBar;
    BeeUITextField *field;
    BeeUIButton *btnSend;
    UIView *viewFaces;
    NSMutableArray *arrayMessage;
    CVScrollPageViewController *facePageCtrl;
}

@property (nonatomic, strong) NSMutableDictionary *dictFriend;

AS_SIGNAL(FACE)
AS_SIGNAL(PHOTO)
AS_SIGNAL(SEND)
AS_SIGNAL(CAMERA)
AS_SIGNAL(LOCAL)
AS_SIGNAL(PHOTO_FULL)

@end
