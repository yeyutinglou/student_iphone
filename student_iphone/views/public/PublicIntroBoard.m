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
//  PublicIntroBoard.m
//  ClassRoom
//
//  Created by he chao on 14-6-23.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "PublicIntroBoard.h"

#pragma mark -

@interface PublicIntroBoard()
{
	//<#@private var#>
}
@end

@implementation PublicIntroBoard
DEF_SIGNAL(ATTENTION)
DEF_SIGNAL(CANCEL)
DEF_SIGNAL(UPDATE)
DEF_SIGNAL(HIDE)
DEF_SIGNAL(CAMERA)
DEF_SIGNAL(LOCAL)
DEF_SIGNAL(LOGO)

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
    self.title = self.dictInfo[@"name"];
    if (!self.isInfoEnter) {
        [self loadContent];
    }
    else {
        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"正在加载"];
        [self getPublicInfo];
    }
    
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

ON_SIGNAL2(PublicIntroBoard, signal) {
    if ([signal is:PublicIntroBoard.ATTENTION]) {
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/publc_org_fans.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"fansType",@"1").PARAM(@"publicOrgId",self.dictInfo[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9528;
    }
    else if ([signal is:PublicIntroBoard.CANCEL]) {
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/publc_org_fans.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"fansType",@"2").PARAM(@"publicOrgId",self.dictInfo[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9529;
    }
    else if ([signal is:PublicIntroBoard.UPDATE]) {
        if (kStrTrim(fieldName.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"社团名字不能为空"];
            return;
        }
        else if (kStrTrim(textIntro.text).length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入社团介绍"];
            return;
        }
        else if (kStrTrim(fieldName.text).length>12) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"社团名字不能超过12个字符"];
            return;
        }
        else if (kStrTrim(textIntro.text).length >50) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"社团介绍不能超出50个字符"];
            return;
        }
        [textIntro resignFirstResponder];
        [fieldName resignFirstResponder];
        
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/upd_public_org_info.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"name",fieldName.text).PARAM(@"description",textIntro.text).PARAM(@"publicOrgId",self.dictInfo[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9527;
    }
    else if ([signal is:PublicIntroBoard.HIDE]) {
        [textIntro resignFirstResponder];
        [fieldName resignFirstResponder];
    }
    else if ([signal is:PublicIntroBoard.LOGO]) {
        BeeUIActionSheet *sheet = [BeeUIActionSheet spawn];
        sheet.title = @"请选择操作";
        [sheet addButtonTitle:@"拍照" signal:PublicIntroBoard.CAMERA];
        [sheet addButtonTitle:@"从相册选择" signal:PublicIntroBoard.LOCAL];
        [sheet addCancelTitle:@"取消"];
        [sheet showInViewController:self];
    }
    else if ([signal is:PublicIntroBoard.CAMERA]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypeCamera;
        c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:PublicIntroBoard.LOCAL]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        NETWORK_ERROR
        [[BeeUITipsCenter sharedInstance] dismissTips];
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"更新成功"];
                        [self.stack popBoardAnimated:YES];
                    }
                        break;
                    case 9528:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"关注成功"];
                      //  [self.dictInfo setObject:@"1" forKey:@"inPublicOrgStatus"];
                        [btnDone setTitle:@"取消关注" forState:UIControlStateNormal];
                        [btnDone addSignal:PublicIntroBoard.CANCEL forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 9529:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"取消关注成功"];
                       // [self.dictInfo setObject:@"0" forKey:@"inPublicOrgStatus"];
                        [btnDone setTitle:@"关 注" forState:UIControlStateNormal];
                        [btnDone addSignal:PublicIntroBoard.ATTENTION forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 9530:
                    {
                        self.dictInfo = json[@"result"];
                        self.title = self.dictInfo[@"name"];
                        [self loadContent];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
        }
    }
}

- (void)getPublicInfo{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/get_public_org_info.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"publicOrgId",self.strPublicOrgId);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9530;
}


