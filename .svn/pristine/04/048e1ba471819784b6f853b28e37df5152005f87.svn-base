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
//  AddClipNoteBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/18.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "AddClipNoteBoard.h"
#import "PostImage.h"
#import "SocketData.h"
#import "AppDelegate.h"

#pragma mark -

@interface AddClipNoteBoard()<UITextFieldDelegate>
{
    __weak IBOutlet UIView *bg;
    __weak IBOutlet UIImageView *imgContent;
    __weak IBOutlet UIButton *btnCheck;
    __weak IBOutlet UITextField *myTextField;
    __weak IBOutlet UIView *bgView;
    
    BOOL isCheck;
    PostImage *postImage;
	//<#@private var#>
}
AS_SIGNAL(HIDE)
@end

@implementation AddClipNoteBoard
DEF_SIGNAL(HIDE)


ON_SIGNAL2(AddClipNoteBoard, signal){
    if ([signal is:AddClipNoteBoard.HIDE]){
        [myTextField resignFirstResponder];
        if(bgView.frame.origin.y < 0){
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = bgView.frame;
                rect.origin.y = 0;
                bgView.frame = rect;
            }];
        }
        

    }
}

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    bg.layer.borderWidth = 2;
    bg.layer.borderColor = HEX_RGB(0x40a232).CGColor;
    imgContent.image = _screenImage;
    imgContent.contentMode = UIViewContentModeScaleAspectFit;
    isCheck = YES;
    [self showBackBtn];
    [bg makeTappable:AddClipNoteBoard.HIDE];
    [self.view makeTappable:AddClipNoteBoard.HIDE];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
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
    //[self.navigationController popViewControllerAnimated:YES];
    [self.stack popBoardAnimated:YES];

}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isScreenShots = YES;
    app.isOnClassMode = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isScreenShots = NO;
    app.isPush = YES;
}

-(void)keyboardWillShow:(NSNotification *)n{
    CGFloat h = [[[n userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = bgView.frame;
        rect.origin.y = -150;
        bgView.frame = rect;
    }];
}
-(void)keyboardWillHide:(NSNotification *)n{
    CGFloat h = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = bgView.frame;
        rect.origin.y += 100;
        bgView.frame = rect;
    }];
}

- (IBAction)touchDoneBtn:(id)sender {
    if (kStrTrim(myTextField.text).length == 0) {
        [BeeUIAlertView showMessage:@"请输入笔记说明" cancelTitle:@"确定"];
        return;
    }
    [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在发布"];
    [self postImages];
}
- (IBAction)touchCheckBtn:(id)sender {
    isCheck = !isCheck;
    [btnCheck setImage:isCheck?IMAGESTRING(@"note_public_check"):IMAGESTRING(@"note_public_uncheck") forState:UIControlStateNormal];
}

- (void)postImages{
    if (!postImage) {
        postImage = [[PostImage alloc] init];
    }
    
    postImage.type = PostImageTypeNote;
    postImage.mainCtrl = self;
    postImage.arrayImages = [[NSMutableArray alloc] initWithObjects:[DataUtils scaleImage:_screenImage toScale:960/_screenImage.size.width], nil];
    [postImage postImages];
}

- (void)uploadImageFailed{
    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"服务器繁忙，请稍后重试"];
}

- (void)uploadImageSuccess:(NSMutableArray *)arrayPicInfo{
    NSMutableString *strIds = [[NSMutableString alloc] init];
    for (int i = 0; i<arrayPicInfo.count; i++) {
        [strIds appendString:arrayPicInfo[i][@"id"]];
        if (i<arrayPicInfo.count-1) {
            [strIds appendString:@","];
        }
        
    }
    [self addCourseNote:strIds];
}

- (void)addCourseNote:(NSString *)strImageIds{
    NSMutableDictionary *dict = [SocketData sharedInstance].dictSocket;
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_course_note.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dict[@"courseId"]).PARAM(@"courseSchedId",dict[@"courseSchedId"]).PARAM(@"content",myTextField.text);
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
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                }
            }
        }
    }
}


@end
