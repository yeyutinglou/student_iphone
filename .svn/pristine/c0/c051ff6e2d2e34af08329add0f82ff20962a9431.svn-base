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
//  PublishBoard.m
//  ClassRoom
//
//  Created by he chao on 14-6-23.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "PublishBoard.h"

#pragma mark -

@interface PublishBoard()
{
	//<#@private var#>
}
@end

@implementation PublishBoard
DEF_SIGNAL(ADD)
DEF_SIGNAL(POST)
DEF_SIGNAL(DEL)
DEF_SIGNAL(FACE)
DEF_SIGNAL(HIDE)

- (void)load
{
    arrayImages = [[NSMutableArray alloc] init];
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.navigationController.navigationBarHidden = NO;
    [self showNaviBar];
    [self showBackBtn];
    [self showBarButton:UINavigationBar.BARBUTTON_RIGHT title:@"完成"];
    [self loadContent];
    self.title = @"发布";
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
    [self sendUISignal:PublishBoard.POST];
}

ON_SIGNAL2(PublishBoard, signal)
{
    if ([signal is:PublishBoard.ADD]) {
        [textView resignFirstResponder];
        if (arrayImages.count>=9) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"您最多可以同时上传9张照片"];
            return;
        }
        
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //c.sourceType = self.isCamera?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
        //c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:PublishBoard.POST]) {
        if (kStrTrim(textView.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入您的信息"];
            return;
        }
        
        if (!arrayImages || arrayImages.count==0) {
            [self postPublicMsg:nil];
        }
        else {
            [self postImages];
        }
        [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在发布"];
    }
    else if ([signal is:PublishBoard.DEL]) {
        BeeUIButton *btn = (BeeUIButton *)signal.object;
        int index = btn.tag - 9527;
        [arrayImages removeObjectAtIndex:index];
        [self reloadImages];
    }
    else if ([signal is:PublishBoard.HIDE]) {
        [textView resignFirstResponder];
        faceChooseView.hidden = YES;
    }
    else if ([signal is:PublishBoard.FACE]) {
        if (!faceChooseView) {
            faceChooseView = [[FaceSelectView alloc] initWithFrame:CGRectMake(0, self.viewHeight-(IOS7_OR_LATER?64:44)-160, self.viewWidth, 160)];
            faceChooseView.mainCtrl = self;
            [faceChooseView loadContent];
        }
        [textView resignFirstResponder];
        faceChooseView.hidden = NO;
        [self.view addSubview:faceChooseView];
    }
}

ON_SIGNAL2(BeeUITextView, signal) {
    if ([signal is:BeeUITextView.WILL_ACTIVE]) {
        faceChooseView.hidden = YES;
    }
    else if ([signal is:BeeUITextView.RETURN]) {
        [textView resignFirstResponder];
    }
}

- (void)chooseFace:(NSString *)strFace{
    textView.text = [NSString stringWithFormat:@"%@%@",textView.text,strFace];
}

- (void)delFace{
    NSMutableArray *arrayContent = [[DataUtils sharedInstance] getMessageArray:textView.text];
    if (arrayContent.count>0) {
        NSString *strLast = [arrayContent lastObject];
        if ([strLast hasPrefix:@"["] && [strLast hasSuffix:@"]"]) {
            textView.text = [textView.text substringToIndex:textView.text.length-strLast.length];
        }
    }
}

- (void)postImages{
    if (!postImage) {
        postImage = [[PostImage alloc] init];
    }
    
    postImage.type = PostImageTypePublicInfo;
    postImage.mainCtrl = self;
    postImage.arrayImages = arrayImages;
    [postImage postImages];
}

- (void)uploadImageFailed{
    NSLog(@"d");
}

- (void)uploadImageSuccess:(NSMutableArray *)arrayPicInfo{
    NSMutableString *strIds = [[NSMutableString alloc] init];
    for (int i = 0; i<arrayPicInfo.count; i++) {
        [strIds appendString:arrayPicInfo[i][@"id"]];
        [strIds appendString:@","];
    }
    [self postPublicMsg:strIds];
}

