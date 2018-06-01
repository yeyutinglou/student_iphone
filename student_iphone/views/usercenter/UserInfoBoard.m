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
//  UserInfoBoard.m
//  ClassRoom
//
//  Created by he chao on 6/27/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "UserInfoBoard.h"
#import "PlayViewController.h"

#pragma mark -

@interface UserInfoBoard()
{
	//<#@private var#>
}
@end

@implementation UserInfoBoard
DEF_SIGNAL(CAMERA)
DEF_SIGNAL(LOCAL)
DEF_SIGNAL(AVATAR)
DEF_SIGNAL(DONE)

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = @"我的";
    [self loadContent];

//    BeeUIButton *btn = [BeeUIButton spawn];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    btn.backgroundColor = [UIColor blackColor];
//    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

- (void)btn{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"m4v"];
//    //视频URL
//    NSURL *url = [NSURL fileURLWithPath:path];
//    //MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    PlayViewController *controller = [[PlayViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8"]];
    [self presentMoviePlayerViewControllerAnimated:controller];

}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL2(UserInfoBoard, signal) {
    if ([signal is:UserInfoBoard.AVATAR]) {
        BeeUIActionSheet *sheet = [BeeUIActionSheet spawn];
        sheet.title = @"请选择操作";
        [sheet addButtonTitle:@"拍照" signal:UserInfoBoard.CAMERA];
        [sheet addButtonTitle:@"从相册选择" signal:UserInfoBoard.LOCAL];
        [sheet addCancelTitle:@"取消"];
        [sheet showInViewController:self];
    }
    else if ([signal is:UserInfoBoard.CAMERA]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypeCamera;
        c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:UserInfoBoard.LOCAL]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:UserInfoBoard.DONE]) {
        if (!imgTemp) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请选择用户头像"];
            return;
        }
        
        if (!postImage) {
            postImage = [[PostImage alloc] init];
        }
        
        postImage.type = PostImageTypeAvatar;
        postImage.mainCtrl = self;
        postImage.arrayImages = [[NSMutableArray alloc] initWithObjects:imgTemp, nil];
        [postImage postImages];
        
    }
}


- (void)uploadImageFailed{
    NSLog(@"d");
}

- (void)uploadImageSuccess:(NSMutableArray *)arrayPicInfo{
    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"更新成功"];
    NSMutableDictionary *dictUser = [kUserInfo mutableCopy];
    [dictUser setObject:arrayPicInfo[0][@"url"] forKey:@"picUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:[dictUser JSONString] forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.stack popBoardAnimated:YES];
}

- (void)loadContent{
    NSMutableDictionary *dictUser = kUserInfo;
    avatar = [AvatarView initFrame:CGRectMake(20, 10, 40, 40) image:IMAGESTRING(@"demo_icon1") borderColor:[UIColor clearColor]];
    [avatar setImageWithURL:kImage100(dictUser[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
    [avatar makeTappable:UserInfoBoard.AVATAR];
    [self.view addSubview:avatar];
    
    labelName = [BaseLabel initLabel:dictUser[@"nickName"] font:FONT(15) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    labelName.frame = CGRectMake(avatar.right+20, avatar.top, 200, 25);
    [self.view addSubview:labelName];
    
    BaseLabel *lb1 = [BaseLabel initLabel:@"点击头像可修改" font:FONT(13) color:RGB(151, 151, 151) textAlignment:NSTextAlignmentLeft];
    lb1.frame = CGRectMake(labelName.left, labelName.bottom-5, 200, 20);
    [self.view addSubview:lb1];
    
    BeeUIImageView *imgInfo = [BeeUIImageView spawn];
    imgInfo.frame = CGRectMake(0, 66, self.viewWidth, 75);
    imgInfo.contentMode = UIViewContentModeScaleToFill;
    imgInfo.image = [IMAGESTRING(@"info_bg") stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    [self.view addSubview:imgInfo];
    
    for (int i = 0; i < 2; i++) {
        BaseLabel *lb2 = [BaseLabel initLabel:i==0?@"院系":@"学号" font:FONT(14) color:RGB(40, 40, 40) textAlignment:NSTextAlignmentLeft];
        lb2.frame = CGRectMake(25, 10+26*i, 200, 24);
        [imgInfo addSubview:lb2];
        
        BaseLabel *lbValue = [BaseLabel initLabel:i==0?dictUser[@"academyName"]:dictUser[@"studentNo"] font:FONT(14) color:RGB(118, 118, 118) textAlignment:NSTextAlignmentLeft];
        lbValue.frame = CGRectMake(80, lb2.top, 200, lb2.height);
        [imgInfo addSubview:lbValue];
        
//        if (isTeacher) {
//            lb2.frame = CGRectMake(lb2.left, 0, lb2.width, imgInfo.height);
//            lbValue.frame = CGRectMake(lbValue.left, 0, lbValue.width, imgInfo.height);
//            if (i==1) {
//                lb2.hidden = YES;
//                lbValue.hidden = YES;
//            }
//        }
    }
    
    BaseButton *btnDone = [BaseButton initBaseBtn:IMAGESTRING(@"btn_green") highlight:IMAGESTRING(@"btn_green_pre") text:@"确 定" textColor:[UIColor whiteColor] font:BOLDFONT(22)];
    btnDone.frame = CGRectMake(10, imgInfo.bottom+30, 300, 40);
    [btnDone addSignal:UserInfoBoard.DONE forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    UIImage * i = [info[@"UIImagePickerControllerEditedImage"] copy];
    if(i.size.width > 640)
    {
        i = [self scaleImage:i toScale:640/i.size.width];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    imgTemp = i;
    avatar.image = i;
    //[self sendImage:i];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
