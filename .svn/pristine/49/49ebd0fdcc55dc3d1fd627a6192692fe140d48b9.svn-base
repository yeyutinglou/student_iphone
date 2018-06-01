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
//  UserInfoBoard.h
//  ClassRoom
//
//  Created by he chao on 6/27/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"
#import "PostImage.h"

#pragma mark -

@interface UserInfoBoard : BaseBoard<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    AvatarView *avatar;
    BaseLabel *labelName;
    UIImage *imgTemp;
    
    PostImage *postImage;
}

@property (nonatomic, assign) BOOL isRoleTeacher;

AS_SIGNAL(CAMERA)
AS_SIGNAL(LOCAL)
AS_SIGNAL(AVATAR)
AS_SIGNAL(DONE)
@end