- (void)postPublicMsg:(NSString *)strImageIds{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/add_public_org_msg.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"publicOrgId",self.dictPublic[@"id"]).PARAM(@"content",textView.text);
    if (strImageIds) {
        request.PARAM(@"picIds",strImageIds);
    }
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
                switch (request.tag) {
                    case 9527:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"发布成功"];
                        [self.stack popBoardAnimated:YES];
                        
                        [textView resignFirstResponder];
                        faceChooseView.hidden = YES;
                        [self postNotification:@"newPublicInfo"];
                        //arrayCourseCharacters = json[@"result"];
                    }
                        break;
                    case 9528:
                    {
                        //                        arrayCourseNote = json[@"result"];
                        //                        [myTableView reloadData];
                    }
                        break;
                    case 9529:
                    {
                    }
                        break;
                    case 9530:
                    {
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                switch (request.tag) {
                    case 9527:
                    {
                    }
                        break;
                    case 9528:
                    {
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


- (void)loadContent{
    
    [self.view makeTappable:PublishBoard.HIDE];
    BeeUIImageView *temp = [BeeUIImageView spawn];
    temp.hidden = YES;
    [self.view addSubview:temp];
    
    UIView *viTop = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 110)];
    viTop.backgroundColor = [UIColor whiteColor];
    viTop.layer.borderWidth = 1;
    viTop.layer.borderColor = RGB(212, 212, 212).CGColor;
    [self.view addSubview:viTop];
    
    textView = [BeeUITextView spawn];
    textView.frame = CGRectMake(0, 0, viTop.width, 75);
    textView.placeholder = @"发布您的信息";
    textView.font = FONT(16);
    textView.backgroundColor = [UIColor whiteColor];
    textView.returnKeyType = UIReturnKeyDone;
    [viTop addSubview:textView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(1, textView.bottom, viTop.width-2, viTop.height-textView.bottom-1)];
    grayView.backgroundColor = RGB(225, 225, 225);
    [viTop addSubview:grayView];
    
    BaseButton *btnFace = [BaseButton initBaseBtn:IMAGESTRING(@"face") highlight:nil];
    btnFace.frame = CGRectMake(0, 0, grayView.height, grayView.height);
    [btnFace addSignal:PublishBoard.FACE forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:btnFace];
    
    vi = [BeeUIImageView spawn];
    vi.frame = CGRectMake(viTop.left, viTop.bottom+20, viTop.width, 125);
    vi.backgroundColor = [UIColor whiteColor];
    vi.layer.borderColor = textView.layer.borderColor;
    vi.layer.borderWidth = 1;
    vi.layer.borderColor = RGB(212, 212, 212).CGColor;
    vi.userInteractionEnabled = YES;
    [self.view addSubview:vi];
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(0, 44.5, vi.width, 0.5);
    line.backgroundColor = RGB(212, 212, 212);
    [vi addSubview:line];
    
    BeeUIButton *btnAdd = [BeeUIButton spawn];
    btnAdd.frame = CGRectMake(0, 0, 45, 45);
    [btnAdd setImage:IMAGESTRING(@"post_add_btn") forState:UIControlStateNormal];
    [btnAdd addSignal:PublishBoard.ADD forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:btnAdd];
    
    BaseLabel *lbT = [BaseLabel initLabel:@"上传照片" font:FONT(20) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lbT.frame = CGRectMake(btnAdd.right+15, 0, 200, 45);
    [lbT makeTappable:PublishBoard.ADD];
    [vi addSubview:lbT];
    
    [self reloadImages];
    
    BaseButton *btnPost = [BaseButton initBaseBtn:IMAGESTRING(@"btn_green") highlight:IMAGESTRING(@"btn_green_pre") text:@"发 布" textColor:[UIColor whiteColor] font:BOLDFONT(22)];
    btnPost.frame = CGRectMake(vi.left, vi.bottom+30, 300, 40);
    [btnPost addSignal:PublishBoard.POST forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPost];
    btnPost.hidden = NO;
//    if (self.type == PostImageTypeFun) {
//        btnPost.hidden = NO;
//    }
//    else if (self.type == PostImageTypeAlbum) {
//        textView.placeholder = @"分享这一刻您的看法";
//        lbT.text = @"上传相册照片";
//    }
//    else if (self.type == PostImageTypePassport){
//        textView.placeholder = @"输入您的护照信息";
//        lbT.text = @"上传护照照片";
//    }
    
    scrollVPhoto = [[UIScrollView alloc] init];
    scrollVPhoto.frame = CGRectMake(1, lbT.bottom, vi.width-2, vi.height-lbT.bottom);
    [vi addSubview:scrollVPhoto];
}

- (void)reloadImages{
    for (UIView *element in scrollVPhoto.subviews) {
        if (element.tag>100) {
            [element removeFromSuperview];
        }
    }
    
    for (int i = 0; i < arrayImages.count; i++) {
        BeeUIImageView *imgV = [BeeUIImageView spawn];
        imgV.tag = 9527;
        imgV.frame = CGRectMake(5+73*i, 10, 65, 65);
        imgV.image = arrayImages[i];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        [scrollVPhoto addSubview:imgV];
        
        BeeUIButton *btnClose = [BeeUIButton spawn];
        btnClose.tag = 9527+i;
        btnClose.frame = CGRectMake(0, 0, 30, 30);
        btnClose.center = CGPointMake(imgV.right, imgV.top);
        [btnClose setImage:IMAGESTRING(@"post_close_btn")];
        [btnClose addSignal:PublishBoard.DEL forControlEvents:UIControlEventTouchUpInside object:btnClose];
        [scrollVPhoto addSubview:btnClose];
        
        [scrollVPhoto setContentSize:CGSizeMake(imgV.right+10, scrollVPhoto.height)];
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    UIImage * i = [info[@"UIImagePickerControllerOriginalImage"] copy];
    if(i.size.width > 640)
    {
        i = [DataUtils scaleImage:i toScale:640/i.size.width];
    }
    [arrayImages addObject:i];
    //[_arrayURL addObject:@"9527"];
    
    [self reloadImages];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
