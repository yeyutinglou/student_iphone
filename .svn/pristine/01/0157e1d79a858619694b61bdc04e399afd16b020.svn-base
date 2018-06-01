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
//  PublicIntroBoard.h
//  ClassRoom
//
//  Created by he chao on 14-6-23.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "Bee.h"
#import "PostImage.h"

#pragma mark -

@interface PublicIntroBoard : BaseBoard<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BeeUITextField *fieldName;
    BeeUITextView *textIntro;
    BaseButton *btnDone;
    PostImage *postImage;
    UIImage *imgTemp;
    AvatarView *avatar;
}

AS_SIGNAL(ATTENTION)
AS_SIGNAL(CANCEL)
AS_SIGNAL(UPDATE)
AS_SIGNAL(HIDE)
AS_SIGNAL(CAMERA)
AS_SIGNAL(LOCAL)
AS_SIGNAL(LOGO)

@property (nonatomic, strong) NSMutableDictionary *dictInfo;
@property (nonatomic, assign) BOOL isInfoEnter;
@property (nonatomic, strong) NSString *strPublicOrgId;
@end
