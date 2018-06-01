//
//  CreateAccountView.h
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostImage.h"

@class PublicBoard;

@interface CreateAccountView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    AvatarView *logo;
    BeeUITextField *field;
    BeeUITextView *textView;
    PostImage *postImage;
    UIImage *imgTemp;
    BeeUIScrollView *myScrollView;
}
@property (nonatomic, strong) PublicBoard *publicBoard;

AS_SIGNAL(LOGO)
AS_SIGNAL(DONE)
AS_SIGNAL(CAMERA)
AS_SIGNAL(LOCAL)
AS_SIGNAL(HIDE)

- (void)loadContent;
- (void)hideKeyboard;

@end