- (void)loadContent{
    [self.view makeTappable:PublicIntroBoard.HIDE];
    BOOL isMine = [kUserInfo[@"id"] intValue]==[self.dictInfo[@"createUserId"] intValue];
    avatar = [AvatarView initFrame:CGRectMake(10, 10, 40, 40) image:IMAGESTRING(@"demo_icon1") borderColor:[UIColor clearColor]];
    [avatar setImageWithURL:kImage100(self.dictInfo[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_img")];
    [self.view addSubview:avatar];
    if (isMine) {
        [avatar makeTappable:PublicIntroBoard.LOGO];
    }
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(avatar.left, avatar.bottom+10, 290, 0.5);
    line.backgroundColor = RGB(202, 202, 202);
    [self.view addSubview:line];
    
    BaseLabel *lb1 = [BaseLabel initLabel:@"社团简介" font:FONT(13) color:RGB(60,60,60) textAlignment:NSTextAlignmentLeft];
    lb1.frame = CGRectMake(line.left, line.bottom+13, 100, 15);
    [self.view addSubview:lb1];
    
    btnDone = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:isMine?@"确  定":@"取消关注" textColor:[UIColor whiteColor] font:BOLDFONT(22)];
    btnDone.frame = CGRectMake(lb1.left, 230, 300, 40);
    [btnDone addSignal:PublicIntroBoard.UPDATE forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
    if (!isMine) {
        [btnDone setBackgroundImage:IMAGESTRING(@"btn_yellow") forState:UIControlStateNormal];
        if ([self.dictInfo[@"inPublicOrgStatus"] boolValue]) {
            [btnDone setTitle:@"取消关注" forState:UIControlStateNormal];
            [btnDone addSignal:PublicIntroBoard.CANCEL forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [btnDone setTitle:@"关 注" forState:UIControlStateNormal];
            [btnDone addSignal:PublicIntroBoard.ATTENTION forControlEvents:UIControlEventTouchUpInside];
        }
        if ([_dictInfo[@"publicOrgType"] intValue]==2) {
            btnDone.hidden = YES;
        }
    }
    
    fieldName = [BeeUITextField spawn];
    fieldName.frame = CGRectMake(avatar.right+20, avatar.top+7, 230, 25);
    fieldName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fieldName.text = self.dictInfo[@"name"];
    fieldName.font = FONT(14);
    
    
    textIntro = [BeeUITextView spawn];
    textIntro.frame = CGRectMake(fieldName.left, lb1.top, fieldName.width, 100);
    textIntro.text = self.dictInfo[@"description"];
    textIntro.font = FONT(14);
    
    if (isMine) {
        fieldName.backgroundColor = [UIColor whiteColor];
        fieldName.layer.borderWidth = 0.5;
        fieldName.leftViewMode = UITextFieldViewModeAlways;
        fieldName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
        fieldName.layer.borderColor = RGB(202, 202, 202).CGColor;
        
        textIntro.backgroundColor = [UIColor whiteColor];
        textIntro.layer.borderWidth = 0.5;
        textIntro.layer.borderColor = RGB(202, 202, 202).CGColor;
    }
    else {
        fieldName.userInteractionEnabled = NO;
        textIntro.userInteractionEnabled = NO;
    }
    
    [self.view addSubview:fieldName];
    [self.view addSubview:textIntro];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    UIImage * i = [info[@"UIImagePickerControllerEditedImage"] copy];
    if(i.size.width > 640)
    {
        i = [self scaleImage:i toScale:640/i.size.width];
    }
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    imgTemp = i;
    //logo.image = i;
    [self sendImage:i];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)sendImage:(UIImage *)image{
    postImage = [[PostImage alloc] init];
    postImage.type = PostImageTypePublic;
    postImage.mainCtrl = self;
    postImage.dictInfo = self.dictInfo;
    postImage.arrayImages = [[NSMutableArray alloc] initWithObjects:imgTemp, nil];
    [postImage postImages];
}

- (void)uploadImageFailed{
    NSLog(@"d");
}

- (void)uploadImageSuccess:(NSMutableArray *)arrayPicInfo{
    //NSString *strURL = arrayPicInfo[0][@"url"];
    [_dictInfo setObject:arrayPicInfo[0][@"url"] forKey:@"picUrl"];
    //dictInfo[@"picUrl"]
    avatar.image = imgTemp;
}

@end
