//
//  CreateAccountView.m
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "CreateAccountView.h"
#import "PublicBoard.h"
#import "PublicCreateSuccessBoard.h"

@implementation CreateAccountView

DEF_SIGNAL(LOGO)
DEF_SIGNAL(DONE)
DEF_SIGNAL(CAMERA)
DEF_SIGNAL(LOCAL)
DEF_SIGNAL(HIDE)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

ON_SIGNAL2(BeeUITextField, signal){
    if ([signal is:BeeUITextField.RETURN]) {
        [field resignFirstResponder];
    }
    else if ([signal is:BeeUITextField.WILL_ACTIVE]){
        [myScrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    }
}

ON_SIGNAL2(BeeUITextView, signal) {
    if ([signal is:BeeUITextView.RETURN]) {
        [textView resignFirstResponder];
    }
    else if ([signal is:BeeUITextView.WILL_ACTIVE]){
        [myScrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }

}

ON_SIGNAL2(CreateAccountView, signal){
    if ([signal is:CreateAccountView.DONE]) {
        if (kStrTrim(field.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入公众号名称"];
            return;
        }
        else if (kStrTrim(textView.text).length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入公众号简介"];
            return;
        }
        else if (kStrTrim(field.text).length>12) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"公众号名字不能超过12个字符"];
            return;
        }
        else if (kStrTrim(textView.text).length >50) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"公众号介绍不能超出50个字符"];
            return;
        }
        else if (!imgTemp) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请选择上传公众号logo"];
            return;
        }
        
        postImage = [[PostImage alloc] init];
        postImage.type = PostImageTypePublic;
        postImage.mainCtrl = self;
        postImage.arrayImages = [[NSMutableArray alloc] initWithObjects:imgTemp, nil];
        [postImage postImages];
        
        [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在创建"];
        
//        PublicCreateSuccessBoard *board = [[PublicCreateSuccessBoard alloc] init];
//        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:CreateAccountView.LOGO]) {
        BeeUIActionSheet *sheet = [BeeUIActionSheet spawn];
        sheet.title = @"请选择操作";
        [sheet addButtonTitle:@"拍照" signal:CreateAccountView.CAMERA];
        [sheet addButtonTitle:@"从相册选择" signal:CreateAccountView.LOCAL];
        [sheet addCancelTitle:@"取消"];
        [sheet showInView:self];
    }
    else if ([signal is:CreateAccountView.CAMERA]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypeCamera;
        c.allowsEditing = YES;
        [[MainBoard sharedInstance] presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:CreateAccountView.LOCAL]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        c.allowsEditing = YES;
        [[MainBoard sharedInstance] presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:CreateAccountView.HIDE]){
        [field resignFirstResponder];
        [textView resignFirstResponder];
    }
}

- (void)hideKeyboard{
    [field resignFirstResponder];
    [textView resignFirstResponder];
}

- (void)uploadImageFailed{
    NSLog(@"d");
}

- (void)uploadImageSuccess:(NSMutableArray *)arrayPicInfo{
    NSString *strURL = arrayPicInfo[0][@"url"];
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/create_public_org.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"name",field.text).PARAM(@"description",textView.text).PARAM(@"picUrl",strURL);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
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
                if (request.tag == 9527) {
                    //[BeeUIAlertView showMessage:@"创建成功" cancelTitle:@"确定"];
                    [self clearContent];
                    PublicCreateSuccessBoard *board = [[PublicCreateSuccessBoard alloc] init];
                    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
                }
            }
                break;
            case 1:
            {
                [self clearContent];
                [[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
            }
                break;
            case 2:
            {
            }
                break;
            default:
            {
                [[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
            }
                break;
                
        }
    }
}

-(void)clearContent{
    textView.text = nil;
    field.text = nil;
    logo.image = IMAGESTRING(@"create_logo");
}

- (void)loadContent{
    myScrollView = [BeeUIScrollView spawn];
    myScrollView.frame = self.bounds;
    [myScrollView makeTappable:CreateAccountView.HIDE];
    [self addSubview:myScrollView];
    
    logo = [AvatarView initFrame:CGRectMake(50, 15, 80, 80) image:nil borderColor:[UIColor clearColor]];
    logo.image = IMAGESTRING(@"create_logo");
    [logo makeTappable:CreateAccountView.LOGO];
    [myScrollView addSubview:logo];
    
    BeeUIImageView *img1 = [BeeUIImageView spawn];
    img1.frame = CGRectMake(logo.right+10, logo.top+10, 151, 59);
    img1.image = IMAGESTRING(@"create_description");
    [myScrollView addSubview:img1];
    BeeUILabel *lb[2];
    for (int i = 0; i < 2; i++) {
        lb[i] = [BeeUILabel spawn];
        lb[i].frame = CGRectMake(0, 115+50*i, 52, 38);
        lb[i].textColor = [UIColor blackColor];
        lb[i].font = FONT(16);
        lb[i].text = i==0?@"取名":@"简介";
        [myScrollView addSubview:lb[i]];
    }
    
    field = [BeeUITextField spawn];
    field.frame = CGRectMake(lb[0].right, lb[0].top-2, 255, 40);
    field.backgroundImage = IMAGESTRING(@"create_textfield");
    field.font = FONT(14);
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.clearButtonMode = UITextFieldViewModeAlways;
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    field.placeholder = @"取名别太长，别超过十二字";
    field.returnKeyType = UIReturnKeyDone;
    [myScrollView addSubview:field];
    
    textView = [BeeUITextView spawn];
    textView.frame = CGRectMake(field.left, field.bottom+15, 255, 90);
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = RGB(190, 190, 190).CGColor;
    textView.layer.cornerRadius = 5;
    //textView.backgroundImage = [IMAGESTRING(@"create_textfield") stretchableImageWithLeftCapWidth:22 topCapHeight:20];
    textView.font = FONT(14);
    textView.returnKeyType = UIReturnKeyDone;
    textView.placeholder = @"简短的说明，别超过五十字";
    [myScrollView addSubview:textView];
    
    BaseButton *btn = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"完成" textColor:[UIColor whiteColor] font:BOLDFONT(15)];
    btn.frame = CGRectMake(field.left, textView.bottom+15, 256, 40);
    [btn addSignal:CreateAccountView.DONE forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btn];
    
    //myScrollView.contentSize = CGSizeMake(self.width, self.height+80);
    
    [self makeTappable:CreateAccountView.HIDE];
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
    logo.image = i;
    //[self sendImage:i];
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


@end
