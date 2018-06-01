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
//  PublishBoard.h
//  ClassRoom
//
//  Created by he chao on 14-6-23.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "Bee.h"
#import "PostImage.h"
#import "FaceSelectView.h"

#pragma mark -

@interface PublishBoard : BaseBoard<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BeeUITextView *textView;
    NSMutableArray *arrayImages;
    BeeUIImageView *vi;
    UIScrollView *scrollVPhoto;
    PostImage *postImage;
    
    FaceSelectView *faceChooseView;
}
@property (nonatomic, strong) NSMutableDictionary *dictPublic;

AS_SIGNAL(ADD)
AS_SIGNAL(POST)
AS_SIGNAL(DEL)
AS_SIGNAL(FACE)
AS_SIGNAL(HIDE)
@end
